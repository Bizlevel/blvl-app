import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        backgroundColor: AppColor.appBgColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 16),
            Text(
              '1. Откройте приложение Kaspi.kz на вашем телефоне.\n'
              '2. Перейдите в раздел "Платежи" → "Перевод по номеру".\n'
              '3. Введите номер +7 777 123-45-67 (BizLevel).\n'
              '4. В комментарии укажите ваш email, зарегистрированный в приложении.\n'
              '5. Сумма к оплате: 9 990 ₸.\n'
              '6. Нажмите "Оплатить".\n\n'
              'После подтверждения платежа пакет GP будет зачислен на ваш баланс в течение 10 минут.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
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
