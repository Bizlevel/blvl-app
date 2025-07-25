import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/color.dart';
import '../services/payment_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _isLoading = false;

  Future<void> _handleCheckout() async {
    setState(() => _isLoading = true);
    try {
      final paymentService = PaymentService(Supabase.instance.client);
      final redirect = await paymentService.startCheckout(amount: 9990);
      if (!mounted) return;
      await launchUrl(Uri.parse(redirect.url),
          mode: LaunchMode.externalApplication);
    } on PaymentFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BizLevel Premium'),
        backgroundColor: AppColor.appBgColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Преимущества Premium',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text('• Доступ ко всем уровням'),
            const Text('• 30 сообщений с Leo в день'),
            const Text('• Сертификаты по разделам'),
            const Text('• Приоритетная поддержка'),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Оформить за 9 990 ₸',
                          style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
