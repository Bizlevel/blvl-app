#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static BOOL MTIStackHasAppFrame(NSArray<NSString *> *stack) {
  static NSArray<NSString *> *markers;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    markers = @[@" Runner", @"BizLevel", @"bizlevel"];
  });
  for (NSString *symbol in stack) {
    for (NSString *marker in markers) {
      if ([symbol rangeOfString:marker options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
      }
    }
  }
  return NO;
}

static NSString *MTIStackDump(NSArray<NSString *> *stack) {
  return [stack componentsJoinedByString:@"\n"];
}

static void MTILogOnce(NSString *label, NSString *details) {
  static NSMutableSet<NSString *> *loggedLabels;
  static dispatch_once_t onceToken;
  static dispatch_queue_t queue;
  dispatch_once(&onceToken, ^{
    loggedLabels = [[NSMutableSet alloc] init];
    queue = dispatch_queue_create("bizlevel.main-thread-io-monitor", DISPATCH_QUEUE_SERIAL);
  });

  NSArray<NSString *> *stack = [NSThread callStackSymbols];
  if (!MTIStackHasAppFrame(stack)) {
    return;
  }

  dispatch_sync(queue, ^{
    if ([loggedLabels containsObject:label]) {
      return;
    }
    [loggedLabels addObject:label];
    NSLog(@"MainThreadIOMonitor: %@ (%@)\n%@",
          label,
          details ?: @"",
          MTIStackDump(stack));
  });
}

static BOOL MTIPathContainsAny(NSString *path, NSArray<NSString *> *needles) {
  if (path.length == 0) {
    return NO;
  }
  for (NSString *needle in needles) {
    if ([path rangeOfString:needle].location != NSNotFound) {
      return YES;
    }
  }
  return NO;
}

static BOOL MTIShouldLogDataPath(NSString *path) {
  static NSArray<NSString *> *ignoredSubstrings;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ignoredSubstrings = @[
      @"/System/Library/",
      @"UserConfigurationProfiles",
      @"systemgroup.com.apple.configurationprofiles"
    ];
  });
  return !MTIPathContainsAny(path, ignoredSubstrings);
}

static BOOL MTIShouldLogBundlePath(NSString *path) {
  static NSArray<NSString *> *ignoredSubstrings;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ignoredSubstrings = @[
      @"/System/Library/",
      @"/Runner.app"
    ];
  });
  return !MTIPathContainsAny(path, ignoredSubstrings);
}

static BOOL MTIShouldLogCreatedDirectoryPath(NSString *path) {
  if (path.length == 0) {
    return YES;
  }
  if ([path hasSuffix:@"/Library"] &&
      [path rangeOfString:@"/Containers/Data/Application/"].location != NSNotFound) {
    return NO;
  }
  static NSArray<NSString *> *ignoredSubstrings;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ignoredSubstrings = @[
      @"/System/Library/",
      @"systemgroup.com.apple.configurationprofiles"
    ];
  });
  return !MTIPathContainsAny(path, ignoredSubstrings);
}

static void MTISwizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(cls, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
  if (!originalMethod || !swizzledMethod) {
    return;
  }

  BOOL didAddMethod =
      class_addMethod(cls,
                      originalSelector,
                      method_getImplementation(swizzledMethod),
                      method_getTypeEncoding(swizzledMethod));

  if (didAddMethod) {
    class_replaceMethod(cls,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

static void MTISwizzleClassMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
  Class metaclass = object_getClass(cls);
  MTISwizzleInstanceMethod(metaclass, originalSelector, swizzledSelector);
}

@interface NSData (MainThreadIOMonitor)
- (instancetype)mti_initWithContentsOfFile:(NSString *)path
                                   options:(NSDataReadingOptions)mask
                                     error:(NSError *__autoreleasing *)error;
+ (NSData *)mti_dataWithContentsOfFile:(NSString *)path
                               options:(NSDataReadingOptions)mask
                                 error:(NSError *__autoreleasing *)error;
@end

@implementation NSData (MainThreadIOMonitor)

- (instancetype)mti_initWithContentsOfFile:(NSString *)path
                                   options:(NSDataReadingOptions)mask
                                     error:(NSError *__autoreleasing *)error {
  if ([NSThread isMainThread]) {
    if (MTIShouldLogDataPath(path)) {
      MTILogOnce(@"-[NSData initWithContentsOfFile:options:error:]", path);
    }
  }
  return [self mti_initWithContentsOfFile:path options:mask error:error];
}

+ (NSData *)mti_dataWithContentsOfFile:(NSString *)path
                               options:(NSDataReadingOptions)mask
                                 error:(NSError *__autoreleasing *)error {
  if ([NSThread isMainThread]) {
    if (MTIShouldLogDataPath(path)) {
      MTILogOnce(@"+[NSData dataWithContentsOfFile:options:error:]", path);
    }
  }
  return [self mti_dataWithContentsOfFile:path options:mask error:error];
}

@end

@interface NSFileManager (MainThreadIOMonitor)
- (BOOL)mti_createDirectoryAtPath:(NSString *)path
       withIntermediateDirectories:(BOOL)createIntermediates
                        attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes
                             error:(NSError *__autoreleasing *)error;
@end

@implementation NSFileManager (MainThreadIOMonitor)

- (BOOL)mti_createDirectoryAtPath:(NSString *)path
       withIntermediateDirectories:(BOOL)createIntermediates
                        attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes
                             error:(NSError *__autoreleasing *)error {
  if ([NSThread isMainThread]) {
    if (MTIShouldLogCreatedDirectoryPath(path)) {
      MTILogOnce(@"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]",
                 path);
    }
  }
  return [self mti_createDirectoryAtPath:path
              withIntermediateDirectories:createIntermediates
                               attributes:attributes
                                    error:error];
}

@end

@interface NSBundle (MainThreadIOMonitor)
- (NSString *)mti_bundleIdentifier;
@end

@implementation NSBundle (MainThreadIOMonitor)

- (NSString *)mti_bundleIdentifier {
  if ([NSThread isMainThread]) {
    if (MTIShouldLogBundlePath(self.bundlePath)) {
      MTILogOnce(@"-[NSBundle bundleIdentifier]", self.bundlePath);
    }
  }
  return [self mti_bundleIdentifier];
}

@end

__attribute__((constructor)) static void MTIInstallMainThreadMonitor(void) {
  NSDictionary<NSString *, NSString *> *environment = [[NSProcessInfo processInfo] environment];
  if (environment[@"DISABLE_MAIN_THREAD_IO_MONITOR"] != nil) {
    return;
  }

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    MTISwizzleInstanceMethod([NSData class],
                             @selector(initWithContentsOfFile:options:error:),
                             @selector(mti_initWithContentsOfFile:options:error:));
    MTISwizzleClassMethod([NSData class],
                          @selector(dataWithContentsOfFile:options:error:),
                          @selector(mti_dataWithContentsOfFile:options:error:));
    MTISwizzleInstanceMethod([NSFileManager class],
                             @selector(createDirectoryAtPath:withIntermediateDirectories:attributes:error:),
                             @selector(mti_createDirectoryAtPath:withIntermediateDirectories:attributes:error:));
    MTISwizzleInstanceMethod([NSBundle class],
                             @selector(bundleIdentifier),
                             @selector(mti_bundleIdentifier));
  });
}

