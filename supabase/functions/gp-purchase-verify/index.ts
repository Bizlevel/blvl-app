import "jsr:@supabase/functions-js/edge-runtime.d.ts";

// Типовая заглушка для линтера в среде без Deno-типов
// (в рантайме Supabase Edge переменная Deno доступна)
declare const Deno: any;

// Env: SUPABASE_URL, SUPABASE_ANON_KEY, APPLE_ISSUER_ID, APPLE_KEY_ID, APPLE_PRIVATE_KEY, APPLE_BUNDLE_ID, GOOGLE_SERVICE_ACCOUNT_JSON

type VerifyRequest = {
  // IAP (mobile)
  platform?: "ios" | "android";
  product_id?: string;
  token?: string; // iOS: base64 receipt-data; Android: purchaseToken
  // iOS StoreKit2: allow passing transaction id directly (preferred)
  transaction_id?: string;
  // Android package name (optional, overrides env ANDROID_PACKAGE_NAME)
  package_name?: string;
  // Web
  purchase_id?: string; // uuid (string)
};

type RpcResponse = { balance_after?: number } | number[] | number | Record<string, unknown>;

const PRODUCT_TO_GP: Record<string, number> = {
  // Старые ID (dev)
  gp_300: 300,
  gp_1000: 1400,
  gp_2000: 3000,
  gp_1400: 1400, // legacy alias
  gp_3000: 3000,
  // Новые ID (App Store / Google Play)
  bizlevelgp_300: 300,
  bizlevelgp_1000: 1400, // в магазине отображается как 1000 + 400 бонус
  bizlevelgp_2000: 3000,
};

function extractUserJwt(req: Request): string | null {
  const h = req.headers;
  const x = (h.get("x-user-jwt") || "").trim();
  if (x.length > 20) return x;
  const auth = h.get("authorization") || h.get("Authorization") || "";
  if (auth.startsWith("Bearer ")) {
    const token = auth.replace("Bearer ", "").trim();
    const anon = (Deno.env.get("SUPABASE_ANON_KEY") || "").trim();
    const service = (Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "").trim();
    if (token && token !== anon && token !== service) return token;
  }
  return null;
}

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Connection": "keep-alive",
    },
  });
}

async function callPostgrestRpc(
  functionName: string,
  args: Record<string, unknown>,
  userJwt: string,
) {
  const url = `${Deno.env.get("SUPABASE_URL")}/rest/v1/rpc/${functionName}`;
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !anon || !userJwt) throw new Error("server_misconfigured");
  const resp = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "apikey": anon,
      "Authorization": `Bearer ${userJwt}`,
      "Prefer": "return=representation",
    },
    body: JSON.stringify(args),
  });
  const rawText = await resp.text();
  const data = rawText ? JSON.parse(rawText) : undefined;
  if (!resp.ok) {
    throw new Error(`rpc_failed:${functionName}:${resp.status}:${rawText}`);
  }
  return data as RpcResponse;
}

function _asNumber(v: unknown): number | null {
  if (typeof v === "number" && Number.isFinite(v)) return v;
  if (typeof v === "string") {
    const t = v.trim();
    if (!t) return null;
    const n = Number(t);
    if (Number.isFinite(n)) return n;
  }
  return null;
}

function parseBalanceAfter(data: RpcResponse): number | null {
  // PostgREST может вернуть:
  // - число (scalar)
  // - массив чисел
  // - массив объектов [{ balance_after: 123 }] для RETURNS TABLE
  // - массив объектов [{ balance: 123, ... }] для gp_balance()
  // - объект { balance_after: 123 } (редко, но поддержим)
  // - объект { balance: 123 } (редко, но поддержим)
  const n0 = _asNumber(data as unknown);
  if (n0 != null) return n0;

  if (Array.isArray(data)) {
    if (!data.length) return null;
    const first = data[0] as any;
    const n1 = _asNumber(first);
    if (n1 != null) return n1;
    if (first && typeof first === "object") {
      const ba = _asNumber(first.balance_after);
      if (ba != null) return ba;
      const b = _asNumber(first.balance);
      if (b != null) return b;
    }
    return null;
  }

  if (typeof data === "object" && data) {
    const o = data as any;
    const ba = _asNumber(o.balance_after);
    if (ba != null) return ba;
    const b = _asNumber(o.balance);
    if (b != null) return b;
  }

  return null;
}

