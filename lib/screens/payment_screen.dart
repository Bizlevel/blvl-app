import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        backgroundColor: AppColor.appBgColor,
        elevation: AppDimensions.elevationNone,
      ),
      body: Padding(
        padding: AppSpacing.insetsAll(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Инструкция по оплате',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH(AppSpacing.lg),
            Text(
              '1. Откройте приложение Kaspi.kz на вашем телефоне.\n'
              '2. Перейдите в раздел "Платежи" → "Перевод по номеру".\n'
              '3. Введите номер +7 777 123-45-67 (BizLevel).\n'
              '4. В комментарии укажите ваш email, зарегистрированный в приложении.\n'
              '5. Сумма к оплате: 9 990 ₸.\n'
              '6. Нажмите "Оплатить".\n\n'
              'После подтверждения платежа пакет GP будет зачислен на ваш баланс в течение 10 минут.',
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            AppSpacing.gapH(AppSpacing.xl),
            Text(
              'Если возникли вопросы, свяжитесь с поддержкой support@bizlevel.kz.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.labelColor),
            ),
          ],
        ),
      ),
    );
  }
}
