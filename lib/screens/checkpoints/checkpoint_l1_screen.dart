import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/utils/date_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/models/goal_update.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:bizlevel/theme/spacing.dart';

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
            context, 'Введите числовые значения метрик');
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
      if (!mounted) return;
      NotificationCenter.showSuccess(context, 'Цель сохранена');
      // Возвращаемся назад вместо перехода на /goal (который недоступен до завершения уровня)
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true); // Возвращаем true как признак успешного сохранения
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
    final bool canSave = _goalTextCtrl.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чекпоинт: Первая цель'),
      ),
      // ВАЖНО: resizeToAvoidBottomInset: true, чтобы Flutter поднимал контент при появлении клавиатуры
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BizLevelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Интро-блок: картинка ~1/3 экрана и 3 строки текста
              LayoutBuilder(builder: (context, cons) {
                final double h = MediaQuery.of(context).size.height / 3;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h.clamp(180, 320),
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/logo_light.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Сформулируйте первую цель. Сделайте её измеримой и достижимой — так вы увидите прогресс и поймёте, что работает.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              }),
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Шаг 2: Срок достижения (необязательно)',
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
