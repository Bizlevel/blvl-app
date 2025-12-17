#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BizPluginRegistrant : NSObject
+ (void)registerEssentialPlugins:(NSObject<FlutterPluginRegistry> *)registry;
+ (void)registerDeferredIap:(NSObject<FlutterPluginRegistry> *)registry;
+ (void)registerMediaPlugins:(NSObject<FlutterPluginRegistry> *)registry;
@end

NS_ASSUME_NONNULL_END






