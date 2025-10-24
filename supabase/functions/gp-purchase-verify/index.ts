import "jsr:@supabase/functions-js/edge-runtime.d.ts";

// Типовая заглушка для линтера в среде без Deno-типов
// (в рантайме Supabase Edge переменная Deno доступна)
declare const Deno: any;

// Env: SUPABASE_URL, SUPABASE_ANON_KEY, APPLE_ISSUER_ID, APPLE_KEY_ID, APPLE_PRIVATE_KEY, GOOGLE_SERVICE_ACCOUNT_JSON

type VerifyRequest = {
  // IAP (mobile)
  platform?: "ios" | "android";
  product_id?: string;
  token?: string; // iOS: base64 receipt-data; Android: purchaseToken
  // Web
  purchase_id?: string; // uuid (string)
};

type RpcResponse = { balance_after?: number } | number[] | number | Record<string, unknown>;

const PRODUCT_TO_GP: Record<string, number> = {
  // Старые ID (dev)
  gp_300: 300,
  gp_1400: 1400, // 1000 + 400 бонус
  gp_3000: 3000,
  // Новые ID (App Store / Google Play)
  bizlevelgp_300: 300,
  bizlevelgp_1000: 1400, // в магазине отображается как 1000 + 400 бонус
  bizlevelgp_2000: 3000,
};

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Connection": "keep-alive",
    },
  });
}

async function callPostgrestRpc(functionName: string, args: Record<string, unknown>, userJwt: string) {
  const url = `${Deno.env.get("SUPABASE_URL")}/rest/v1/rpc/${functionName}`;
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !anon || !userJwt) throw new Error("server_misconfigured");
  const resp = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "apikey": anon,
      "Authorization": `Bearer ${userJwt}`,
    },
    body: JSON.stringify(args),
  });
  const data = await resp.json().catch(() => undefined);
  if (!resp.ok) {
    throw new Error(`rpc_failed:${functionName}:${resp.status}:${JSON.stringify(data)}`);
  }
  return data as RpcResponse;
}

function parseBalanceAfter(data: RpcResponse): number | null {
  if (typeof data === "number") return data;
  if (Array.isArray(data) && data.length && typeof data[0] === "number") return Number(data[0]);
  if (typeof data === "object" && data && "balance_after" in data) {
    const v = (data as any).balance_after;
    if (typeof v === "number") return v;
  }
  return null;
}

