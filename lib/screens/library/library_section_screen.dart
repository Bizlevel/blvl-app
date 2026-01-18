import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/widgets/common/breadcrumb.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';

class LibrarySectionScreen extends ConsumerStatefulWidget {
  final String type; // 'courses' | 'grants' | 'accelerators'
  const LibrarySectionScreen({super.key, required this.type});

  @override
  ConsumerState<LibrarySectionScreen> createState() =>
      _LibrarySectionScreenState();
}

class _LibrarySectionScreenState extends ConsumerState<LibrarySectionScreen> {
  String? _category;
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    try {
      sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
        category: 'library',
        level: sentry.SentryLevel.info,
        message: 'library_section_opened',
        data: {'type': widget.type},
      ));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final async = widget.type == 'courses'
        ? ref.watch(coursesProvider(_category))
        : widget.type == 'grants'
            ? ref.watch(grantsProvider(_category))
            : ref.watch(acceleratorsProvider(_category));
    final favAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForType(widget.type)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            try {
              final router = GoRouter.of(context);
              if (router.canPop()) {
                context.pop();
              } else {
                context.go('/library');
              }
            } catch (e, st) {
              sentry.Sentry.captureException(e, stackTrace: st);
            }
          },
          tooltip: 'Назад',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.insetsSymmetric(v: 8),
            child: Breadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Главная',
                  onTap: () => context.go('/home'),
                ),
                BreadcrumbItem(
                  label: 'Библиотека',
                  onTap: () => context.go('/library'),
                ),
                BreadcrumbItem(
                  label: _titleForType(widget.type),
                  isCurrent: true,
                ),
              ],
            ),
          ),
          _CategoryFilter(
            type: widget.type,
            onSelected: (c) {
              try {
                sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
                  category: 'library',
                  level: sentry.SentryLevel.info,
                  message: 'library_filter_applied',
                  data: {'type': widget.type, 'category': c ?? ''},
                ));
              } catch (_) {}
              setState(() => _category = c);
            },
          ),
          Expanded(
            child: async.when(
              data: (rows) => ListView.separated(
                padding: AppSpacing.insetsAll(AppSpacing.screenPadding),
                itemCount: rows.length,
                separatorBuilder: (_, __) =>
                    AppSpacing.gapH(AppSpacing.itemSpacing),
                itemBuilder: (context, index) {
                  final r = rows[index];
                  final id = (r['id'] ?? index).toString();
                  final expanded = _expanded[id] ?? false;
                  final favRows =
                      favAsync.asData?.value ?? const <Map<String, dynamic>>[];
                  final typeKey = _favoriteType(widget.type);
                  final isFavorite = favRows.any((f) =>
                      (f['resource_type']?.toString() ?? '') == typeKey &&
                      (f['resource_id']?.toString() ?? '') == id);
                  return _ResourceCard(
                    type: widget.type,
                    data: r,
                    expanded: expanded,
                    onToggleExpand: () =>
                        setState(() => _expanded[id] = !expanded),
                    onOpenLink: () => _openLink(r['url']?.toString() ?? ''),
                    isFavorite: isFavorite,
                    onToggleFavorite: () async {
                      try {
                        final repo = ref.read(libraryRepositoryProvider);
                        await repo.toggleFavorite(
                          resourceType: _favoriteType(widget.type),
                          resourceId: r['id']?.toString() ?? '',
                        );
                        try {
                          sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
                            category: 'library',
                            level: sentry.SentryLevel.info,
                            message: 'library_favorite_toggled',
                            data: {
                              'type': widget.type,
                              'resourceId': r['id']?.toString() ?? '',
                              'action': isFavorite ? 'remove' : 'add',
                            },
                          ));
                        } catch (_) {}
                        // Инвалидация избранного для обновления UI
                        ref.invalidate(favoritesProvider);
                        ref.invalidate(favoritesDetailedProvider);
                        if (context.mounted) {
                          NotificationCenter.showSuccess(
                              context, 'Избранное обновлено');
                        }
                      } catch (e, st) {
                        await sentry.Sentry.captureException(e, stackTrace: st);
                        if (context.mounted) {
                          NotificationCenter.showError(
                              context, 'Ошибка обновления избранного');
                        }
                      }
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Ошибка загрузки: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      sentry.Sentry.addBreadcrumb(sentry.Breadcrumb(
        category: 'library',
        level: sentry.SentryLevel.info,
        message: 'library_link_open',
        data: {
          'host': uri.host,
          'path': uri.path,
        },
      ));
    } catch (_) {}
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      NotificationCenter.showError(context, 'Не удалось открыть ссылку');
    }
  }

  String _titleForType(String t) {
    switch (t) {
      case 'courses':
        return 'Курсы';
      case 'grants':
        return 'Гранты и поддержка';
      default:
        return 'Акселераторы';
    }
  }

  String _favoriteType(String t) {
    switch (t) {
      case 'courses':
        return 'course';
      case 'grants':
        return 'grant';
      default:
        return 'accelerator';
    }
  }
}

