import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_empty.dart';
import 'package:bizlevel/widgets/common/bizlevel_error.dart';
import 'package:bizlevel/widgets/common/bizlevel_loading.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Библиотека'),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Назад',
              onPressed: () {
                try {
                  final r = GoRouter.of(context);
                  if (r.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                } catch (e, st) {
                  Sentry.captureException(e, stackTrace: st);
                }
              },
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Разделы'),
              Tab(text: 'Избранное'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SectionsTab(),
            _FavoritesTab(),
          ],
        ),
      ),
    );
  }
}

class _SectionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider(null));
    final grants = ref.watch(grantsProvider(null));
    final accels = ref.watch(acceleratorsProvider(null));

    int? len(AsyncValue<List<Map<String, dynamic>>> a) =>
        a.asData?.value.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Бесплатные ресурсы для развития бизнеса',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            icon: Icons.menu_book,
            title: 'Курсы',
            subtitle: len(courses) != null
                ? '${len(courses)} бесплатных программ'
                : 'Загрузка…',
            onTap: () {
              try {
                context.go('/library/courses');
              } catch (e, st) {
                Sentry.captureException(e, stackTrace: st);
              }
            },
          ),
          const SizedBox(height: 12),
          _SectionCard(
            icon: Icons.volunteer_activism,
            title: 'Гранты и поддержка',
            subtitle: len(grants) != null
                ? '${len(grants)} актуальных программ'
                : 'Загрузка…',
            onTap: () {
              try {
                context.go('/library/grants');
              } catch (e, st) {
                Sentry.captureException(e, stackTrace: st);
              }
            },
          ),
          const SizedBox(height: 12),
          _SectionCard(
            icon: Icons.rocket_launch,
            title: 'Акселераторы',
            subtitle: len(accels) != null
                ? '${len(accels)} программ развития'
                : 'Загрузка…',
            onTap: () {
              try {
                context.go('/library/accelerators');
              } catch (e, st) {
                Sentry.captureException(e, stackTrace: st);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BizLevelCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      semanticsLabel: title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _FavoritesTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends ConsumerState<_FavoritesTab> {
  final Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final detailed = ref.watch(favoritesDetailedProvider);
    final favMeta = ref.watch(favoritesProvider);
    return detailed.when(
      data: (rows) {
        final items = <Map<String, dynamic>>[];
        void addAll(String type, List<Map<String, dynamic>> list) {
          for (final r in list) {
            items.add({'_type': type, ...r});
          }
        }

        addAll('courses', rows['courses'] ?? const <Map<String, dynamic>>[]);
        addAll('grants', rows['grants'] ?? const <Map<String, dynamic>>[]);
        addAll('accelerators',
            rows['accelerators'] ?? const <Map<String, dynamic>>[]);

        if (items.isEmpty) {
          return const BizLevelEmpty(
            icon: Icons.star_border,
            title: 'В избранном пока пусто',
            subtitle: 'Добавляйте ресурсы, чтобы быстро вернуться к ним позже',
          );
        }

        final favRows = favMeta.asData?.value ?? const <Map<String, dynamic>>[];

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final data = items[index];
            final type = (data['_type'] ?? 'courses').toString();
            final id = (data['id'] ?? index).toString();
            final expanded = _expanded[id] ?? false;
            final typeKey = _favoriteType(type);
            final isFavorite = favRows.any((f) =>
                (f['resource_type']?.toString() ?? '') == typeKey &&
                (f['resource_id']?.toString() ?? '') == id);

            return _FavResourceCard(
              type: type,
              data: data,
              expanded: expanded,
              isFavorite: isFavorite,
              onToggleExpand: () => setState(() => _expanded[id] = !expanded),
              onOpenLink: () => _openExternal(context, data['url']?.toString()),
              onToggleFavorite: () async {
                try {
                  final repo = ref.read(libraryRepositoryProvider);
                  await repo.toggleFavorite(
                    resourceType: typeKey,
                    resourceId: id,
                  );
                  ref.invalidate(favoritesProvider);
                  ref.invalidate(favoritesDetailedProvider);
                  if (mounted) {
                    NotificationCenter.showSuccess(
                        context, 'Избранное обновлено');
                  }
                } catch (e, st) {
                  await Sentry.captureException(e, stackTrace: st);
                  if (mounted) {
                    NotificationCenter.showError(
                        context, 'Ошибка обновления избранного');
                  }
                }
              },
            );
          },
        );
      },
      loading: () => BizLevelLoading.fullscreen(),
      error: (e, _) => const BizLevelError(
        title: 'Ошибка загрузки избранного',
        fullscreen: true,
      ),
    );
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

  void _openExternal(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return;
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        NotificationCenter.showError(context, 'Не удалось открыть ссылку');
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (context.mounted) {
        NotificationCenter.showError(context, 'Не удалось открыть ссылку');
      }
    }
  }
}

class _FavResourceCard extends StatelessWidget {
  final String type;
  final Map<String, dynamic> data;
  final bool expanded;
  final bool isFavorite;
  final VoidCallback onToggleExpand;
  final VoidCallback onOpenLink;
  final VoidCallback onToggleFavorite;

  const _FavResourceCard({
    required this.type,
    required this.data,
    required this.expanded,
    required this.isFavorite,
    required this.onToggleExpand,
    required this.onOpenLink,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] ?? '').toString();
    final platform = (data['platform'] ?? data['organizer'] ?? '').toString();
    final description = (data['description'] ?? '').toString();
    final url = (data['url'] ?? '').toString();

    return BizLevelCard(
      padding: const EdgeInsets.all(16),
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
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: onToggleExpand,
              ),
              IconButton(
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            _FavDynamicInfo(type: type, data: data),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: url.isEmpty ? null : onOpenLink,
                child: const Text('Перейти ↗'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FavDynamicInfo extends StatelessWidget {
  final String type;
  final Map<String, dynamic> data;
  const _FavDynamicInfo({required this.type, required this.data});

  @override
  Widget build(BuildContext context) {
    final labelByKey = _labels(type);
    final rows = <List<String>>[];
    for (final entry in labelByKey.entries) {
      final value = (data[entry.key] ?? '').toString();
      if (value.isNotEmpty) rows.add([entry.value, value]);
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    final textStyleLabel = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Colors.grey[600]);
    final textStyleValue = Theme.of(context).textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;
        return Column(
          children: rows
              .map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
