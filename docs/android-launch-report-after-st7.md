# Android launch report after Stage 7

Дата: <!--CURSOR IDE автоматически подставит дату коммита-->

## 1. Симптомы
* Проект не собирается и не запускается на эмуляторе Android Studio.
* Gradle падает уже на фазе конфигурации скриптов с ошибкой
  `Unsupported class file major version 65/67`.
* Ошибка возникает как при `flutter run`, так и при прямом вызове `./gradlew assembleDebug`.

## 2. Диагностика
1. **JDK 21 vs. Gradle 6/AGP 4.1**  
   – изначально в проекте стояли Gradle 6.7 + Android Gradle Plugin 4.1.0 + Kotlin 1.3.50.  
   – Эти версии понимают только byte-code до Java 15 (major 59).  
   – Flutter 3.22 поставляется с JDK 21 ⇒ Gradle скрипты падают при первом же классе, скомпилированном для Java 21 (major 65).
2. **Миграция инструментов**  
   – Gradle wrapper повышен до **8.5**.  
   – Android Gradle Plugin повышен до **8.2.2**.  
   – Kotlin Gradle Plugin повышен сначала до 1.9.22 → позже понижен до 1.9.24 (совместима с AGP 8 и JDK 21).  
   – compile/targetSdk подняты до **34**, добавлен `namespace`.
3. **Flutter declarative plugins**  
   – Переход на `plugins { id 'dev.flutter.flutter-gradle-plugin' }` в `app/build.gradle` вызвал цепочку ошибок (`BaseVariant` API removed).  
   – Решено откатиться к классическому 
     ```groovy
     apply plugin: 'com.android.application'
     apply plugin: 'kotlin-android'
     apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
     ```
4. **settings.gradle**  
   – Эксперименты с `dev.flutter.flutter-plugin-loader` (новый declarative loader) приводили к той же ошибке major 67.  
   – Вернули штатный `app_plugin_loader.gradle` из Flutter SDK через `apply from:`.
5. **Кеши Gradle**  
   – После откатов ошибка `major 67` не исчезла ⇒ в кеш подгружён JAR, собранный Java 23.  
   – Кандидат №1 — «dev.flutter.flutter-plugin-loader:1.0.0».  
   – Удалены скриптовые кеши `~/.gradle/caches/8.5/scripts`, остановлены демоны.

## 3. Текущее состояние
* Проект всё ещё падает на конфигурации:  
  `Could not open cp_settings generic class cache … Unsupported class file major version 67`.
* Это означает, что в **classpath groovy-скриптов** всё ещё лежит JAR с byte-code Java 23.

## 4. Возможные пути решения
| # | Шаг | Плюсы | Минусы |
|---|-----|-------|--------|
| 1 | Полностью очистить кеши Gradle: `rm -rf ~/.gradle/caches` и пересобрать | Быстро, гарантированный сброс «грязных» JAR-ов | Перекачает ~1 GB зависимостей |
| 2 | Точечно удалить пакеты, собранные 67-м major, например `dev.flutter.flutter-plugin-loader` | Сохраняет кеш, быстрее сети | Требует ручного поиска offending JAR |
| 3 | Запустить сборку под JDK 23 (`JAVA_HOME`), проверить что всё проходит, затем вернуться к 21 | Быстрая валидация источника ошибки | Не решает корневую проблему несовместимости |
| 4 | Полностью откатить эксперимент с declarative Flutter plugin, оставить только классический `flutter.gradle` / `app_plugin_loader.gradle` | Самый простой и поддерживаемый Flutter-способ | Потеряем «новый» Declarative DSL |
| 5 | Зафиксировать Gradle 8.4 (он собирался JDK 17), если окажется, что именно 8.5 тащит JAR 67 | Уменьшаем риск | Требует проверки совместимости AGP 8.2.2 + Gradle 8.4 |

## 5. Рекомендуемый next step
1. Выполнить
   ```bash
   rm -rf ~/.gradle/caches/modules-2/files-2.1/dev.flutter.flutter-plugin-loader
   rm -rf ~/.gradle/caches/8.5/scripts
   ./android/gradlew --stop
   ```
2. Повторить `./android/gradlew -p android clean assembleDebug --stacktrace`.
3. Если ошибка исчезла — закоммитить успешный билд и перейти к `flutter run`.
4. Если нет — запустить поиск JAR-ов с major 67:
   ```bash
   find ~/.gradle/caches/modules-2 -name '*.jar' | \
     xargs -I{} sh -c 'od -An -t x1 -N 8 {} | grep -q "ca fe ba be 00 00 43" && echo {}'
   ```
   и удалить/заменить найденные пакеты.

---
*Отчёт составлен в рамках Stage 7 миграции Android-части BizLevel.*
