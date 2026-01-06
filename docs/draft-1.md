Категория	Проблема	возможная причина	Файл для правки	строки для изменения
1. Memory Leak в Video Player Listener	В методе _listener() проверка mounted выполняется в конце, после операций с dispose-ресурсами. При race condition между dispose виджета и удалением listener возможны обращения к dispose-ресурсам и вызовы setState() после dispose.	"Проверка mounted в конце метода (строка 138)
До проверки выполняются операции с _videoController, _chewieController и вызов widget.onWatched()
При dispose виджета listener может быть вызван до удаления, что приводит к обращению к dispose-ресурсам"	lib/widgets/lesson_widget.dart	"Строки для изменения: 121-142
void _listener() {
  if (!mounted) return;  // проверка в начале
  final position = _videoController!.value.position;
  // ... операции ...
  if (!_progressSent && position >= const Duration(seconds: 10)) {
    _progressSent = true;
    widget.onWatched();
  }
  setState(() {});
}"

2. Android Permissions / Release Build	В release-сборке отсутствует разрешение INTERNET в основном манифесте. Разрешение есть только в debug/AndroidManifest.xml и profile/AndroidManifest.xml, но не в main/AndroidManifest.xml. В release используется main/AndroidManifest.xml, поэтому приложение не может работать с сетью.	"Разрешение INTERNET добавлено только в debug/profile манифесты для разработки
В main/AndroidManifest.xml разрешение отсутствует
Release-сборка использует main/AndroidManifest.xml, где нет разрешения"	android/app/src/main/AndroidManifest.xml	"После строки 1 (после <manifest>) или после строки 6 (перед <application>)
<manifest xmlns:android=""http://schemas.android.com/apk/res/android"">
    <uses-permission android:name=""android.permission.INTERNET""/>
    <uses-permission android:name=""android.permission.POST_NOTIFICATIONS""/>
    <uses-permission android:name=""android.permission.RECEIVE_BOOT_COMPLETED""/>
    <uses-permission android:name=""com.android.vending.BILLING"" />
    <application ...>"

3. Error Logging / Monitoring	В методе _initPlayer() ошибки инициализации видео логируются только через debugPrint(), без отправки в Sentry. В продакшене это не видно, что затрудняет диагностику проблем с воспроизведением видео.	"Используется только debugPrint('Video init error: $e') (строка 108)
Нет отправки ошибок в Sentry для мониторинга
В продакшене debugPrint не виден, поэтому ошибки теряются"	lib/widgets/lesson_widget.dart	"Строки для изменения: 107-116
} catch (e, stackTrace) {
  debugPrint('Video init error: $e');
  // Отправляем ошибку в Sentry для мониторинга
  try {
    await Sentry.captureException(e, stackTrace: stackTrace);
  } catch (_) {}
  // Показываем заглушку вместо бесконечного индикатора
  if (!mounted) return;
  setState(() {
    _initialized = true;
    _videoController = null;
    _chewieController = null;
  });
}
Добавить импорт import 'package:sentry_flutter/sentry_flutter.dart'; в начало файла (если его еще нет)"

4. Android Notifications / Resources	В продакшене возникает ошибка при установке уведомлений: PLATFORM EXCEPTION (INVALID_ICON< THE RESOURCE IC_LAUNCHER Could not be found. please make sure it has benn added asa a drawable recource to yuor Android head project., null, null). Код ссылается на ic_launcher (иконка приложения в mipmap), а для уведомлений нужна иконка в drawable.	"Возможная причина:
В коде используется AndroidInitializationSettings('ic_launcher'), но ic_launcher находится в mipmap, а не в drawable
Android требует иконку уведомлений в drawable
Файл ic_stat_ic_notification.xml существует, но имеет неправильное имя и не используется"	"android/app/src/main/res/drawable/ic_stat_ic_notification.xml — переименовать
lib/services/notifications_service.dart — изменить строку 51"	"android/app/src/main/res/drawable/ic_stat_ic_notification.xml → переименовать файл
lib/services/notifications_service.dart:51
Файл: android/app/src/main/res/drawable/ic_stat_ic_notification.xml (существует, но не используется)
Должно быть:
Переименовать файл: ic_stat_ic_notification.xml → ic_stat_notify.xml
Изменить код:
// lib/services/notifications_service.dart:51
const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('ic_stat_notify');"

