#import <Foundation/Foundation.h>
#import "Runner-Swift.h"

__attribute__((constructor)) static void FirebaseEarlyInitConstructor(void) {
  @autoreleasepool {
    NSLog(@"FirebaseEarlyInit: configuring Firebase before UIApplicationMain");
    [AppDelegate configureFirebaseBeforeMain];
  }
}


