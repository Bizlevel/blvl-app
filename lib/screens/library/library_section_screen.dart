import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart' hide Breadcrumb;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/widgets/common/breadcrumb.dart';

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
  Widget build(BuildContext context) {
    final async = widget.type == 'courses'
        ? ref.watch(coursesProvider(_category))
        : widget.type == 'grants'
            ? ref.watch(grantsProvider(_category))
            : ref.watch(acceleratorsProvider(_category));

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
              Sentry.captureException(e, stackTrace: st);
            }
          },
          tooltip: 'Назад',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
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
            onSelected: (c) => setState(() => _category = c),
          ),
          Expanded(
            child: async.when(
              data: (rows) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final r = rows[index];
                  final id = (r['id'] ?? index).toString();
                  final expanded = _expanded[id] ?? false;
                  return _ResourceCard(
                    type: widget.type,
                    data: r,
                    expanded: expanded,
                    onToggleExpand: () =>
                        setState(() => _expanded[id] = !expanded),
                    onOpenLink: () => _openLink(r['url']?.toString() ?? ''),
                    onToggleFavorite: () async {
                      try {
                        final repo = ref.read(libraryRepositoryProvider);
                        await repo.toggleFavorite(
                          resourceType: _favoriteType(widget.type),
                          resourceId: r['id']?.toString() ?? '',
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Избранное обновлено')),
                          );
                        }
                      } catch (e, st) {
                        await Sentry.captureException(e, stackTrace: st);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ошибка обновления избранного')),
                          );
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
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
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

class _CategoryFilter extends StatelessWidget {
  final ValueChanged<String?> onSelected;
  const _CategoryFilter({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    // MVP: простой Dropdown со статичным набором, чтобы не усложнять запросами
    final items = const <String>[
      'Основы предпринимательства и бизнес-планирование',
      'Финансовая грамотность и управление финансами',
      'Цифровой маркетинг и SMM',
      'Продажи и работа с клиентами',
      'Маркетплейсы и электронная коммерция',
      'Управление командой и личная эффективность',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 420;
          final rowChildren = <Widget>[
            const Text('Категория:'),
            const SizedBox(width: 12),
            Flexible(
              child: DropdownButtonFormField<String?>(
                isExpanded: true,
                value: null,
                decoration: const InputDecoration(
                    isDense: true, border: OutlineInputBorder()),
                hint: const Text('Все', overflow: TextOverflow.ellipsis),
                onChanged: onSelected,
                items: [
                  const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Все', overflow: TextOverflow.ellipsis)),
                  ...items.map((c) => DropdownMenuItem<String?>(
                        value: c,
                        child: Text(c, overflow: TextOverflow.ellipsis),
                      )),
                ],
              ),
            ),
          ];
          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Категория:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  value: null,
                  decoration: const InputDecoration(
                      isDense: true, border: OutlineInputBorder()),
                  hint: const Text('Все', overflow: TextOverflow.ellipsis),
                  onChanged: onSelected,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Все', overflow: TextOverflow.ellipsis)),
                    ...items.map((c) => DropdownMenuItem<String?>(
                          value: c,
                          child: Text(c, overflow: TextOverflow.ellipsis),
                        )),
                  ],
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

  const _ResourceCard({
    required this.type,
    required this.data,
    required this.expanded,
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
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
                  icon: const Icon(Icons.star_border),
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
                child: ElevatedButton(
                  onPressed: url.isEmpty ? null : onOpenLink,
                  child: const Text('Перейти ↗'),
                ),
              ),
            ],
          ],
        ),
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
