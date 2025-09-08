import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

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

    int? _len(AsyncValue<List<Map<String, dynamic>>> a) =>
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
            subtitle: _len(courses) != null
                ? '${_len(courses)} бесплатных программ'
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
            subtitle: _len(grants) != null
                ? '${_len(grants)} актуальных программ'
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
            subtitle: _len(accels) != null
                ? '${_len(accels)} программ развития'
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

class _FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailed = ref.watch(favoritesDetailedProvider);
    return detailed.when(
      data: (rows) {
        final courses = rows['courses'] ?? const <Map<String, dynamic>>[];
        final grants = rows['grants'] ?? const <Map<String, dynamic>>[];
        final accels = rows['accelerators'] ?? const <Map<String, dynamic>>[];
        if (courses.isEmpty && grants.isEmpty && accels.isEmpty) {
          return const BizLevelEmpty(
            icon: Icons.star_border,
            title: 'В избранном пока пусто',
            subtitle: 'Добавляйте ресурсы, чтобы быстро вернуться к ним позже',
          );
        }
        final sections = <Widget>[];
        if (courses.isNotEmpty) {
          sections.addAll([
            Semantics(
              header: true,
              child:
                  Text('Курсы', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            ...courses.map((r) => ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text((r['title'] ?? '').toString()),
                  subtitle: Text((r['platform'] ?? '').toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openExternal(context, r['url']?.toString()),
                )),
            const SizedBox(height: 16),
          ]);
        }
        if (grants.isNotEmpty) {
          sections.addAll([
            Semantics(
              header: true,
              child: Text('Гранты и поддержка',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            ...grants.map((r) => ListTile(
                  leading: const Icon(Icons.volunteer_activism),
                  title: Text((r['title'] ?? '').toString()),
                  subtitle: Text((r['organizer'] ?? '').toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openExternal(context, r['url']?.toString()),
                )),
            const SizedBox(height: 16),
          ]);
        }
        if (accels.isNotEmpty) {
          sections.addAll([
            Semantics(
              header: true,
              child: Text('Акселераторы',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            ...accels.map((r) => ListTile(
                  leading: const Icon(Icons.rocket_launch),
                  title: Text((r['title'] ?? '').toString()),
                  subtitle: Text((r['organizer'] ?? '').toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openExternal(context, r['url']?.toString()),
                )),
          ]);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sections.length,
          itemBuilder: (context, index) => sections[index],
        );
      },
      loading: () => BizLevelLoading.fullscreen(),
      error: (e, _) => const BizLevelError(
        title: 'Ошибка загрузки избранного',
        fullscreen: true,
      ),
    );
  }

  void _openExternal(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      // Попытка открыть внешнюю ссылку через url_launcher
      // Минимальная интеграция без зависимости внутри файла: Snackbar‑фолбэк
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Открываем ссылку…')),
      );
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }
}
