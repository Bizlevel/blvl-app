#import <Foundation/Foundation.h>
#import "Runner-Swift.h"
@import FirebaseCore;

@interface FIRApp (FirebaseEarlyInitPrivate)
+ (BOOL)isDefaultAppConfigured;
@end

static NSString *FirebaseEarlyInitCallerString(const char *caller) {
  if (caller == NULL) {
    return @"unknown";
  }
  return [NSString stringWithUTF8String:caller];
}

static void FirebaseEarlyInitLogCallStackOnce(NSString *label) {
  static BOOL didLogStack = NO;
  if (didLogStack) {
    return;
  }
  didLogStack = YES;

  NSArray<NSString *> *symbols = [NSThread callStackSymbols];
  if (symbols.count == 0) {
    return;
  }

  NSString *joined = [symbols componentsJoinedByString:@"\n"];
  NSLog(@"FirebaseEarlyInit(%@): call stack at first configure attempt:\n%@",
        label, joined);
}

static void ConfigureFirebaseOnObjCIfNeeded(const char *caller, BOOL logStack) {
  NSString *callerString = FirebaseEarlyInitCallerString(caller);
  if (logStack) {
    FirebaseEarlyInitLogCallStackOnce(callerString);
  }

  @try {
    if (![FIRApp isDefaultAppConfigured]) {
      [FIRApp configure];
      NSLog(@"FirebaseEarlyInit(%@): FIRApp configure() executed on Objective-C layer",
            callerString);
    } else {
      NSLog(@"FirebaseEarlyInit(%@): FIRApp already configured before ObjC hook",
            callerString);
    }
  } @catch (NSException *exception) {
    NSLog(@"FirebaseEarlyInit(%@): FIRApp configure threw exception: %@",
          callerString, exception);
  }
}

__attribute__((constructor(0))) static void FirebaseUltraEarlyInitConstructor(void) {
  @autoreleasepool {
    ConfigureFirebaseOnObjCIfNeeded("constructor0", NO);
  }
}

__attribute__((constructor)) static void FirebaseEarlyInitConstructor(void) {
  @autoreleasepool {
    NSLog(@"FirebaseEarlyInit: configuring Firebase before UIApplicationMain");
    ConfigureFirebaseOnObjCIfNeeded("constructor_default", NO);
    [AppDelegate configureFirebaseBeforeMain];
  }
}

@interface FirebaseEarlyInitSentinel : NSObject
@end

@implementation FirebaseEarlyInitSentinel

+ (void)load {
  @autoreleasepool {
    NSLog(@"FirebaseEarlyInit: +load invoked before constructors");
    ConfigureFirebaseOnObjCIfNeeded("load", YES);
  }
}

@end