function toHex(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  const hex: string[] = [];
  for (let i = 0; i < bytes.length; i++) {
    const h = bytes[i].toString(16).padStart(2, "0");
    hex.push(h);
  }
  return hex.join("");
}

async function insertLog(data: Record<string, unknown>, userJwt: string) {
  try {
    const url = `${Deno.env.get("SUPABASE_URL")}/rest/v1/iap_verify_logs`;
    const anon = Deno.env.get("SUPABASE_ANON_KEY");
    const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!url || !anon) return;
    // attempt as user (respect RLS) if JWT provided
    let ok = false;
    if (userJwt && userJwt.length > 20) {
      const r1 = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "apikey": anon,
          "Authorization": `Bearer ${userJwt}`,
          "Prefer": "resolution=merge-duplicates"
        },
        body: JSON.stringify(data),
      }).catch(() => undefined);
      ok = !!(r1 && r1.ok);
    }
    // fallback with service role (bypass RLS) to avoid losing diagnostics
    if (!ok && service) {
      await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "apikey": anon,
          "Authorization": `Bearer ${service}`,
          "Prefer": "resolution=merge-duplicates"
        },
        body: JSON.stringify(data),
      }).catch(() => undefined);
    }
  } catch {
    // swallow any diagnostics errors
  }
}

// -------- Apple Server API (StoreKit2) --------
type AppleServerEnv = "prod" | "sandbox";

function _b64UrlEncodeBytes(bytes: Uint8Array): string {
  // btoa expects binary string (latin1)
  let binary = "";
  for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
  const b64 = btoa(binary);
  return b64.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function _b64UrlEncodeJson(obj: unknown): string {
  return _b64UrlEncodeBytes(new TextEncoder().encode(JSON.stringify(obj)));
}

function _readDerLen(bytes: Uint8Array, offset: number): { len: number; next: number } {
  const first = bytes[offset];
  if (first < 0x80) return { len: first, next: offset + 1 };
  const num = first & 0x7f;
  if (num === 0 || num > 2) throw new Error("ecdsa_der_len_invalid");
  let len = 0;
  for (let i = 0; i < num; i++) len = (len << 8) | bytes[offset + 1 + i];
  return { len, next: offset + 1 + num };
}

function _trimLeadingZeros(b: Uint8Array): Uint8Array {
  let i = 0;
  while (i < b.length - 1 && b[i] === 0x00) i++;
  return b.slice(i);
}

function _leftPad(b: Uint8Array, size: number): Uint8Array {
  if (b.length === size) return b;
  if (b.length > size) return b.slice(b.length - size);
  const out = new Uint8Array(size);
  out.set(b, size - b.length);
  return out;
}

function _ecdsaDerToJose(sigDer: Uint8Array, size = 32): Uint8Array {
  // If already raw (r||s), just return.
  if (sigDer.length === size * 2) return sigDer;
  if (sigDer.length < 8 || sigDer[0] !== 0x30) throw new Error("ecdsa_der_invalid");
  const { len: seqLen, next: p0 } = _readDerLen(sigDer, 1);
  if (p0 + seqLen !== sigDer.length) {
    // tolerate, but keep parsing
  }
  let p = p0;
  if (sigDer[p] !== 0x02) throw new Error("ecdsa_der_invalid_r");
  const { len: rLen, next: pR0 } = _readDerLen(sigDer, p + 1);
  const r = sigDer.slice(pR0, pR0 + rLen);
  p = pR0 + rLen;
  if (sigDer[p] !== 0x02) throw new Error("ecdsa_der_invalid_s");
  const { len: sLen, next: pS0 } = _readDerLen(sigDer, p + 1);
  const s = sigDer.slice(pS0, pS0 + sLen);

  const rFixed = _leftPad(_trimLeadingZeros(r), size);
  const sFixed = _leftPad(_trimLeadingZeros(s), size);
  const out = new Uint8Array(size * 2);
  out.set(rFixed, 0);
  out.set(sFixed, size);
  return out;
}

function _b64UrlDecodeToBytes(b64url: string): Uint8Array {
  const s = (b64url || "").trim().replace(/-/g, "+").replace(/_/g, "/");
  const padLen = (4 - (s.length % 4)) % 4;
  const padded = s + "=".repeat(padLen);
  const bin = atob(padded);
  const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
}

function _looksLikeJws(token: string): boolean {
  const t = (token || "").trim();
  if (t.length < 20) return false;
  // JWS has 3 dot-separated parts and commonly starts with "eyJ" (base64url of {"alg":...})
  return t.split(".").length === 3 && t.startsWith("eyJ");
}

function _decodeJwsPayload(token: string): Record<string, unknown> | null {
  try {
    const parts = token.split(".");
    if (parts.length !== 3) return null;
    const payloadBytes = _b64UrlDecodeToBytes(parts[1]);
    const json = new TextDecoder().decode(payloadBytes);
    const parsed = JSON.parse(json);
    return parsed && typeof parsed === "object" ? (parsed as Record<string, unknown>) : null;
  } catch {
    return null;
  }
}

function _normalizePemToDerBytes(pemOrB64: string): Uint8Array {
  const raw = (pemOrB64 || "").trim();
  if (!raw) throw new Error("apple_key_missing");

  // If it's a PEM with headers, strip them. If it's base64-only, keep as is.
  const cleaned = raw
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\r?\n/g, "")
    .replace(/\\n/g, "")
    .trim();
  if (!cleaned) throw new Error("apple_key_missing");
  // At this point cleaned is base64 of PKCS8 DER.
  const bin = atob(cleaned);
  const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
}

