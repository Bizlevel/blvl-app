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
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/utils/max_context_helper.dart';
import 'package:bizlevel/theme/dimensions.dart';

class PracticeJournalSection extends ConsumerStatefulWidget {
  const PracticeJournalSection({super.key});

  @override
  ConsumerState<PracticeJournalSection> createState() =>
      _PracticeJournalSectionState();
}

class _PracticeJournalSectionState
    extends ConsumerState<PracticeJournalSection> {
  final TextEditingController _practiceNoteCtrl = TextEditingController();
  final TextEditingController _metricUpdateCtrl = TextEditingController();
  final Set<String> _selectedTools = <String>{};
  bool _showMomentum = false;
  bool _selectingGuard = false;
  bool _reminderSheetOpen = false;
  bool _savingEntry = false;

  @override
  void dispose() {
    _practiceNoteCtrl.dispose();
    _metricUpdateCtrl.dispose();
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
                    onPressed: _reminderSheetOpen
                        ? null
                        : () async {
                            setState(() => _reminderSheetOpen = true);
                            await showRemindersSettingsSheet(context);
                            if (mounted) {
                              setState(() => _reminderSheetOpen = false);
                            }
                          },
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
                      .uri
                      .toString();
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
              AppSpacing.gapH(AppSpacing.md),
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
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(
                            'Подсказка: «Топ‑3» — инструменты, которые вы отмечали чаще всего.',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColor.onSurfaceSubtle),
                          ),
                        ),
                        for (final t in top3)
                          FilledButton.tonalIcon(
                            onPressed: () async {
                              if (_selectingGuard) return;
                              _selectingGuard = true;
                              final String label =
                                  (t is Map && t['label'] != null)
                                      ? t['label'].toString()
                                      : '';
                              if (!mounted) return;
                              setState(() {
                                _selectedTools
                                  ..clear()
                                  ..add(label);
                              });
                              try {
                                await Sentry.addBreadcrumb(Breadcrumb(
                                  category: 'goal',
                                  message: 'top_tool_selected',
                                  data: {'tool': label},
                                  level: SentryLevel.info,
                                ));
                              } catch (_) {}
                              _selectingGuard = false;
                            },
                            icon: const Icon(Icons.flash_on, size: 18),
                            label: Text((t is Map && t['label'] != null)
                                ? t['label'].toString()
                                : ''),
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
                  // Де-дубликат опций и безопасное выбранное значение
                  final List<String> uniqueOpts = () {
                    final List<String> out = [];
                    final Set<String> seen = <String>{};
                    for (final e in (opts)) {
                      if (seen.add(e)) out.add(e);
                    }
                    return out;
                  }();
                  String? selected =
                      _selectedTools.isEmpty ? null : _selectedTools.first;
                  if (selected != null &&
                      uniqueOpts.where((e) => e == selected).length != 1) {
                    selected = null;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: selected,
                        hint: const Text('Другие навыки'),
                        items: uniqueOpts
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(e,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(width: AppSpacing.s6),
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
                          if (_selectingGuard) return;
                          _selectingGuard = true;
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
                          _selectingGuard = false;
                        },
                      ),
                    ],
                  );
                },
              ),
              AppSpacing.gapH(AppSpacing.sm),
              TextField(
                controller: _metricUpdateCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Обновить текущее значение метрики',
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              AppSpacing.gapH(AppSpacing.sm),
              TextField(
                controller: _practiceNoteCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Что конкретно сделал(а) сегодня'),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              AppSpacing.gapH(AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: BizLevelButton(
                  label: _savingEntry ? 'Сохраняю…' : 'Сохранить запись',
                  onPressed: () async {
                    if (_savingEntry) return;
                    try {
                      setState(() => _savingEntry = true);
                      final repo = ref.read(goalsRepositoryProvider);
                      // Снимаем "снапшот" ввода ДО любых await, чтобы:
                      // - не потерять текст из‑за очистки контроллера
                      // - не отправить дефолтное сообщение Максу при подвисаниях/рефокусе
                      final String noteSnapshot = _practiceNoteCtrl.text.trim();
                      final List<String> toolsSnapshot =
                          _selectedTools.toList(growable: false);
                      final String metricUpdateRaw =
                          _metricUpdateCtrl.text.trim();
                      final num? metricUpdate = metricUpdateRaw.isEmpty
                          ? null
                          : num.tryParse(metricUpdateRaw);
                      // Пытаемся выполнить транзакционный RPC; при ошибке — фоллбек
                      try {
                        await repo.logPracticeAndUpdateMetricTx(
                          appliedTools: toolsSnapshot,
                          note: noteSnapshot.isEmpty
                              ? null
                              : noteSnapshot,
                          appliedAt: DateTime.now(),
                          metricCurrent: metricUpdate,
                        );
                      } catch (_) {
                        await repo.addPracticeEntry(
                          appliedTools: toolsSnapshot,
                          note: noteSnapshot.isEmpty
                              ? null
                              : noteSnapshot,
                          appliedAt: DateTime.now(),
                        );
                        if (metricUpdate != null) {
                          await repo.updateMetricCurrent(metricUpdate);
                        }
                      }
                      ref.invalidate(userGoalProvider);
                      if (metricUpdate != null) {
                        try {
                          await Sentry.addBreadcrumb(Breadcrumb(
                            category: 'goal',
                            message: 'metric_current_updated',
                            data: {'value': metricUpdate},
                            level: SentryLevel.info,
                          ));
                        } catch (_) {}
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Метрика обновлена до $metricUpdate')),
                        );
                      }
                      _practiceNoteCtrl.clear();
                      _metricUpdateCtrl.clear();
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
                        if (!context.mounted) return;
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('+5 GP за практику сегодня')),
                        );
                      } catch (_) {}
                      await Future.delayed(const Duration(milliseconds: 800));
                      if (!context.mounted) return;
                      setState(() => _showMomentum = false);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LeoDialogScreen(
                          bot: 'max',
                          userContext: buildMaxUserContext(
                            goal: ref.read(userGoalProvider).asData?.value,
                            practiceNote:
                                noteSnapshot.isEmpty ? null : noteSnapshot,
                            appliedTools: toolsSnapshot,
                            metricCurrentUpdated: metricUpdate,
                          ),
                          levelContext: '',
                          autoUserMessage: noteSnapshot.isNotEmpty
                              ? 'Сегодня сделал(а): $noteSnapshot'
                              : 'Я сделал запись в дневнике применений. Подскажи, как усилить эффект?',
                        ),
                      ));
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
                    } finally {
                      if (mounted) {
                        setState(() => _savingEntry = false);
                      }
                    }
                  },
                ),
              ),
              AppSpacing.gapH(AppSpacing.sm),
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
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: LayoutBuilder(
                      builder: (ctx, cons) {
                        final stats = <Widget>[
                          Text('Всего: $total'),
                          const SizedBox(width: AppSpacing.md),
                          Text('Дней: $days'),
                          const SizedBox(width: AppSpacing.md),
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
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.sm,
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
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundInfo,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Пока записей нет'),
                          AppSpacing.gapH(AppSpacing.s6),
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
                              color: AppColor.onSurfaceSubtle),
                          title: Text(((m['applied_tools'] as List?) ??
                                  const <dynamic>[])
                              .join(', ')),
                          subtitle: Text((m['note'] ?? '').toString()),
                          trailing:
                              Text(fmt((m['applied_at'] ?? '').toString())),
                        ),
                      AppSpacing.gapH(AppSpacing.sm),
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
            top: 40, // Сдвинуто вниз, чтобы не перекрывать кнопку колокольчика
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _showMomentum ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundSuccess,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusXxl),
                    border: Border.all(
                        color: AppColor.success.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up,
                          color: AppColor.success, size: 18),
                      SizedBox(width: AppSpacing.s6),
                      Text('+1 день движения к цели',
                          style: TextStyle(color: AppColor.success)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
