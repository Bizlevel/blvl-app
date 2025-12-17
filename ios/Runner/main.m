#import <UIKit/UIKit.h>
#import "Runner-Swift.h"

int main(int argc, char* argv[]) {
  @autoreleasepool {
    // ОТКЛЮЧЕНО 2025-12-07: Ранний вызов Firebase блокировал main thread
    // Firebase инициализируется позже в AppDelegate.willFinishLaunchingWithOptions
    // [AppDelegate configureFirebaseBeforeMain];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}

