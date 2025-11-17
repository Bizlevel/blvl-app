#import <UIKit/UIKit.h>
#import "Runner-Swift.h"

int main(int argc, char* argv[]) {
  @autoreleasepool {
    [AppDelegate configureFirebaseBeforeMain];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}

