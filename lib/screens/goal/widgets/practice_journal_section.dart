import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/widgets/reminders_settings_sheet.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/theme/spacing.dart';

class PracticeJournalSection extends ConsumerStatefulWidget {
  const PracticeJournalSection({super.key});

  @override
  ConsumerState<PracticeJournalSection> createState() =>
      _PracticeJournalSectionState();
}

class _PracticeJournalSectionState
    extends ConsumerState<PracticeJournalSection> {
  final TextEditingController _practiceNoteCtrl = TextEditingController();
  final Set<String> _selectedTools = <String>{};
  bool _showMomentum = false;

  @override
  void dispose() {
    _practiceNoteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final practiceAsync = ref.watch(practiceLogProvider);
    final toolsAsync = ref.watch(usedToolsOptionsProvider);

    return BizLevelCard(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Журнал применений',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    tooltip: 'Настроить напоминания',
                    icon: const Icon(Icons.notifications_active_outlined),
                    onPressed: () => showRemindersSettingsSheet(context),
                  ),
                ],
              ),
              // Префилл из query (?prefill=intensive&scroll=journal)
              Builder(builder: (context) {
                String loc;
                try {
                  // GoRouter >=10
                  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                  loc = GoRouter.of(context)
                      .routeInformationProvider
                      .value
                      .location;
                } catch (_) {
                  final route = ModalRoute.of(context);
                  loc = route?.settings.name ?? '/goal';
                }
                final uri = Uri.parse(loc);
                final prefill = uri.queryParameters['prefill'];
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (prefill == 'intensive' && _selectedTools.isEmpty) {
                    setState(() {
                      _selectedTools.add('Интенсивное применение');
                      if (_practiceNoteCtrl.text.trim().isEmpty) {
                        _practiceNoteCtrl.text =
                            'Интенсивное применение на 7 дней: выбрал(а) 1–2 инструмента и делаю каждый день.';
                      }
                    });
                  }
                });
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 12),
              FutureBuilder(
                future: ref.read(practiceLogAggregatesProvider.future),
                builder: (ctx, snap) {
                  if (!snap.hasData) return const SizedBox.shrink();
                  final data = snap.data as Map<String, dynamic>;
                  final List top =
                      (data['topTools'] as List?) ?? const <dynamic>[];
                  if (top.isEmpty) return const SizedBox.shrink();
                  final top3 = top.take(3).toList();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in top3)
                          FilledButton.tonalIcon(
                            onPressed: () async {
                              setState(() {
                                _selectedTools
                                  ..clear()
                                  ..add(t['label']?.toString() ?? '');
                              });
                              try {
                                await Sentry.addBreadcrumb(Breadcrumb(
                                  category: 'goal',
                                  message: 'top_tool_selected',
                                  data: {'tool': t['label']},
                                  level: SentryLevel.info,
                                ));
                              } catch (_) {}
                            },
                            icon: const Icon(Icons.flash_on, size: 18),
                            label: Text((t['label'] ?? '').toString()),
                          ),
                      ],
                    ),
                  );
                },
              ),
              toolsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (opts) {
                  String? selected =
                      _selectedTools.isEmpty ? null : _selectedTools.first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selected,
                        hint: const Text('Другие навыки'),
                        items: opts
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(e,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(width: 6),
                                      const Tooltip(
                                        message:
                                            'Подсказка по инструменту: как и когда применять.',
                                        child:
                                            Icon(Icons.info_outline, size: 16),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedTools
                              ..clear()
                              ..addAll(v == null ? const [] : [v]);
                          });
                          try {
                            Sentry.addBreadcrumb(Breadcrumb(
                              category: 'goal',
                              message: 'dropdown_tool_selected',
                              data: {'tool': v},
                              level: SentryLevel.info,
                            ));
                          } catch (_) {}
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _practiceNoteCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Что конкретно сделал(а) сегодня'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: BizLevelButton(
                  label: 'Сохранить запись',
                  onPressed: () async {
                    try {
                      final repo = ref.read(goalsRepositoryProvider);
                      await repo.addPracticeEntry(
                        appliedTools: _selectedTools.toList(),
                        note: _practiceNoteCtrl.text.trim().isEmpty
                            ? null
                            : _practiceNoteCtrl.text.trim(),
                        appliedAt: DateTime.now(),
                      );
                      final String note = _practiceNoteCtrl.text.trim();
                      final String tools = _selectedTools.join(', ');
                      _practiceNoteCtrl.clear();
                      _selectedTools.clear();
                      ref.invalidate(practiceLogProvider);
                      ref.invalidate(practiceLogAggregatesProvider);
                      try {
                        Sentry.addBreadcrumb(Breadcrumb(
                            category: 'goal',
                            message: 'practice_entry_saved',
                            level: SentryLevel.info));
                      } catch (_) {}
                      if (!mounted) return;
                      setState(() => _showMomentum = true);
                      try {
                        Sentry.addBreadcrumb(Breadcrumb(
                            category: 'goal',
                            message: 'goal_momentum_shown',
                            level: SentryLevel.info));
                      } catch (_) {}
                      // Сигнал о бонусе за практику
                      try {
                        final messenger = ScaffoldMessenger.of(context);
                        if (!mounted) return;
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('+5 GP за практику сегодня')),
                        );
                      } catch (_) {}
                      await Future.delayed(const Duration(milliseconds: 800));
                      if (!mounted) return;
                      setState(() => _showMomentum = false);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LeoDialogScreen(
                          bot: 'max',
                          chatId: null,
                          userContext: [
                            if (note.isNotEmpty) 'practice_note: $note',
                            if (tools.isNotEmpty) 'applied_tools: $tools',
                          ].join('\n'),
                          levelContext: '',
                          autoUserMessage: note.isNotEmpty
                              ? 'Сегодня сделал(а): $note'
                              : 'Я сделал запись в дневнике применений. Подскажи, как усилить эффект?',
                        ),
                      ));
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: ref.read(practiceLogAggregatesProvider.future),
                builder: (ctx, snap) {
                  if (!snap.hasData) return const SizedBox.shrink();
                  final data = snap.data as Map<String, dynamic>;
                  final days = data['daysApplied'] as int? ?? 0;
                  final total = data['totalApplied'] as int? ?? days;
                  final List top =
                      (data['topTools'] as List?) ?? const <dynamic>[];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: LayoutBuilder(
                      builder: (ctx, cons) {
                        final stats = <Widget>[
                          Text('Всего: $total'),
                          const SizedBox(width: 12),
                          Text('Дней: $days'),
                          const SizedBox(width: 12),
                          if (top.isNotEmpty)
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                'Часто: ${(top.map((e) => e['label']).take(2).join(', '))}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ];
                        return Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ...stats,
                            FilledButton.tonalIcon(
                              onPressed: () {
                                try {
                                  GoRouter.of(context).push('/goal/history');
                                } catch (_) {}
                              },
                              icon: const Icon(Icons.history),
                              label: const Text('Вся история'),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              practiceAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Не удалось загрузить записи'),
                data: (items) {
                  if (items.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Пока записей нет'),
                          const SizedBox(height: 6),
                          Text(
                            'Выберите инструмент и кратко опишите, что сделали сегодня. Например: «Матрица приоритетов — разобрал входящие заявки, распределил по важности».',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }
                  final recent = items.take(3).toList();
                  String fmt(String s) {
                    final dt = DateTime.tryParse(s)?.toLocal();
                    if (dt == null) return '';
                    const months = [
                      'янв',
                      'фев',
                      'мар',
                      'апр',
                      'май',
                      'июн',
                      'июл',
                      'авг',
                      'сен',
                      'окт',
                      'ноя',
                      'дек'
                    ];
                    final d = dt.day.toString().padLeft(2, '0');
                    final m3 = months[dt.month - 1];
                    final y = dt.year.toString();
                    return '$d-$m3-$y';
                  }

                  return Column(
                    children: [
                      for (final m in recent)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.check_circle_outline,
                              color: Colors.blueGrey),
                          title: Text(((m['applied_tools'] as List?) ??
                                  const <dynamic>[])
                              .join(', ')),
                          subtitle: Text((m['note'] ?? '').toString()),
                          trailing:
                              Text(fmt((m['applied_at'] ?? '').toString())),
                        ),
                      const SizedBox(height: 8),
                      BizLevelButton(
                        variant: BizLevelButtonVariant.text,
                        label: 'Вся история →',
                        onPressed: () {
                          try {
                            GoRouter.of(context).push('/goal/history');
                          } catch (_) {}
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          if (_showMomentum)
            Positioned(
              right: 0,
              top: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _showMomentum ? 1 : 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.trending_up, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text('+1 день движения к цели',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