let _appleJwtCache: { token: string; exp: number } | null = null;
let _appleKeyCache: CryptoKey | null = null;

async function _getAppleKey(): Promise<CryptoKey> {
  if (_appleKeyCache) return _appleKeyCache;
  const pem = Deno.env.get("APPLE_PRIVATE_KEY") || "";
  const keyBytes = _normalizePemToDerBytes(pem);
  const key = await crypto.subtle.importKey(
    "pkcs8",
    keyBytes,
    { name: "ECDSA", namedCurve: "P-256" },
    false,
    ["sign"],
  );
  _appleKeyCache = key;
  return key;
}

async function _buildAppleServerJwt(): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  // Cache token for ~4 minutes to reduce crypto/sign overhead.
  if (_appleJwtCache && _appleJwtCache.exp > now + 30) return _appleJwtCache.token;

  const issuerId = (Deno.env.get("APPLE_ISSUER_ID") || "").trim();
  const keyId = (Deno.env.get("APPLE_KEY_ID") || "").trim();
  const bundleId = (Deno.env.get("APPLE_BUNDLE_ID") || "bizlevel.kz").trim();
  if (!issuerId) throw new Error("apple_issuer_missing");
  if (!keyId) throw new Error("apple_key_id_missing");
  if (!bundleId) throw new Error("apple_bundle_missing");

  const header = { alg: "ES256", kid: keyId, typ: "JWT" };
  const payload = {
    iss: issuerId,
    iat: now,
    exp: now + 300, // 5 minutes
    aud: "appstoreconnect-v1",
    bid: bundleId,
  };

  const unsigned = `${_b64UrlEncodeJson(header)}.${_b64UrlEncodeJson(payload)}`;
  const key = await _getAppleKey();
  const sigBuf = await crypto.subtle.sign(
    { name: "ECDSA", hash: "SHA-256" },
    key,
    new TextEncoder().encode(unsigned),
  );
  // WebCrypto returns DER encoded ECDSA signature, but JWT ES256 expects raw (r||s).
  const sigRaw = _ecdsaDerToJose(new Uint8Array(sigBuf), 32);
  const sig = _b64UrlEncodeBytes(sigRaw);
  const token = `${unsigned}.${sig}`;
  _appleJwtCache = { token, exp: payload.exp };
  return token;
}

async function _appleGetTransactionInfo(
  transactionId: string,
  env: AppleServerEnv,
): Promise<Record<string, unknown>> {
  const jwt = await _buildAppleServerJwt();
  const base =
    env === "sandbox"
      ? "https://api.storekit-sandbox.itunes.apple.com"
      : "https://api.storekit.itunes.apple.com";
  const url = `${base}/inApps/v1/transactions/${encodeURIComponent(transactionId)}`;
  const resp = await fetch(url, {
    method: "GET",
    headers: { Authorization: `Bearer ${jwt}` },
  });
  const text = await resp.text();
  let data: any = null;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = null;
  }
  if (!resp.ok) {
    // Preserve useful info for caller (but don't log secrets).
    const code = data?.errorCode || data?.error || resp.status;
    throw new Error(`apple_server_api_failed:${env}:${resp.status}:${code}`);
  }
  if (!data || typeof data !== "object") {
    throw new Error(`apple_server_api_malformed:${env}`);
  }
  return data as Record<string, unknown>;
}

