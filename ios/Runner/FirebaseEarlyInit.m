/**
 * FirebaseEarlyInit.m
 *
 * ОТКЛЮЧЕНО 2025-12-07: Ранний bootstrap Firebase блокировал main thread,
 * вызывая чёрный экран при запуске. Firebase теперь инициализируется
 * в AppDelegate.didFinishLaunchingWithOptions.
 *
 * Проблема:
 * - +load и constructor вызываются dyld до main()
 * - [FIRApp configure] делает I/O на main thread (NSData, NSBundle, dlopen)
 * - Main thread блокируется, Flutter не может отрисовать первый кадр
 *
 * Решение:
 * - Оставляем только логирование, без реальной инициализации Firebase
 * - Firebase инициализируется позже в AppDelegate
 */

#import <Foundation/Foundation.h>
#import "Runner-Swift.h"

#if __has_include(<FirebaseCore/FirebaseCore.h>)
@import FirebaseCore;
@interface FIRApp (FirebaseEarlyInitPrivate)
+ (BOOL)isDefaultAppConfigured;
@end
#endif

static NSString *FirebaseEarlyInitCallerString(const char *caller) {
  if (caller == NULL) {
    return @"unknown";
  }
  return [NSString stringWithUTF8String:caller];
}

// ОТКЛЮЧЕНО: Больше не инициализируем Firebase рано
// static void ConfigureFirebaseOnObjCIfNeeded(const char *caller, BOOL logStack) { ... }

__attribute__((constructor(0))) static void FirebaseUltraEarlyInitConstructor(void) {
  // ОТКЛЮЧЕНО: Не инициализируем Firebase в constructor
  // Firebase будет инициализирован в AppDelegate.didFinishLaunchingWithOptions
}

__attribute__((constructor)) static void FirebaseEarlyInitConstructor(void) {
  // ОТКЛЮЧЕНО: Не инициализируем Firebase в constructor
  // Только вызываем AppDelegate для подготовки (без [FIRApp configure])
#if __has_include(<FirebaseCore/FirebaseCore.h>)
  @autoreleasepool {
    // [AppDelegate configureFirebaseBeforeMain] теперь вызывается в didFinishLaunching
  }
#endif
}

@interface FirebaseEarlyInitSentinel : NSObject
@end

@implementation FirebaseEarlyInitSentinel

+ (void)load {
  // ОТКЛЮЧЕНО: Не инициализируем Firebase в +load
  // Это блокировало main thread и вызывало чёрный экран
}

@end


