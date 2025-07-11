import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

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
          children: const [
            Text(
              'Инструкция по оплате',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              '1. Откройте приложение Kaspi.kz на вашем телефоне.\n'
              '2. Перейдите в раздел "Платежи" → "Перевод по номеру".\n'
              '3. Введите номер +7 777 123-45-67 (BizLevel).\n'
              '4. В комментарии укажите ваш email, зарегистрированный в приложении.\n'
              '5. Сумма к оплате: 9 990 ₸.\n'
              '6. Нажмите "Оплатить".\n\n'
              'После подтверждения платежа подписка Premium активируется автоматически в течение 10 минут.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Если возникли вопросы, свяжитесь с поддержкой support@bizlevel.kz.',
              style: TextStyle(fontSize: 14, color: AppColor.labelColor),
            ),
          ],
        ),
      ),
    );
  }
}
