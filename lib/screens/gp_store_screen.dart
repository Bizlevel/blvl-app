import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/services/iap_service.dart';
import 'package:bizlevel/services/storekit2_service.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';

class GpStoreScreen extends ConsumerStatefulWidget {
  const GpStoreScreen({super.key});

  @override
  ConsumerState<GpStoreScreen> createState() => _GpStoreScreenState();
}

class _GpStoreScreenState extends ConsumerState<GpStoreScreen> {
  String? _selectedPackageId;
  String? _selectedLabel;
  bool _faqExpanded = false;
  bool _bonusExpanded = false;
  bool _iapLoadRequested = false;
  final Map<String, ProductDetails> _productMap = {};
  final Map<String, StoreKitProduct> _storeKitProducts = {};
  String? _storeKitStatusMessage;
  final Map<String, Map<String, dynamic>> _serverPricing = {};

  @override
  void initState() {
    super.initState();
    _loadServerPricing();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _waitForVisibilityAndLoadIap();
    });
  }

  void _waitForVisibilityAndLoadIap() {
    if (_iapLoadRequested) return;
    final route = ModalRoute.of(context);
    final isVisible = route == null || route.isCurrent;
    if (!isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _waitForVisibilityAndLoadIap();
      });
      return;
    }
    _iapLoadRequested = true;
    _loadIapProducts();
  }

  Future<void> _loadIapProducts() async {
    try {
      final platform = IapService.currentPlatform();
      if (platform == 'ios') {
        final productIds = {'gp_300', 'gp_1000', 'gp_2000'}.toList();
        final response =
            await StoreKit2Service.instance.fetchProducts(productIds);
        final products = response.products;
        try {
          await Sentry.addBreadcrumb(Breadcrumb(
            message: 'gp_storekit2_products_loaded',
            data: {
              'found': products.map((e) => e.id).toList(),
              'requested': productIds,
              'invalid': response.invalidProductIds,
              'requestId': response.requestId,
              'error': response.errorMessage,
            },
          ));
        } catch (_) {}
        if (mounted) {
          setState(() {
            _storeKitStatusMessage = _buildStoreKitStatus(
              requested: productIds,
              response: response,
            );
            for (final p in products) {
              _storeKitProducts[p.id] = p;
            }
          });
        }
      } else if (platform == 'android') {
        final iap = IapService.instance;
        if (await iap.isAvailable()) {
          final resp = await iap.queryProducts({
            'gp_300',
            'gp_1000',
            'gp_2000',
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
    if (platform == 'ios') {
      final product = _storeKitProducts[productId];
      if (product != null && product.displayPrice.isNotEmpty) {
        return product.displayPrice;
      }
    } else if (platform == 'android') {
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
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) buf.write(' ');
    }
    return buf.toString();
  }

  String? _buildStoreKitStatus({
    required List<String> requested,
    required StoreKitFetchResponse response,
  }) {
    final suffix =
        response.requestId == null ? '' : ' (запрос ${response.requestId})';
    if (response.errorMessage != null && response.errorMessage!.isNotEmpty) {
      return 'StoreKit вернул ошибку: ${response.errorMessage}$suffix';
    }
    if (response.invalidProductIds.isNotEmpty) {
      final missing = response.invalidProductIds.join(', ');
      return 'App Store пока не возвращает товары ($missing). После загрузки метаданных в App Store Connect они появятся автоматически$suffix';
    }
    if (response.products.isEmpty && requested.isNotEmpty) {
      return 'StoreKit ответил пустым списком. Это ожидаемо, пока в App Store Connect не загружены скриншоты и метаданные$suffix';
    }
    return null;
  }

  bool _canPurchaseSelectedPackage() {
    final packageId = _selectedPackageId;
    if (packageId == null) return false;
    final platform = IapService.currentPlatform();
    if (platform != 'ios') return true;
    return _storeKitProducts.containsKey(packageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин GP')),
      body: LayoutBuilder(builder: (context, constraints) {
        final bool isXs = constraints.maxWidth < 360;
        // Устанавливаем дефолтный выбранный план (середина) если не выбрано
        _selectedPackageId ??= 'gp_1000';
        _selectedLabel ??= 'РАЗГОН: 1400 GP';

        return ListView(
          padding: AppSpacing.insetsAll(AppSpacing.lg),
          children: [
            // Вводный блок
            BizLevelCard(
              padding: AppSpacing.insetsAll(AppSpacing.md),
              outlined: true,
              child: Row(
                children: [
                  const GpBalanceWidget(),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'GP — внутренняя валюта BizLevel: 1 GP = 1 сообщение в чате тренеров, также GP открывают новые этажи.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Подсказка: как получить GP (бонусы) — свёрнутый раздел
            BizLevelCard(
              padding: AppSpacing.insetsAll(AppSpacing.xs),
              child: ExpansionTile(
                initiallyExpanded: _bonusExpanded,
                onExpansionChanged: (v) => setState(() => _bonusExpanded = v),
                title: const Text('Как получить бонусные GP'),
                children: const [
                  _FaqRow(
                      icon: Icons.person_add_alt,
                      text: '+30 GP — за регистрацию (первый вход)'),
                  _FaqRow(
                      icon: Icons.badge_outlined,
                      text:
                          '+50 GP — за полный профиль (Профиль > Информация обо мне)'),
                  _FaqRow(
                      icon: Icons.work_outline,
                      text: '+200 GP — за 3 решённых мини‑кейса'),
                  _FaqRow(
                      icon: Icons.check_circle_outline,
                      text: '+5 GP — за ежедневное применение навыков'),
                  _FaqRow(
                      icon: Icons.flag_outlined,
                      text: '+20 GP — за завершение уровня'),
                  _FaqRow(
                      icon: Icons.rocket_launch_outlined,
                      text: '+400 GP — покупка пакета «РАЗГОН»'),
                  _FaqRow(
                      icon: Icons.workspace_premium_outlined,
                      text: '+1000 GP — покупка пакета «ТРАНСФОРМАЦИЯ»'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Переключатель планов
            Semantics(
              label: 'Выбор плана',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text('СТАРТ'),
                    selected: _selectedPackageId == 'gp_300',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'gp_300';
                        _selectedLabel = 'СТАРТ: 300 GP';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('РАЗГОН'),
                    selected: _selectedPackageId == 'gp_1000',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'gp_1000';
                        _selectedLabel = 'РАЗГОН: 1400 GP';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('ТРАНСФОРМ'),
                    selected: _selectedPackageId == 'gp_2000',
                    onSelected: (_) {
                      setState(() {
                        _selectedPackageId = 'gp_2000';
                        _selectedLabel = 'ТРАНСФОРМАЦИЯ: 3000 GP';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Одна карточка выбранного плана
            if (_selectedPackageId == 'gp_300')
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
                  priceLabel: _priceLabelFor('gp_300', '₸3 000'),
                  selected: true,
                  onSelect: () {},
                ),
              ),
            if (_selectedPackageId == 'gp_1000')
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
                  priceLabel: _priceLabelFor('gp_1000', '₸9 960'),
                  highlight: true,
                  ribbon: isXs ? null : 'Хит',
                  selected: true,
                  onSelect: () {},
                ),
              ),
            if (_selectedPackageId == 'gp_2000')
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
                  priceLabel: _priceLabelFor('gp_2000', '₸19 960'),
                  ribbon: isXs ? null : 'Выгоднее всего',
                  selected: true,
                  onSelect: () {},
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            if (IapService.currentPlatform() == 'ios' &&
                _storeKitStatusMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _StoreKitNotice(message: _storeKitStatusMessage!),
              ),
            // FAQ свернут по умолчанию
            BizLevelCard(
              padding: AppSpacing.insetsAll(AppSpacing.xs),
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
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
          decoration: const BoxDecoration(
            color: AppColor.surface,
            border: Border(top: BorderSide(color: AppColor.borderStrong)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BizLevelButton(
                      label: _selectedPackageId == null
                          ? 'Выберите пакет'
                          : _canPurchaseSelectedPackage()
                              ? 'Оплатить'
                              : 'Недоступно',
                      onPressed: _selectedPackageId == null ||
                              !_canPurchaseSelectedPackage()
                          ? null
                          : () => _startPurchaseIapOrWeb(
                                context,
                                ref,
                                _selectedPackageId!,
                              ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  BizLevelButton(
                    variant: BizLevelButtonVariant.secondary,
                    label: 'Проверить',
                    onPressed: () => _verifyLastPurchase(context),
                  ),
                ],
              ),
              if (IapService.currentPlatform() == 'ios' &&
                  !_canPurchaseSelectedPackage() &&
                  _storeKitStatusMessage != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _storeKitStatusMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColor.labelColor),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startPurchaseIapOrWeb(
    BuildContext context,
    WidgetRef ref,
    String packageId,
  ) async {
    try {
      final platform = IapService.currentPlatform();
      if (platform == 'ios') {
        final handled = await _handleIosPurchase(context, ref, packageId);
        if (handled) return;
      } else if (platform == 'android') {
        final handled = await _handleAndroidPurchase(context, ref, packageId);
        if (handled) return;
      } else if (platform != 'web') {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'В мобильных приложениях веб‑оплата отключена. Используйте Google/Apple Pay в сторе.')));
        return;
      }
      await _startWebPurchase(context, packageId);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось создать оплату')),
      );
    }
  }

  Future<bool> _handleIosPurchase(
      BuildContext context, WidgetRef ref, String packageId) async {
    final iap = IapService.instance;
    var product = _storeKitProducts[packageId];
    if (product == null) {
      await _loadIapProducts();
      product = _storeKitProducts[packageId];
    }
    if (product == null) {
      if (!context.mounted) return true;
      final message = _storeKitStatusMessage ??
          'Не удалось запросить цену в App Store. Повторите позже.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return true;
    }

    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_storekit_purchase_started',
        data: {'productId': product.id},
      ));
    } catch (_) {}

    final result = await iap.buyStoreKitProduct(product.id);
    if (!result.isSuccess || result.transaction == null) {
      try {
        await Sentry.addBreadcrumb(Breadcrumb(
          message: 'gp_storekit_purchase_not_completed',
          data: {
            'productId': product.id,
            'status': result.status,
          },
        ));
      } catch (_) {}
      if (!context.mounted) return true;
      final message = result.isCancelled
          ? 'Покупка отменена.'
          : 'Не удалось завершить покупку. Попробуйте снова.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return true;
    }

    final transaction = result.transaction!;
    final receipt =
        transaction.appStoreReceipt ?? transaction.jwsRepresentation;
    final gp = GpService(Supabase.instance.client);

    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_storekit_verify_started',
        data: {'productId': product.id},
      ));
    } catch (_) {}

    final balance = await gp.verifyIapPurchase(
      platform: 'ios',
      productId:
          transaction.productId.isNotEmpty ? transaction.productId : product.id,
      token: receipt,
    );

    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_storekit_verify_success',
        data: {
          'productId': product.id,
          'transactionId': transaction.transactionId,
          'balance_after': balance,
        },
      ));
    } catch (_) {}

    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка подтверждена, баланс: $balance')),
    );
    final container = ProviderScope.containerOf(context);
    container.invalidate(gpBalanceProvider);
    return true;
  }

  Future<bool> _handleAndroidPurchase(
      BuildContext context, WidgetRef ref, String packageId) async {
    final iap = IapService.instance;
    final available = await iap.isAvailable();
    if (!available) {
      if (!context.mounted) return true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Оплата в Google Play временно недоступна. Попробуйте позже.')));
      return true;
    }

    final resp = await iap.queryProducts({packageId});
    if (resp.notFoundIDs.isNotEmpty || resp.productDetails.isEmpty) {
      if (!context.mounted) return true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Оплата в приложении доступна только через Google/Apple. Попробуйте позже.')));
      return true;
    }

    final product = resp.productDetails.first;
    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_iap_purchase_started',
        data: {
          'productId': product.id,
          'platform': IapService.currentPlatform(),
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
      String? packageName;
      if (platform == 'android') {
        try {
          final pi = await PackageInfo.fromPlatform();
          packageName = pi.packageName;
        } catch (_) {}
      }
      try {
        await Sentry.addBreadcrumb(Breadcrumb(
          message: 'gp_verify_started',
          data: {'productId': product.id, 'platform': platform},
        ));
      } catch (_) {}
      int balance;
      try {
        balance = await gp.verifyIapPurchase(
          platform: platform,
          productId: product.id,
          token: token,
          packageName: packageName,
        );
      } catch (e) {
        if (platform == 'android') {
          final fallbackToken = _extractAndroidPurchaseToken(purchase);
          try {
            await Sentry.addBreadcrumb(Breadcrumb(
              message: 'gp_verify_retry_android_token_fallback',
              data: {
                'hasFallback': fallbackToken != null,
                'origLen': token.length,
                'fbLen': fallbackToken?.length ?? 0,
              },
            ));
          } catch (_) {}
          if (fallbackToken != null &&
              fallbackToken.isNotEmpty &&
              fallbackToken != token) {
            balance = await gp.verifyIapPurchase(
              platform: platform,
              productId: product.id,
              token: fallbackToken,
              packageName: packageName,
            );
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }
      try {
        await Sentry.addBreadcrumb(Breadcrumb(
          message: 'gp_verify_success',
          data: {'productId': product.id, 'balance_after': balance},
        ));
      } catch (_) {}
      if (!context.mounted) return true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Покупка подтверждена, баланс: $balance')),
      );
      final container = ProviderScope.containerOf(context);
      container.invalidate(gpBalanceProvider);
      return true;
    }
    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_iap_purchase_not_purchased',
        data: {
          'productId': product.id,
          'status': purchase?.status.toString(),
        },
      ));
    } catch (_) {}
    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Не удалось завершить покупку. Попробуйте снова.')));
    return true;
  }

  Future<void> _startWebPurchase(
    BuildContext context,
    String packageId,
  ) async {
    final gp = GpService(Supabase.instance.client);
    try {
      await Sentry.addBreadcrumb(Breadcrumb(
        message: 'gp_web_purchase_init',
        data: {'productId': packageId},
      ));
    } catch (_) {}
    final init = await gp.initPurchase(packageId: packageId);
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
      } catch (_) {}
    }

    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('После оплаты нажмите «Проверить покупку»')),
    );
  }

  String? _extractAndroidPurchaseToken(PurchaseDetails p) {
    final raw = p.verificationData.localVerificationData;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final token = decoded['purchaseToken'];
        if (token is String && token.isNotEmpty) return token;
        final inner = decoded['json'];
        if (inner is String && inner.isNotEmpty) {
          final decoded2 = jsonDecode(inner);
          if (decoded2 is Map) {
            final token2 = decoded2['purchaseToken'];
            if (token2 is String && token2.isNotEmpty) return token2;
          }
        }
      }
    } catch (_) {
      final re = RegExp(r'"purchaseToken"\s*:\s*"([^"]+)"');
      final m = re.firstMatch(raw);
      if (m != null) return m.group(1);
    }
    return null;
  }
}

