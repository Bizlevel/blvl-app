#import "BizPluginRegistrant.h"
#import "GeneratedPluginRegistrant.h"

#if __has_include(<in_app_purchase_storekit/InAppPurchasePlugin.h>)
#import <in_app_purchase_storekit/InAppPurchasePlugin.h>
#endif

@implementation BizPluginRegistrant

+ (void)registerEssentialPlugins:(NSObject<FlutterPluginRegistry> *)registry {
  NSLog(@"BizPluginRegistrant: registerEssentialPlugins");
  [GeneratedPluginRegistrant registerWithRegistry:registry];
}

+ (void)registerDeferredIap:(NSObject<FlutterPluginRegistry> *)registry {
#if __has_include(<in_app_purchase_storekit/InAppPurchasePlugin.h>)
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSLog(@"BizPluginRegistrant: registerDeferredIap invoked");
    id<FlutterPluginRegistrar> registrar =
        [registry registrarForPlugin:@"InAppPurchasePlugin"];
    if (registrar) {
      [InAppPurchasePlugin registerWithRegistrar:registrar];
      NSLog(@"BizPluginRegistrant: InAppPurchasePlugin registered lazily");
    } else {
      NSLog(@"BizPluginRegistrant: registrar for InAppPurchasePlugin not found");
    }
  });
#else
  NSLog(@"BizPluginRegistrant: in_app_purchase_storekit headers not present, skipping deferred IAP");
  (void)registry;
#endif
}

@end




