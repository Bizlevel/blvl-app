#import "BizPluginRegistrant.h"
#import "GeneratedPluginRegistrant.h"

#if __has_include(<photo_manager/PhotoManagerPlugin.h>)
#import <photo_manager/PhotoManagerPlugin.h>
#endif

#if __has_include(<file_selector_ios/FileSelectorPlugin.h>)
#import <file_selector_ios/FileSelectorPlugin.h>
#endif

#if __has_include(<webview_flutter_wkwebview/WebViewFlutterPlugin.h>)
#import <webview_flutter_wkwebview/WebViewFlutterPlugin.h>
#endif

@implementation BizPluginRegistrant

+ (void)registerEssentialPlugins:(NSObject<FlutterPluginRegistry> *)registry {
  NSLog(@"BizPluginRegistrant: registerEssentialPlugins");
  [GeneratedPluginRegistrant registerWithRegistry:registry];
}

+ (void)registerDeferredIap:(NSObject<FlutterPluginRegistry> *)registry {
  NSLog(@"BizPluginRegistrant: registerDeferredIap skipped (StoreKit1 disabled)");
  (void)registry;
}

+ (void)registerMediaPlugins:(NSObject<FlutterPluginRegistry> *)registry {
#if __has_include(<photo_manager/PhotoManagerPlugin.h>)
  id<FlutterPluginRegistrar> photoRegistrar =
      [registry registrarForPlugin:@"PhotoManagerPlugin"];
  if (photoRegistrar) {
    [PhotoManagerPlugin registerWithRegistrar:photoRegistrar];
    NSLog(@"BizPluginRegistrant: PhotoManagerPlugin registered lazily");
  }
#endif

#if __has_include(<file_selector_ios/FileSelectorPlugin.h>)
  id<FlutterPluginRegistrar> fileSelectorRegistrar =
      [registry registrarForPlugin:@"FileSelectorPlugin"];
  if (fileSelectorRegistrar) {
    [FileSelectorPlugin registerWithRegistrar:fileSelectorRegistrar];
    NSLog(@"BizPluginRegistrant: FileSelectorPlugin registered lazily");
  }
#endif

#if __has_include(<webview_flutter_wkwebview/WebViewFlutterPlugin.h>)
  id<FlutterPluginRegistrar> webviewRegistrar =
      [registry registrarForPlugin:@"FLTWebViewFlutterPlugin"];
  if (webviewRegistrar) {
    [WebViewFlutterPlugin registerWithRegistrar:webviewRegistrar];
    NSLog(@"BizPluginRegistrant: WebViewFlutterPlugin registered lazily");
  }
#endif
}

@end