Future<void> _verifyLastPurchase(BuildContext context) async {
  try {
    // Блокируем web-verify по purchase_id в мобильных приложениях
    final platform = IapService.currentPlatform();
    if (platform == 'android' || platform == 'ios') {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'В мобильных приложениях подтверждение доступно только через Google/Apple. Запустите проверку из флоу покупки в сторе.')));
      return;
    }
    final box = await HiveBoxHelper.openBox('gp');
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      elevation: highlight ? 3 : AppDimensions.elevationHairline,
      child: Padding(
        padding: AppSpacing.insetsAll(AppSpacing.md),
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
                    const SizedBox(height: AppSpacing.s6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/gp_coin.svg',
                            width: 18, height: 18),
                        const SizedBox(width: AppSpacing.s6),
                        _GpLabelText(label: gpLabel, compact: true),
                      ],
                    ),
                    if (ribbon != null || selected) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _Ribbon(ribbon: ribbon, selected: selected),
                    ],
                  ],
                );
              }
              return Row(
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
                      const SizedBox(width: AppSpacing.sm),
                      SvgPicture.asset('assets/images/gp_coin.svg',
                          width: 20, height: 20),
                      const SizedBox(width: AppSpacing.s6),
                      Flexible(
                        child: _GpLabelText(label: gpLabel, compact: true),
                      ),
                      if (ribbon != null || selected) ...[
                        const SizedBox(width: AppSpacing.sm),
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
            const SizedBox(height: AppSpacing.s10),
            Text(
              descriptionTitle,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check,
                          size: 16, color: AppColor.success),
                      const SizedBox(width: AppSpacing.s6),
                      Expanded(
                        child: Text(
                          b,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: AppSpacing.s6),
            Text(
              italicNote,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
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
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.s10, v: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        border: Border.all(color: bg.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(fontWeight: FontWeight.w600),
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

class _StoreKitNotice extends StatelessWidget {
  const _StoreKitNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return BizLevelCard(
      padding: AppSpacing.insetsAll(AppSpacing.md),
      outlined: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColor.labelColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.labelColor),
            ),
          ),
        ],
      ),
    );
  }
}