5. UX / GP Bonus Display	 При каждом сохранении записи в дневнике практики показывается сообщение "+5 GP за практику сегодня", хотя бонус начисляется только один раз в день (идемпотентно). Это вводит пользователя в заблуждение.	"Сообщение показывается всегда после сохранения записи (строки 336-339 в practice_journal_section.dart)
Не проверяется, был ли бонус фактически начислен
_claimDailyBonusAndRefresh() вызывается асинхронно через unawaited, результат не проверяется
Функция gp_claim_daily_application() идемпотентна и начисляет бонус только один раз в день, но UI не учитывает это"	 lib/screens/goal/widgets/practice_journal_section.dart	"Строки для изменения: 332-340
// Проверяем, был ли фактически начислен бонус
try {
  if (!context.mounted) return;
  final gp = GpService(Supabase.instance.client);
  final balanceBefore = await gp.getBalance();
  final balanceBeforeValue = balanceBefore['balance'] ?? 0;
  
  // Вызываем claim и проверяем результат
  await ref.read(goalsRepositoryProvider).addPracticeEntry(
    // ... параметры ...
  );
  
  // Проверяем баланс после начисления
  final balanceAfter = await gp.getBalance();
  final balanceAfterValue = balanceAfter['balance'] ?? 0;
  
  // Показываем сообщение только если баланс увеличился
  if (balanceAfterValue > balanceBeforeValue && context.mounted) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
          content: Text('+${balanceAfterValue - balanceBeforeValue} GP за практику сегодня')),
    );
  }
} catch (_) {}
Альтернативное решение: Использовать результат RPC gp_claim_daily_application(), который возвращает balance_after, и сравнивать с балансом до вызова."

6. Башня/Уровень/ Обсудить с Лео	Вылет в башню	"не определил еще. Вылет именно в мобильном приложении, при запуске локально с main - все нормально

Скорее всего, это связано с различиями в версиях Flutter или зависимостей, из-за чего меняется поведение showModalBottomSheet при поднятии клавиатуры. При фокусе на TextField модальное окно может закрываться из-за изменений в обработке жестов или размерах."	"# Сравнить pubspec.lock локально и на продакшене
# Особенно обратить внимание на:
# - flutter версию
# - flutter_riverpod
# - go_router
Проверить логи/краш-репорты
Проверить Sentry/логи на наличие ошибок при фокусе на TextField
Искать Navigator.pop, context.pop, закрытие модального окна
3. Проверить обработку жестов
В leo_dialog_screen.dart:
GestureDetector с HitTestBehavior.opaque может перехватывать тапы
Проверить, не закрывается ли модальное окно при изменении размера из-за клавиатуры
4. Проверить поведение модального окна
В level_detail_screen.dart (строка 96):
Добавить логирование в builder модального окна
Проверить, не вызывается ли закрытие при фокусе
5. Проверить различия в конфигурации
Различия в main.dart между локальной и продакшен версиями
Различия в обработке навигации (go_router vs Navigator)
Различия в обработке клавиатуры на разных платформах
Рекомендации для отладки
Добавить логирование:
В onDiscuss перед открытием модального окна
В TextField при onTap
В GestureDetector.onTap в leo_dialog_screen.dart
Проверить поведение клавиатуры:
resizeToAvoidBottomInset в Scaffold
Влияние SafeArea на размеры модального окна
Проверить навигацию:
Использование context.pop() vs Navigator.pop()
Возможные автоматические закрытия модального окна
Сравнить код:
Убедиться, что код на продакшене соответствует локальной версии main
Проверить незакоммиченные изменения"	