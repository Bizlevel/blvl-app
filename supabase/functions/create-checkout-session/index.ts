import "jsr:@supabase/functions-js/edge-runtime.d.ts";

Deno.serve(async (req: Request) => {
  try {
    const { amount, provider } = await req.json();
    if (!amount || !provider) {
      return new Response(
        JSON.stringify({ error: "amount and provider are required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // TODO: интеграция с Kaspi/FreedomPay. Сейчас возвращаем тестовый URL.
    // В проде заменить на реальный вызов SDK/REST платежного провайдера.
    const checkoutUrl = `https://pay.mock/${provider}/checkout?sum=${amount}`;

    return new Response(JSON.stringify({ url: checkoutUrl }), {
      headers: {
        "Content-Type": "application/json",
        "Connection": "keep-alive",
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
}); 