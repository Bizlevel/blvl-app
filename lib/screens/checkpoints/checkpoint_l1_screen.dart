import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/theme/spacing.dart';

class CheckpointL1Screen extends ConsumerStatefulWidget {
  const CheckpointL1Screen({super.key});

  @override
  ConsumerState<CheckpointL1Screen> createState() => _CheckpointL1ScreenState();
}

class _CheckpointL1ScreenState extends ConsumerState<CheckpointL1Screen> {
  final TextEditingController _goalTextCtrl = TextEditingController();
  DateTime? _deadline;

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
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
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
      await repo.upsertUserGoal(
        goalText: goalText,
        targetDate: _deadline,
      );
      try {
        Sentry.addBreadcrumb(Breadcrumb(
            category: 'checkpoint',
            message: 'l1_saved',
            level: SentryLevel.info));
      } catch (_) {}
      ref.invalidate(userGoalProvider);
      if (!mounted) return;
      NotificationCenter.showSuccess(context, 'Цель сохранена');
      GoRouter.of(context).push('/goal');
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
      appBar: AppBar(title: const Text('Чекпоинт: Первая цель')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BizLevelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Шаг 1: Опишите свою цель',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              BizLevelTextField(
                label: 'Цель',
                hint:
                    'Коротко и измеримо: например, 5 клиентов в неделю или ₸100 000 в день',
                controller: _goalTextCtrl,
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