function _decodeAppleSignedInfo(jws: string): Record<string, unknown> | null {
  // For Apple Server API response, we trust the HTTPS response + signed request.
  // We decode payload for field checks; cryptographic verification can be added later if needed.
  return _decodeJwsPayload(jws);
}

async function verifyAppleTransactionViaServerApi(
  productId: string,
  transactionId: string,
  dbgLogStep?: (step: string, error?: string | null) => Promise<void>,
): Promise<{ transactionId: string }> {
  const tryEnv = async (env: AppleServerEnv) => {
    await dbgLogStep?.(`apple_server_api_start:${env}`);
    const info = await _appleGetTransactionInfo(transactionId, env);
    const signed = String((info as any)?.signedTransactionInfo || "");
    if (!signed) throw new Error(`apple_server_api_no_signed_info:${env}`);
    const payload = _decodeAppleSignedInfo(signed);
    if (!payload) throw new Error(`apple_server_api_bad_signed_info:${env}`);

    const pId = String((payload as any)?.productId || "");
    if (pId && pId !== productId) throw new Error("apple_product_mismatch");

    const txId = String((payload as any)?.transactionId || (payload as any)?.originalTransactionId || "");
    if (txId && txId !== transactionId) throw new Error("apple_transaction_mismatch");

    const bundleId = (Deno.env.get("APPLE_BUNDLE_ID") || "bizlevel.kz").trim();
    const bid = String((payload as any)?.bundleId || "");
    if (bundleId && bid && bid !== bundleId) throw new Error("apple_bundle_mismatch");

    await dbgLogStep?.(`apple_server_api_ok:${env}`);
    return { transactionId };
  };

  try {
    return await tryEnv("prod");
  } catch (e) {
    const msg = String((e as any)?.message || e);
    // retry sandbox on any server-api failure; keeps behavior robust in review/sandbox.
    await dbgLogStep?.("apple_server_api_retry_sandbox", msg);
    return await tryEnv("sandbox");
  }
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
  const pem = String(svc.private_key || ""); // may contain \n or \\n
  // Normalize PEM: strip headers/footers and any newline encodings (\n or \\n or \r\n)
  const pkcs8 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\r?\n/g, "")
    .replace(/\\n/g, "");
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
  // Диагностические поля, которые не требуют повторного чтения тела запроса
  let dbgUserJwt = "";
  let dbgPlatform = "";
  let dbgProductId = "";
  let dbgPackageName = "";
  let dbgTokenPrefix = "";
  let dbgTokenHash = "";
  try {
    const logStep = async (step: string, error?: string | null) => {
      if (!dbgUserJwt) return;
      await insertLog({
        platform: dbgPlatform,
        product_id: dbgProductId,
        package_name: dbgPackageName,
        token_prefix: dbgTokenPrefix,
        token_hash: dbgTokenHash,
        step,
        error: error || undefined,
      }, dbgUserJwt);
    };
    const body = (await req.json()) as VerifyRequest;
    dbgPlatform = body?.platform || "";
    dbgProductId = body?.product_id || "";
    dbgPackageName = body?.package_name || "";
    if (body?.token) {
      dbgTokenPrefix = body.token.slice(0, 10);
      try {
        dbgTokenHash = toHex(await crypto.subtle.digest("SHA-256", new TextEncoder().encode(body.token)));
      } catch (_) {}
    }
    // Принимаем JWT как из x-user-jwt, так и из Authorization (если это не anon/service ключ)
    dbgUserJwt = extractUserJwt(req) || "";
    if (!dbgUserJwt) {
      await logStep("error", "no_user_jwt");
      return jsonResponse({ error: "no_user_jwt" }, 401);
    }
    // стартовый лог
    try {
      await insertLog({
        platform: dbgPlatform,
        product_id: dbgProductId,
        package_name: dbgPackageName,
        token_prefix: dbgTokenPrefix,
        token_hash: dbgTokenHash,
        step: "start"
      }, dbgUserJwt);
    } catch (_) {}

    // --- Web branch: verify by purchase_id only ---
    if (body?.purchase_id && !body.platform && !body.product_id && !body.token) {
      const rpcData = await callPostgrestRpc("gp_purchase_verify", {
        p_purchase_id: body.purchase_id,
      }, dbgUserJwt);
      const balance = parseBalanceAfter(rpcData);
      if (balance == null) {
        await logStep("error", "rpc_no_balance");
        return jsonResponse({ error: "rpc_no_balance" }, 500);
      }
      await logStep("web_credited");
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
      await logStep("error", "invalid_request");
      return jsonResponse({ error: "invalid_request" }, 400);
    }
    const amount = PRODUCT_TO_GP[body.product_id];
    if (!amount) {
      await logStep("error", `unknown_product:${body.product_id}`);
      return jsonResponse({ error: "unknown_product" }, 400);
    }

    let transactionId = "";
    if (body.platform === "ios") {
      // StoreKit2 часто возвращает JWS (eyJ...) вместо base64 receipt.
      // Поддерживаем:
      // 1) transaction_id (если клиент передал)
      // 2) token=JWS -> decode payload to get transactionId
      // 3) token=base64 receipt -> legacy verifyReceipt
      const directTx = String(body.transaction_id || "").trim();
      if (directTx) {
        const r = await verifyAppleTransactionViaServerApi(
          body.product_id,
          directTx,
          logStep,
        );
        transactionId = r.transactionId;
      } else if (_looksLikeJws(body.token)) {
        const payload = _decodeJwsPayload(body.token);
        const txFromJws = String((payload as any)?.transactionId || (payload as any)?.originalTransactionId || "").trim();
        if (!txFromJws) throw new Error("apple_no_transaction_id");
        const r = await verifyAppleTransactionViaServerApi(
          body.product_id,
          txFromJws,
          logStep,
        );
        transactionId = r.transactionId;
      } else {
        const r = await verifyAppleReceipt(body.product_id, body.token);
        transactionId = r.transactionId;
      }
    } else if (body.platform === "android") {
      const r = await verifyGooglePurchase(body.product_id, body.token, body.package_name);
      transactionId = r.transactionId;
    } else {
      await logStep("error", `unsupported_platform:${body.platform}`);
      return jsonResponse({ error: "unsupported_platform" }, 400);
    }

    const purchaseId = `${body.platform}:${body.product_id}:${transactionId}`;

    // Новая RPC: идемпотентный кредит по purchaseId
    const rpcData = await callPostgrestRpc("gp_iap_credit", {
      p_purchase_id: purchaseId,
      p_amount_gp: amount,
    }, dbgUserJwt);
    let balance = parseBalanceAfter(rpcData);
    if (balance == null) {
      // fallback: запрос баланса напрямую
      try {
        const balData = await callPostgrestRpc("gp_balance", {}, dbgUserJwt);
        const row = parseBalanceAfter(balData);
        if (row != null) balance = row;
      } catch (_) { /* ignore */ }
    }
    if (balance == null) {
      await logStep("error", "rpc_no_balance");
      return jsonResponse({ error: "rpc_no_balance" }, 500);
    }
    try {
      await insertLog({
        platform: dbgPlatform,
        product_id: dbgProductId,
        package_name: dbgPackageName,
        token_prefix: dbgTokenPrefix,
        token_hash: dbgTokenHash,
        step: "credited",
        http_status: 200
      }, dbgUserJwt);
    } catch (_) {}

    return new Response(JSON.stringify({ balance_after: balance }), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        'Access-Control-Allow-Origin': '*',
      },
    });
  } catch (e) {
    const err = String((e as any)?.message || e);
    try {
      await insertLog({
        platform: dbgPlatform,
        product_id: dbgProductId,
        package_name: dbgPackageName,
        token_prefix: dbgTokenPrefix,
        token_hash: dbgTokenHash,
        step: "error",
        error: err
      }, dbgUserJwt);
    } catch (_) { /* ignore logging failure */ }
    return new Response(JSON.stringify({ error: String((e as any)?.message || e) }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        'Access-Control-Allow-Origin': '*',
      },
    });
  }
});


