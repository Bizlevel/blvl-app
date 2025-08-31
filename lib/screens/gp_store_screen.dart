import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/services/gp_service.dart';

class GpStoreScreen extends ConsumerWidget {
  const GpStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин GP')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GpPackTile(
              title: '300 GP', amountKzt: 3000, packageId: 'gp_300', ref: ref),
          const SizedBox(height: 12),
          _GpPackTile(
              title: '1400 GP (популярный)',
              amountKzt: 9960,
              packageId: 'gp_1200',
              ref: ref),
          const SizedBox(height: 12),
          _GpPackTile(
              title: '3000 GP',
              amountKzt: 25000,
              packageId: 'gp_2500',
              ref: ref),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                // Пример: пользователь вводит purchase_id после возврата из оплаты
                // Для MVP попросим вставить purchase_id вручную (или сохранить его в состоянии приложения)
                final idController = TextEditingController();
                final ctx = context;
                await showDialog<void>(
                  context: ctx,
                  builder: (dCtx) {
                    return AlertDialog(
                      title: const Text('Проверить покупку'),
                      content: TextField(
                        controller: idController,
                        decoration: const InputDecoration(
                          hintText: 'Вставьте purchase_id',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(dCtx).pop();
                            try {
                              final gp = GpService(Supabase.instance.client);
                              await gp.verifyPurchase(
                                  purchaseId: idController.text.trim());
                              if (!ctx.mounted) return;
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                    content: Text('Покупка подтверждена')),
                              );
                              // Инвалидация баланса
                              final container = ProviderScope.containerOf(ctx);
                              container.invalidate(gpBalanceProvider);
                            } catch (_) {
                              if (!ctx.mounted) return;
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                    content: Text('Не удалось подтвердить')),
                              );
                            }
                          },
                          child: const Text('Проверить'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.verified),
              label: const Text('Проверить покупку'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GpPackTile extends StatelessWidget {
  final String title;
  final int amountKzt;
  final String packageId;
  final WidgetRef ref;
  const _GpPackTile(
      {required this.title,
      required this.amountKzt,
      required this.packageId,
      required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('₸$amountKzt'),
        trailing: ElevatedButton(
          onPressed: () async {
            try {
              // Инициируем покупку через Edge Function
              final gp = GpService(Supabase.instance.client);
              final init =
                  await gp.initPurchase(packageId: packageId, provider: 'epay');
              final urlStr = init['payment_url'] ?? '';
              final purchaseId = init['purchase_id'] ?? '';
              final url = Uri.tryParse(urlStr);

              // ТЕСТОВЫЙ РЕЖИМ (без провайдера): если вернулся mock-хост,
              // сразу выполняем verify для сквозной проверки флоу без банка.
              final isMock =
                  url != null && url.host.contains('payments.example.com');
              if (isMock && purchaseId.isNotEmpty) {
                try {
                  final balance =
                      await gp.verifyPurchase(purchaseId: purchaseId);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Покупка подтверждена (тест), баланс: $balance')),
                  );
                  // Инвалидация баланса
                  final container = ProviderScope.containerOf(context);
                  container.invalidate(gpBalanceProvider);
                  return;
                } catch (_) {
                  // Падаем в обычный путь ниже
                }
              }

              // ПРОД‑РЕЖИМ/ОБЫЧНЫЙ: открываем URL оплаты, дальше пользователь
              // может вернуться и нажать «Проверить покупку».
              if (url != null && await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('После оплаты нажмите «Проверить покупку»')),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Не удалось создать оплату')),
              );
            }
          },
          child: const Text('Купить'),
        ),
      ),
    );
  }
}