// -------- iOS: verifyReceipt (production → sandbox fallback) --------
async function verifyAppleReceipt(productId: string, base64Receipt: string) {
  const payload = {
    "receipt-data": base64Receipt,
    // "password": APP_SPECIFIC_SHARED_SECRET // не требуется для consumable
    "exclude-old-transactions": true,
  } as Record<string, unknown>;

  const prod = await fetch("https://buy.itunes.apple.com/verifyReceipt", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  let data = await prod.json();
  if (data?.status === 21007) {
    const sand = await fetch("https://sandbox.itunes.apple.com/verifyReceipt", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    data = await sand.json();
  }
  if (data?.status !== 0) throw new Error(`apple_invalid_receipt:${data?.status}`);

  // Ищем покупку по product_id
  const latest = data?.latest_receipt_info || data?.receipt?.in_app || [];
  const items = Array.isArray(latest) ? latest : [];
  const match = items.find((x: any) => x.product_id === productId);
  if (!match) throw new Error("apple_product_mismatch");
  const transactionId = String(match.transaction_id || match.original_transaction_id || "");
  if (!transactionId) throw new Error("apple_no_transaction_id");
  return { transactionId };
}

// -------- Android: Google Play Purchases.products.get --------
async function verifyGooglePurchase(productId: string, purchaseToken: string, packageName?: string) {
  const svcJson = Deno.env.get("GOOGLE_SERVICE_ACCOUNT_JSON");
  if (!svcJson) throw new Error("google_service_account_missing");
  const svc = JSON.parse(svcJson);

  // Получаем OAuth2 access_token через JWT Bearer
  const now = Math.floor(Date.now() / 1000);
  const aud = "https://oauth2.googleapis.com/token";
  const scope = "https://www.googleapis.com/auth/androidpublisher";
  const jwtHeader = { alg: "RS256", typ: "JWT" };
  const jwtClaim = {
    iss: svc.client_email,
    scope,
    aud,
    iat: now,
    exp: now + 3600,
  };
  const enc = (obj: unknown) => btoa(String.fromCharCode(...new TextEncoder().encode(JSON.stringify(obj))));
  const toUint8 = (s: string) => new TextEncoder().encode(s);
  const pem = svc.private_key as string; // -----BEGIN PRIVATE KEY----- ...
  const pkcs8 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\n/g, "");
  const raw = Uint8Array.from(atob(pkcs8), c => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "pkcs8",
    raw,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const unsigned = `${enc(jwtHeader)}.${enc(jwtClaim)}`;
  const sigBuf = await crypto.subtle.sign({ name: "RSASSA-PKCS1-v1_5" }, key, toUint8(unsigned));
  const signature = btoa(String.fromCharCode(...new Uint8Array(sigBuf)));
  const assertion = `${unsigned}.${signature}`;

  const tokenResp = await fetch(aud, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion }),
  });
  const tokenJson = await tokenResp.json();
  if (!tokenResp.ok) throw new Error(`google_oauth_failed:${tokenResp.status}:${JSON.stringify(tokenJson)}`);
  const accessToken = tokenJson.access_token as string;

  // Имя пакета: если не передали, извлекаем из переменной окружения, иначе обязателен параметр
  const pkg = packageName || Deno.env.get("ANDROID_PACKAGE_NAME");
  if (!pkg) throw new Error("android_package_missing");

  const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${pkg}/purchases/products/${productId}/tokens/${purchaseToken}`;
  const pr = await fetch(url, { headers: { Authorization: `Bearer ${accessToken}` } });
  const prJson = await pr.json();
  if (!pr.ok) throw new Error(`google_purchase_failed:${pr.status}:${JSON.stringify(prJson)}`);

  // purchaseState: 0 purchased, 1 canceled, 2 pending
  if (Number(prJson.purchaseState) !== 0) throw new Error("google_not_purchased");
  // consumptionState: 0 yet to be consumed, 1 consumed (для consumables)
  // Но мы опираемся на идемпотентный кредит у себя, так что допускается повтор.

  const orderId = String(prJson.orderId || purchaseToken);
  return { transactionId: orderId };
}

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-user-jwt, apikey, content-type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
      },
    });
  }
  try {
    const body = (await req.json()) as VerifyRequest;
    const userJwt = req.headers.get("x-user-jwt") || "";
    if (!userJwt) return jsonResponse({ error: "no_user_jwt" }, 401);

    // --- Web branch: verify by purchase_id only ---
    if (body?.purchase_id && !body.platform && !body.product_id && !body.token) {
      const rpcData = await callPostgrestRpc("gp_purchase_verify", {
        p_purchase_id: body.purchase_id,
      }, userJwt);
      const balance = parseBalanceAfter(rpcData);
      if (balance == null) return jsonResponse({ error: "rpc_no_balance" }, 500);
      return new Response(JSON.stringify({ balance_after: balance }), {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          'Access-Control-Allow-Origin': '*',
        },
      });
    }

    // --- IAP branch (mobile) ---
    if (!body?.platform || !body?.product_id || !body?.token) {
      return jsonResponse({ error: "invalid_request" }, 400);
    }
    const amount = PRODUCT_TO_GP[body.product_id];
    if (!amount) return jsonResponse({ error: "unknown_product" }, 400);

    let transactionId = "";
    if (body.platform === "ios") {
      const r = await verifyAppleReceipt(body.product_id, body.token);
      transactionId = r.transactionId;
    } else if (body.platform === "android") {
      const r = await verifyGooglePurchase(body.product_id, body.token);
      transactionId = r.transactionId;
    } else {
      return jsonResponse({ error: "unsupported_platform" }, 400);
    }

    const purchaseId = `${body.platform}:${body.product_id}:${transactionId}`;

    // Новая RPC: идемпотентный кредит по purchaseId
    const rpcData = await callPostgrestRpc("gp_iap_credit", {
      p_purchase_id: purchaseId,
      p_amount_gp: amount,
    }, userJwt);
    const balance = parseBalanceAfter(rpcData);
    if (balance == null) return jsonResponse({ error: "rpc_no_balance" }, 500);

    return new Response(JSON.stringify({ balance_after: balance }), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        'Access-Control-Allow-Origin': '*',
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String((e as any)?.message || e) }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        'Access-Control-Allow-Origin': '*',
      },
    });
  }
});