class _CategoryFilter extends ConsumerWidget {
  final String type;
  final ValueChanged<String?> onSelected;
  const _CategoryFilter({required this.type, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(libraryCategoriesProvider(type));
    return Padding(
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.screenPadding, v: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 420;
          final categories = async.asData?.value ?? const <String>[];
          final items = <DropdownMenuItem<String?>>[
            const DropdownMenuItem<String?>(
                child: Text('Все', overflow: TextOverflow.ellipsis)),
            ...categories.map((c) => DropdownMenuItem<String?>(
                  value: c,
                  child: Text(c, overflow: TextOverflow.ellipsis),
                )),
          ];
          final rowChildren = <Widget>[
            const Text('Категория:'),
            AppSpacing.gapW(AppSpacing.itemSpacing),
            Flexible(
              child: DropdownButtonFormField<String?>(
                isExpanded: true,
                decoration: const InputDecoration(isDense: true),
                hint: Text(
                  async.isLoading ? 'Загрузка…' : 'Все',
                  overflow: TextOverflow.ellipsis,
                ),
                onChanged: async.isLoading ? null : onSelected,
                items: items,
              ),
            ),
          ];
          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Категория:'),
                AppSpacing.gapH(AppSpacing.itemSpacing),
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true),
                  hint: Text(
                    async.isLoading ? 'Загрузка…' : 'Все',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onChanged: async.isLoading ? null : onSelected,
                  items: items,
                ),
              ],
            );
          }
          return Row(children: rowChildren);
        },
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String type;
  final Map<String, dynamic> data;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onOpenLink;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const _ResourceCard({
    required this.type,
    required this.data,
    required this.expanded,
    required this.onToggleExpand,
    required this.onOpenLink,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] ?? '').toString();
    final platform = (data['platform'] ?? data['organizer'] ?? '').toString();
    final description = (data['description'] ?? '').toString();
    final url = (data['url'] ?? '').toString();

    return BizLevelCard(
      outlined: true,
      padding: AppSpacing.insetsAll(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(platform,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                tooltip: expanded ? 'Свернуть' : 'Развернуть',
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: onToggleExpand,
              ),
              IconButton(
                tooltip: isFavorite ? 'Убрать из избранного' : 'В избранное',
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            _DynamicInfo(type: type, data: data),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Semantics(
                  label: 'Открыть ресурс',
                  button: true,
                  child: ElevatedButton(
                    onPressed: url.isEmpty ? null : onOpenLink,
                    child: const Text('Перейти ↗'),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DynamicInfo extends StatelessWidget {
  final String type;
  final Map<String, dynamic> data;
  const _DynamicInfo({required this.type, required this.data});

  @override
  Widget build(BuildContext context) {
    final labelByKey = _labels(type);
    final rows = <List<String>>[];
    for (final entry in labelByKey.entries) {
      final value = (data[entry.key] ?? '').toString();
      if (value.isNotEmpty) {
        rows.add([entry.value, value]);
      }
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    final textStyleLabel = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: AppColor.labelColor);
    final textStyleValue = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;
        return Column(
          children: rows
              .map((r) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.itemSpacing),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isNarrow
                              ? (constraints.maxWidth * 0.36).clamp(100, 160)
                              : (constraints.maxWidth * 0.28).clamp(140, 220),
                          child: Text(r[0], style: textStyleLabel),
                        ),
                        Expanded(child: Text(r[1], style: textStyleValue)),
                      ],
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Map<String, String> _labels(String t) {
    switch (t) {
      case 'courses':
        return const {
          'target_audience': 'Целевая аудитория',
          'language': 'Язык',
          'duration': 'Длительность',
          'category': 'Категория',
        };
      case 'grants':
        return const {
          'support_type': 'Тип поддержки',
          'amount': 'Сумма/объём',
          'deadline': 'Дедлайн',
          'target_audience': 'Целевая аудитория',
          'category': 'Категория',
        };
      default:
        return const {
          'format': 'Формат',
          'duration': 'Длительность',
          'language': 'Язык',
          'benefits': 'Бенефиты',
          'requirements': 'Требования',
          'target_audience': 'Целевая аудитория',
          'category': 'Категория',
        };
    }
  }
}
