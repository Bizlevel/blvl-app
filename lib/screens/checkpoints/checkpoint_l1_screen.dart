import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/utils/date_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/models/goal_update.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/color.dart';

class CheckpointL1Screen extends ConsumerStatefulWidget {
  const CheckpointL1Screen({super.key});

  @override
  ConsumerState<CheckpointL1Screen> createState() => _CheckpointL1ScreenState();
}

class _CheckpointL1ScreenState extends ConsumerState<CheckpointL1Screen> {
  final TextEditingController _goalTextCtrl = TextEditingController();
  final FocusNode _goalFocusNode = FocusNode();
  DateTime? _deadline;
  final TextEditingController _metricCurrentCtrl = TextEditingController();
  final TextEditingController _metricTargetCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goalTextCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _goalTextCtrl.dispose();
    _goalFocusNode.dispose();
    _metricCurrentCtrl.dispose();
    _metricTargetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showRuDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _saveAndGoGoal() async {
    final repo = ref.read(goalsRepositoryProvider);
    try {
      final goalText = _goalTextCtrl.text.trim();
      final num? metricCurrent = num.tryParse(_metricCurrentCtrl.text.trim());
      final num? metricTarget = num.tryParse(_metricTargetCtrl.text.trim());
      if (metricCurrent == null || metricTarget == null) {
        NotificationCenter.showError(
            context, 'Введите обе метрики числовыми значениями');
        return;
      }
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      await repo.upsertUserGoalRequest(GoalUpsertRequest(
        userId: userId,
        goalText: goalText,
        targetDate: _deadline,
        metricStart: metricCurrent,
        metricCurrent: metricCurrent,
        metricTarget: metricTarget,
      ));
      try {
        Sentry.addBreadcrumb(Breadcrumb(
            category: 'checkpoint',
            message: 'l1_saved',
            level: SentryLevel.info));
      } catch (_) {}
      ref.invalidate(userGoalProvider);
      // Важно: после сохранения цели меняется статус чекпоинта L1 и доступность Уровня 2 в Башне.
      // Инвалидируем башню/уровни, чтобы UI обновился сразу после закрытия экрана.
      ref.invalidate(towerNodesProvider);
      ref.invalidate(levelsProvider);
      if (!mounted) return;
      NotificationCenter.showSuccess(context, 'Цель сохранена');
      // Возвращаемся назад вместо перехода на /goal (который недоступен до завершения уровня)
      if (Navigator.of(context).canPop()) {
        Navigator.of(context)
            .pop(true); // Возвращаем true как признак успешного сохранения
      }
    } catch (e) {
      if (!mounted) return;
      NotificationCenter.showError(context, 'Ошибка: $e');
    }
  }

  String _fmtDate(DateTime d) {
    final dl = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dl.year}-${two(dl.month)}-${two(dl.day)}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasGoal = _goalTextCtrl.text.trim().isNotEmpty;
    final bool hasCurrent = _metricCurrentCtrl.text.trim().isNotEmpty;
    final bool hasTarget = _metricTargetCtrl.text.trim().isNotEmpty;
    final bool canSave = hasGoal && hasCurrent && hasTarget;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чекпоинт: Первая цель'),
      ),
      // Flutter автоматически управляет клавиатурой
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BizLevelCard.content(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Интро-блок: формула цели
              BizLevelCard.nested(
                padding: AppSpacing.insetsAll(AppSpacing.lg),
                child: Text(
                  'Формула цели: Увеличить [показатель] с [X] до [Y] к [дата]',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColor.colorTextSecondary,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Шаг 1: Опишите свою цель',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _goalTextCtrl,
                focusNode: _goalFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Цель',
                  hintText:
                      'Коротко и измеримо: например, 5 клиентов в неделю или ₸100 000 в день',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Шаг 2: Укажите метрики',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _metricCurrentCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Текущая',
                        hintText: 'например, 1',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _metricTargetCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Цель',
                        hintText: 'например, 5',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Шаг 3: Срок достижения (необязательно)',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _deadline == null ? 'Не выбрано' : _fmtDate(_deadline!),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  BizLevelButton(
                    variant: BizLevelButtonVariant.text,
                    label: 'Выбрать дату',
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: BizLevelButton(
                  label: 'Сформулировать цель',
                  size: BizLevelButtonSize.lg,
                  backgroundColorOverride:
                      canSave ? AppColor.primary : AppColor.colorBorder,
                  foregroundColorOverride:
                      canSave ? AppColor.onPrimary : AppColor.colorTextTertiary,
                  onPressed: canSave ? _saveAndGoGoal : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
