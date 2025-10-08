import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/services/iap_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:in_app_purchase/in_app_purchase.dart';

class GpStoreScreen extends ConsumerStatefulWidget {
  const GpStoreScreen({super.key});

  @override
  ConsumerState<GpStoreScreen> createState() => _GpStoreScreenState();
}

class _GpStoreScreenState extends ConsumerState<GpStoreScreen> {
  String? _selectedPackageId;
  int? _selectedAmount;
  String? _selectedLabel;
  bool _faqExpanded = false;
  final Map<String, ProductDetails> _productMap = {};
  final Map<String, Map<String, dynamic>> _serverPricing = {};

  @override
  void initState() {
    super.initState();
    _loadIapProducts();
    _loadServerPricing();
  }

  Future<void> _loadIapProducts() async {
    try {
      final platform = IapService.currentPlatform();
      if (platform == 'ios' || platform == 'android') {
        final iap = IapService.instance;
        if (await iap.isAvailable()) {
          final resp = await iap.queryProducts({
            'bizlevelgp_300',
            'bizlevelgp_1000',
            'bizlevelgp_2000',
          });
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_iap_products_loaded',
              data: {
                'found': resp.productDetails.map((e) => e.id).toList(),
                'not_found': resp.notFoundIDs,
              },
            ));
          } catch (_) {}
          if (mounted) {
            setState(() {
              for (final p in resp.productDetails) {
                _productMap[p.id] = p;
              }
            });
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _loadServerPricing() async {
    try {
      // Web или универсальный fallback — читаем витрину KZT
      final rows = await Supabase.instance.client
          .from('store_pricing')
          .select('product_id, amount_kzt, amount_gp, bonus_gp, title')
          .eq('is_active', true);
      final list = List<Map<String, dynamic>>.from(
          rows.map((e) => Map<String, dynamic>.from(e as Map)));
      if (!mounted) return;
      setState(() {
        for (final r in list) {
          _serverPricing[r['product_id'] as String] = r;
        }
      });
    } catch (_) {}
  }

  String _priceLabelFor(String productId, String fallback) {
    final platform = IapService.currentPlatform();
    if (platform == 'ios' || platform == 'android') {
      final p = _productMap[productId];
      if (p != null && p.price.isNotEmpty) return p.price;
    }
    final sp = _serverPricing[productId];
    if (sp != null) {
      final amount = (sp['amount_kzt'] as num?)?.toInt() ?? 0;
      if (amount > 0) return '₸${_fmtKzt(amount)}';
    }
    return fallback;
  }

  String _fmtKzt(int amount) {
    // Простое форматирование: 19960 -> 19 960
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) buf.write(' ');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин GP')),
      body: LayoutBuilder(builder: (context, constraints) {
        final bool isXs = constraints.maxWidth < 360;
        // Устанавливаем дефолтный выбранный план (середина) если не выбрано
        _selectedPackageId ??= 'bizlevelgp_1000';
        _selectedAmount ??=
            (_serverPricing['bizlevelgp_1000']?['amount_kzt'] as int?) ?? 9960;
        _selectedLabel ??= 'РАЗГОН: 1400 GP';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Вводный блок
            const BizLevelCard(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GpBalanceWidget(),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'GP — внутренняя валюта BizLevel: 1 GP = 1 сообщение в чате тренеров, также GP открывают новые этажи.',
                      style: TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Переключатель планов
            Semantics(
              label: 'Выбор плана',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text('СТАРТ'),
                    selected: _selectedPackageId == 'bizlevelgp_300',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'bizlevelgp_300';
                        _selectedAmount = 3000;
                        _selectedLabel = 'СТАРТ: 300 GP';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('РАЗГОН'),
                    selected: _selectedPackageId == 'bizlevelgp_1000',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'bizlevelgp_1000';
                        _selectedAmount = 9960;
                        _selectedLabel = 'РАЗГОН: 1400 GP';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('ТРАНСФОРМ'),
                    selected: _selectedPackageId == 'bizlevelgp_2000',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'bizlevelgp_2000';
                        _selectedAmount = 19960;
                        _selectedLabel = 'ТРАНСФОРМАЦИЯ: 3000 GP';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Одна карточка выбранного плана
            if (_selectedPackageId == 'bizlevelgp_300')
              Semantics(
                label: 'План СТАРТ, 300 GP',
                child: _GpPlanCard(
                  title: 'СТАРТ:',
                  gpLabel: '300',
                  descriptionTitle: 'Идеально для:',
                  bullets: const [
                    'Обдумать идеи',
                    'Быстрых консультаций',
                    'Получить второе мнение',
                  ],
                  italicNote: 'Каждый успешный бизнес начинался с первого шага',
                  priceLabel: _priceLabelFor('bizlevelgp_300', '₸3 000'),
                  selected: true,
                  onSelect: () {},
                ),
              ),
            if (_selectedPackageId == 'bizlevelgp_1000')
              Semantics(
                label: 'План РАЗГОН, 1400 GP',
                child: _GpPlanCard(
                  title: 'РАЗГОН:',
                  gpLabel: '1000 + 400 бонус',
                  descriptionTitle: 'Достаточно чтобы:',
                  bullets: const [
                    'Поставить и достичь цели за 28 дней',
                    '400+ персональных советов',
                    'Открыть новые горизонты',
                  ],
                  italicNote: 'Выбор 80% предпринимателей',
                  priceLabel: _priceLabelFor('bizlevelgp_1000', '₸9 960'),
                  highlight: true,
                  ribbon: isXs ? null : 'Хит',
                  selected: true,
                  onSelect: () {},
                ),
              ),
            if (_selectedPackageId == 'bizlevelgp_2000')
              Semantics(
                label: 'План ТРАНСФОРМАЦИЯ, 3000 GP',
                child: _GpPlanCard(
                  title: 'ТРАНСФОРМАЦИЯ:',
                  gpLabel: '2000 + 1000 бонус',
                  descriptionTitle: 'Полная перезагрузка',
                  bullets: const [
                    'От хаоса к системе',
                    'От идеи к масштабу',
                    'От мечты к результату',
                  ],
                  italicNote: 'Для тех, кто настроен серьезно',
                  priceLabel: _priceLabelFor('bizlevelgp_2000', '₸19 960'),
                  ribbon: isXs ? null : 'Выгоднее всего',
                  selected: true,
                  onSelect: () {},
                ),
              ),
            const SizedBox(height: 12),
            // FAQ свернут по умолчанию
            BizLevelCard(
              padding: const EdgeInsets.all(4),
              child: ExpansionTile(
                initiallyExpanded: _faqExpanded,
                onExpansionChanged: (v) => setState(() => _faqExpanded = v),
                title: const Text('Вопросы и безопасность'),
                children: const [
                  _FaqRow(
                      icon: Icons.lock_outline,
                      text:
                          'Оплата защищена. Данные карт не хранятся в приложении.'),
                  _FaqRow(
                      icon: Icons.schedule_outlined,
                      text:
                          'GP зачисляются сразу после подтверждения покупки.'),
                  _FaqRow(
                      icon: Icons.help_outline,
                      text:
                          'Если GP не пришли — нажмите «Проверить» или обратитесь в поддержку.'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              Expanded(
                child: BizLevelButton(
                  label: _selectedLabel == null ? 'Выберите пакет' : 'Оплатить',
                  onPressed: _selectedPackageId == null
                      ? null
                      : () => _startPurchaseIapOrWeb(
                            context,
                            ref,
                            _selectedPackageId!,
                            _selectedAmount!,
                          ),
                ),
              ),
              const SizedBox(width: 12),
              BizLevelButton(
                variant: BizLevelButtonVariant.secondary,
                label: 'Проверить',
                onPressed: () => _verifyLastPurchase(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _verifyLastPurchase(BuildContext context) async {
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
      data: {'purchase_id': lastId.substring(0, lastId.length.clamp(0, 8))},
    ));
    final gp = GpService(Supabase.instance.client);
    final balance = await gp.verifyPurchase(purchaseId: lastId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка подтверждена, баланс: $balance')),
    );
    final container = ProviderScope.containerOf(context);
    container.invalidate(gpBalanceProvider);
  } catch (e) {
    if (!context.mounted) return;
    final msg = e.toString().contains('gp_purchase_not_found')
        ? 'Покупка не найдена. Завершите оплату и попробуйте снова.'
        : 'Не удалось подтвердить. Проверьте интернет или попробуйте позже.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

Future<void> _startPurchaseIapOrWeb(
  BuildContext context,
  WidgetRef ref,
  String packageId,
  int amountKzt,
) async {
  try {
    // Попытка IAP на iOS/Android
    if (IapService.currentPlatform() == 'ios' ||
        IapService.currentPlatform() == 'android') {
      final iap = IapService.instance;
      final available = await iap.isAvailable();
      if (available) {
        final resp = await iap.queryProducts({packageId});
        if (resp.notFoundIDs.isEmpty && resp.productDetails.isNotEmpty) {
          final product = resp.productDetails.first;
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_iap_purchase_started',
              data: {
                'productId': product.id,
                'platform': IapService.currentPlatform()
              },
            ));
          } catch (_) {}
          final purchase = await iap.buyConsumableOnce(product);
          if (purchase != null && purchase.status == PurchaseStatus.purchased) {
            try {
              await Sentry.addBreadcrumb(Breadcrumb(
                message: 'gp_iap_purchase_purchased',
                data: {'productId': product.id},
              ));
            } catch (_) {}
            final gp = GpService(Supabase.instance.client);
            final token = purchase.verificationData.serverVerificationData;
            final platform = IapService.currentPlatform();
            try {
              await Sentry.addBreadcrumb(Breadcrumb(
                message: 'gp_verify_started',
                data: {'productId': product.id, 'platform': platform},
              ));
            } catch (_) {}
            final balance = await gp.verifyIapPurchase(
              platform: platform,
              productId: product.id,
              token: token,
            );
            try {
              await Sentry.addBreadcrumb(Breadcrumb(
                message: 'gp_verify_success',
                data: {'productId': product.id, 'balance_after': balance},
              ));
            } catch (_) {}
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Покупка подтверждена, баланс: $balance')),
            );
            final container = ProviderScope.containerOf(context);
            container.invalidate(gpBalanceProvider);
            return;
          }
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_iap_purchase_not_purchased',
              data: {
                'productId': product.id,
                'status': purchase?.status.toString()
              },
            ));
          } catch (_) {}
        }
      }
    }
    // Фолбэк: текущий web/mock флоу
    final gp = GpService(Supabase.instance.client);
    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_web_purchase_init',
        data: {'productId': packageId},
      ));
    } catch (_) {}
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
  final String? ribbon;
  final bool selected;

  const _GpPlanCard({
    required this.title,
    required this.gpLabel,
    required this.descriptionTitle,
    required this.bullets,
    required this.italicNote,
    required this.priceLabel,
    required this.onSelect,
    this.highlight = false,
    this.ribbon,
    this.selected = false,
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
                          height: 40,
                          child: BizLevelButton(
                            label: priceLabel,
                            onPressed: onSelect,
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
                    if (ribbon != null || selected) ...[
                      const SizedBox(height: 8),
                      _Ribbon(ribbon: ribbon, selected: selected),
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
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
                      Flexible(
                        child: _GpLabelText(label: gpLabel, compact: true),
                      ),
                      if (ribbon != null || selected) ...[
                        const SizedBox(width: 8),
                        _Ribbon(ribbon: ribbon, selected: selected),
                      ],
                    ],
                  )),
                  SizedBox(
                    height: 40,
                    child: BizLevelButton(
                      label: priceLabel,
                      onPressed: onSelect,
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
                      const Icon(Icons.check,
                          size: 16, color: AppColor.success),
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
    final baseStyle =
        (compact ? theme.textTheme.titleSmall : theme.textTheme.titleLarge)
            ?.copyWith(fontWeight: FontWeight.w700);
    final bonusStyle = (compact
            ? theme.textTheme.titleSmall
            : theme.textTheme.titleLarge)
        ?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600);
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: parts.$1, style: baseStyle),
          if (parts.$2 != null)
            TextSpan(
                text: ' + ${parts.$2!.replaceFirst('+ ', '')}',
                style: bonusStyle),
        ],
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _Ribbon extends StatelessWidget {
  final String? ribbon;
  final bool selected;
  const _Ribbon({this.ribbon, required this.selected});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColor.primary : AppColor.premium;
    final text = selected ? 'Выбрано' : (ribbon ?? '');
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FaqRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColor.labelColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
