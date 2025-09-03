import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GpStoreScreen extends ConsumerWidget {
  const GpStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин GP')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Короткий вводный блок «Что такое GP»
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/gp_coin.svg',
                    width: 36, height: 36),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'GP — внутренняя валюта BizLevel. Сообщения Лео/Максу стоят 1 GP, а также GP открывают доступ к новым этажам.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _GpPlanCard(
            title: 'СТАРТ:',
            gpLabel: '300',
            descriptionTitle: 'Идеально для:',
            bullets: const [
              'Обдумать идеи',
              'Быстрых консультаций',
              'Получить второе мнение',
            ],
            italicNote: 'Каждый успешный бизнес начинался с первого шага',
            priceLabel: '₸3 000',
            onSelect: () => _startPurchase(context, ref, 'gp_300', 3000),
          ),
          const SizedBox(height: 12),
          _GpPlanCard(
            title: 'РАЗГОН:',
            gpLabel: '1000 + 400 бонус',
            descriptionTitle: 'Достаточно чтобы:',
            bullets: const [
              'Поставить и достичь цели за 28 дней',
              '400+ персональных советов',
              'Открыть новые горизонты',
            ],
            italicNote: 'Выбор 80% предпринимателей',
            priceLabel: '₸9 960',
            highlight: true,
            onSelect: () => _startPurchase(context, ref, 'gp_1400', 9960),
          ),
          const SizedBox(height: 12),
          _GpPlanCard(
            title: 'ТРАНСФОРМАЦИЯ:',
            gpLabel: '2000 + 1000 бонус',
            descriptionTitle: 'Полная перезагрузка',
            bullets: const [
              'От хаоса к системе',
              'От идеи к масштабу',
              'От мечты к результату',
            ],
            italicNote: 'Для тех, кто настроен серьезно',
            priceLabel: '₸19 960',
            onSelect: () => _startPurchase(context, ref, 'gp_3000', 19960),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  final box = Hive.box('gp');
                  final lastId = (box.get('last_purchase_id') as String?) ?? '';
                  if (lastId.isEmpty) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Нет активной покупки для проверки. Выберите пакет и оформите оплату.')));
                    return;
                  }
                  await Sentry.addBreadcrumb(Breadcrumb(
                    message: 'gp_purchase_verify_click',
                    level: SentryLevel.info,
                    data: {
                      'purchase_id':
                          lastId.substring(0, lastId.length.clamp(0, 8))
                    },
                  ));
                  final gp = GpService(Supabase.instance.client);
                  final balance = await gp.verifyPurchase(purchaseId: lastId);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Покупка подтверждена, баланс: $balance')),
                  );
                  final container = ProviderScope.containerOf(context);
                  container.invalidate(gpBalanceProvider);
                } catch (e) {
                  if (!context.mounted) return;
                  final msg = e.toString().contains('gp_purchase_not_found')
                      ? 'Покупка не найдена. Завершите оплату и попробуйте снова.'
                      : 'Не удалось подтвердить. Проверьте интернет или попробуйте позже.';
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(msg)));
                }
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

Future<void> _startPurchase(
  BuildContext context,
  WidgetRef ref,
  String packageId,
  int amountKzt,
) async {
  try {
    final gp = GpService(Supabase.instance.client);
    final init = await gp.initPurchase(packageId: packageId, provider: 'epay');
    final urlStr = init['payment_url'] ?? '';
    final purchaseId = init['purchase_id'] ?? '';
    final url = Uri.tryParse(urlStr);

    final isMock = url != null && url.host.contains('payments.example.com');
    if (isMock && purchaseId.isNotEmpty) {
      try {
        final balance = await gp.verifyPurchase(purchaseId: purchaseId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Покупка подтверждена (тест), баланс: $balance')),
        );
        final container = ProviderScope.containerOf(context);
        container.invalidate(gpBalanceProvider);
        return;
      } catch (_) {
        // Переходим в обычный путь
      }
    }

    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('После оплаты нажмите «Проверить покупку»')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не удалось создать оплату')),
    );
  }
}

class _GpPlanCard extends StatelessWidget {
  final String title;
  final String gpLabel; // "300", "1200 + 200 бонус", "3000"
  final String descriptionTitle;
  final List<String> bullets;
  final String italicNote;
  final String priceLabel; // форматированная строка цены
  final VoidCallback onSelect;
  final bool highlight;

  const _GpPlanCard({
    required this.title,
    required this.gpLabel,
    required this.descriptionTitle,
    required this.bullets,
    required this.italicNote,
    required this.priceLabel,
    required this.onSelect,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: highlight ? 3 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 340;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: onSelect,
                            child: Text(priceLabel,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/gp_coin.svg',
                            width: 18, height: 18),
                        const SizedBox(width: 6),
                        _GpLabelText(label: gpLabel, compact: true),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/images/gp_coin.svg',
                          width: 20, height: 20),
                      const SizedBox(width: 6),
                      _GpLabelText(label: gpLabel, compact: true),
                    ],
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onSelect,
                      child: Text(
                        priceLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Text(
              descriptionTitle,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          b,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 6),
            Text(
              italicNote,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _GpLabelText extends StatelessWidget {
  final String label;
  final bool compact;
  const _GpLabelText({required this.label, this.compact = false});

  // Разбиваем строку на основную часть и "+ N бонус" (курсив)
  (String, String?) _splitBonus(String s) {
    final idx = s.indexOf(' + ');
    if (idx <= 0) return (s, null);
    final main = s.substring(0, idx);
    final bonus = s.substring(idx + 1); // "N бонус" или "400 бонус"
    return (main, bonus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = _splitBonus(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(parts.$1,
            style: (compact
                    ? theme.textTheme.titleSmall
                    : theme.textTheme.titleLarge)
                ?.copyWith(fontWeight: FontWeight.w700)),
        if (parts.$2 != null) ...[
          const SizedBox(width: 4),
          Text('+ ${parts.$2!.replaceFirst('+ ', '')}',
              style: (compact
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleLarge)
                  ?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}
