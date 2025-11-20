
Showing All Issues

Prepare build

SwiftExplicitDependencyGeneratePcm arm64 /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/in_app_purchase_storekit-6FXEEO1CICJLNM1JPTF2RHQQL.pcm

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:14:40: warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
12 | 
13 | // Converts an instance of SKProduct into a dictionary.
14 | + (NSDictionary *)getMapFromSKProduct:(SKProduct *)product;
   |                                        `- warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
15 | 
16 | // Converts an instance of SKProductSubscriptionPeriod into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: note: 'SKProduct' has been explicitly marked deprecated here
39 | API_DEPRECATED("Use Product", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
40 | NS_SWIFT_SENDABLE
41 | @interface SKProduct : NSObject {
   |            `- note: 'SKProduct' has been explicitly marked deprecated here
42 | @private
43 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:17:58: warning: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod
15 | 
16 | // Converts an instance of SKProductSubscriptionPeriod into a dictionary.
17 | + (NSDictionary *)getMapFromSKProductSubscriptionPeriod:(SKProductSubscriptionPeriod *)period
   |                                                          `- warning: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod
18 |     API_AVAILABLE(ios(11.2));
19 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:27:12: note: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use Product.SubscriptionPeriod", ios(11.2, 18.0), macos(10.13.2, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKProductSubscriptionPeriod : NSObject {
   |            `- note: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:21:48: warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
19 | 
20 | // Converts an instance of SKProductDiscount into a dictionary.
21 | + (NSDictionary *)getMapFromSKProductDiscount:(SKProductDiscount *)discount
   |                                                `- warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
22 |     API_AVAILABLE(ios(11.2));
23 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: note: 'SKProductDiscount' has been explicitly marked deprecated here
31 | API_DEPRECATED("Use Product.SubscriptionOffer", ios(11.2, 18.0), macos(10.13.2, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
32 | NS_SWIFT_SENDABLE
33 | @interface SKProductDiscount : NSObject {
   |            `- note: 'SKProductDiscount' has been explicitly marked deprecated here
34 | @private
35 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:26:22: warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
24 | // Converts an array of SKProductDiscount instances into an array of dictionaries.
25 | + (nonnull NSArray *)getMapArrayFromSKProductDiscounts:
26 |     (nonnull NSArray<SKProductDiscount *> *)productDiscounts API_AVAILABLE(ios(12.2));
   |                      `- warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
27 | 
28 | // Converts an instance of SKProductsResponse into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: note: 'SKProductDiscount' has been explicitly marked deprecated here
31 | API_DEPRECATED("Use Product.SubscriptionOffer", ios(11.2, 18.0), macos(10.13.2, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
32 | NS_SWIFT_SENDABLE
33 | @interface SKProductDiscount : NSObject {
   |            `- note: 'SKProductDiscount' has been explicitly marked deprecated here
34 | @private
35 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:29:49: warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
27 | 
28 | // Converts an instance of SKProductsResponse into a dictionary.
29 | + (NSDictionary *)getMapFromSKProductsResponse:(SKProductsResponse *)productResponse;
   |                                                 `- warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
30 | 
31 | // Converts an instance of SKPayment into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: note: 'SKProductsResponse' has been explicitly marked deprecated here
42 | API_DEPRECATED("Get products using Product.products(for:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
43 | NS_SWIFT_SENDABLE
44 | @interface SKProductsResponse : NSObject {
   |            `- note: 'SKProductsResponse' has been explicitly marked deprecated here
45 | @private
46 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:32:40: warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
30 | 
31 | // Converts an instance of SKPayment into a dictionary.
32 | + (NSDictionary *)getMapFromSKPayment:(SKPayment *)payment;
   |                                        `- warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
33 | 
34 | // Converts an instance of NSLocale into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: note: 'SKPayment' has been explicitly marked deprecated here
17 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
   |            `- note: 'SKPayment' has been explicitly marked deprecated here
20 | @private
21 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:38:4: warning: 'SKMutablePayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
36 | 
37 | // Creates an instance of the SKMutablePayment class based on the supplied dictionary.
38 | + (SKMutablePayment *)getSKMutablePaymentFromMap:(NSDictionary *)map;
   |    `- warning: 'SKMutablePayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
39 | 
40 | // Converts an instance of SKPaymentTransaction into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:52:12: note: 'SKMutablePayment' has been explicitly marked deprecated here
50 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
51 | NS_SWIFT_NONSENDABLE
52 | @interface SKMutablePayment : SKPayment
   |            `- note: 'SKMutablePayment' has been explicitly marked deprecated here
53 | 
54 | @property(nonatomic, copy, readwrite, nullable) NSString *applicationUsername API_DEPRECATED("Create a Product.PurchaseOption.appAccountToken to use in Product.purchase(confirmIn:options:)", ios(7.0, 18.0), macos(10.9, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0));

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:41:51: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
39 | 
40 | // Converts an instance of SKPaymentTransaction into a dictionary.
41 | + (NSDictionary *)getMapFromSKPaymentTransaction:(SKPaymentTransaction *)transaction;
   |                                                   `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
42 | 
43 | // Converts an instance of NSError into a dictionary.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:47:43: warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
45 | 
46 | // Converts an instance of SKStorefront into a dictionary.
47 | + (NSDictionary *)getMapFromSKStorefront:(SKStorefront *)storefront
   |                                           `- warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
48 |     API_AVAILABLE(ios(13), macos(10.15), watchos(6.2));
49 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: note: 'SKStorefront' has been explicitly marked deprecated here
14 | API_DEPRECATED("Use Storefront", ios(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKStorefront : NSObject
   |            `- note: 'SKStorefront' has been explicitly marked deprecated here
17 | 
18 | /* The three letter country code for the current storefront */

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:51:43: warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
49 | 
50 | // Converts the supplied instances of SKStorefront and SKPaymentTransaction into a dictionary.
51 | + (NSDictionary *)getMapFromSKStorefront:(SKStorefront *)storefront
   |                                           `- warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
52 |                  andSKPaymentTransaction:(SKPaymentTransaction *)transaction
53 |     API_AVAILABLE(ios(13), macos(10.15), watchos(6.2));

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: note: 'SKStorefront' has been explicitly marked deprecated here
14 | API_DEPRECATED("Use Storefront", ios(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKStorefront : NSObject
   |            `- note: 'SKStorefront' has been explicitly marked deprecated here
17 | 
18 | /* The three letter country code for the current storefront */

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:52:43: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
50 | // Converts the supplied instances of SKStorefront and SKPaymentTransaction into a dictionary.
51 | + (NSDictionary *)getMapFromSKStorefront:(SKStorefront *)storefront
52 |                  andSKPaymentTransaction:(SKPaymentTransaction *)transaction
   |                                           `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
53 |     API_AVAILABLE(ios(13), macos(10.15), watchos(6.2));
54 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:56:13: warning: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)
54 | 
55 | // Creates an instance of the SKPaymentDiscount class based on the supplied dictionary.
56 | + (nullable SKPaymentDiscount *)getSKPaymentDiscountFromMap:(NSDictionary *)map
   |             `- warning: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)
57 |                                                   withError:(NSString *_Nullable *_Nullable)error
58 |     API_AVAILABLE(ios(12.2));

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentDiscount.h:16:12: note: 'SKPaymentDiscount' has been explicitly marked deprecated here
14 | API_DEPRECATED("Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)", ios(12.2, 18.0), tvos(12.2, 18.0), macos(10.14.4, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKPaymentDiscount : NSObject {
   |            `- note: 'SKPaymentDiscount' has been explicitly marked deprecated here
17 | @private
18 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:61:15: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
59 | 
60 | + (nullable FIASKPaymentTransactionMessage *)convertTransactionToPigeon:
61 |     (nullable SKPaymentTransaction *)transaction;
   |               `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
62 | 
63 | + (nullable FIASKStorefrontMessage *)convertStorefrontToPigeon:(nullable SKStorefront *)storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:63:74: warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
61 |     (nullable SKPaymentTransaction *)transaction;
62 | 
63 | + (nullable FIASKStorefrontMessage *)convertStorefrontToPigeon:(nullable SKStorefront *)storefront
   |                                                                          `- warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
64 |     API_AVAILABLE(ios(13.0));
65 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: note: 'SKStorefront' has been explicitly marked deprecated here
14 | API_DEPRECATED("Use Storefront", ios(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKStorefront : NSObject
   |            `- note: 'SKStorefront' has been explicitly marked deprecated here
17 | 
18 | /* The three letter country code for the current storefront */

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:67:15: warning: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)
65 | 
66 | + (nullable FIASKPaymentDiscountMessage *)convertPaymentDiscountToPigeon:
67 |     (nullable SKPaymentDiscount *)discount API_AVAILABLE(ios(12.2));
   |               `- warning: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)
68 | 
69 | + (nullable FIASKPaymentMessage *)convertPaymentToPigeon:(nullable SKPayment *)payment

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentDiscount.h:16:12: note: 'SKPaymentDiscount' has been explicitly marked deprecated here
14 | API_DEPRECATED("Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)", ios(12.2, 18.0), tvos(12.2, 18.0), macos(10.14.4, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKPaymentDiscount : NSObject {
   |            `- note: 'SKPaymentDiscount' has been explicitly marked deprecated here
17 | @private
18 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:69:68: warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
67 |     (nullable SKPaymentDiscount *)discount API_AVAILABLE(ios(12.2));
68 | 
69 | + (nullable FIASKPaymentMessage *)convertPaymentToPigeon:(nullable SKPayment *)payment
   |                                                                    `- warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
70 |     API_AVAILABLE(ios(12.2));
71 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: note: 'SKPayment' has been explicitly marked deprecated here
17 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
   |            `- note: 'SKPayment' has been explicitly marked deprecated here
20 | @private
21 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:75:15: warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
73 | 
74 | + (nullable FIASKProductsResponseMessage *)convertProductsResponseToPigeon:
75 |     (nullable SKProductsResponse *)payment;
   |               `- warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
76 | 
77 | + (nullable FIASKProductMessage *)convertProductToPigeon:(nullable SKProduct *)product

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: note: 'SKProductsResponse' has been explicitly marked deprecated here
42 | API_DEPRECATED("Get products using Product.products(for:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
43 | NS_SWIFT_SENDABLE
44 | @interface SKProductsResponse : NSObject {
   |            `- note: 'SKProductsResponse' has been explicitly marked deprecated here
45 | @private
46 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:77:68: warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
75 |     (nullable SKProductsResponse *)payment;
76 | 
77 | + (nullable FIASKProductMessage *)convertProductToPigeon:(nullable SKProduct *)product
   |                                                                    `- warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
78 |     API_AVAILABLE(ios(12.2));
79 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: note: 'SKProduct' has been explicitly marked deprecated here
39 | API_DEPRECATED("Use Product", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
40 | NS_SWIFT_SENDABLE
41 | @interface SKProduct : NSObject {
   |            `- note: 'SKProduct' has been explicitly marked deprecated here
42 | @private
43 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:81:15: warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
79 | 
80 | + (nullable FIASKProductDiscountMessage *)convertProductDiscountToPigeon:
81 |     (nullable SKProductDiscount *)productDiscount API_AVAILABLE(ios(12.2));
   |               `- warning: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer
82 | 
83 | + (nullable FIASKPriceLocaleMessage *)convertNSLocaleToPigeon:(nullable NSLocale *)locale

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: note: 'SKProductDiscount' has been explicitly marked deprecated here
31 | API_DEPRECATED("Use Product.SubscriptionOffer", ios(11.2, 18.0), macos(10.13.2, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
32 | NS_SWIFT_SENDABLE
33 | @interface SKProductDiscount : NSObject {
   |            `- note: 'SKProductDiscount' has been explicitly marked deprecated here
34 | @private
35 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
11 | #endif
12 | 
13 | #import "FIAObjectTranslator.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:87:15: warning: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod
85 | 
86 | + (nullable FIASKProductSubscriptionPeriodMessage *)convertSKProductSubscriptionPeriodToPigeon:
87 |     (nullable SKProductSubscriptionPeriod *)period API_AVAILABLE(ios(12.2));
   |               `- warning: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod
88 | @end
89 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:27:12: note: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use Product.SubscriptionPeriod", ios(11.2, 18.0), macos(10.13.2, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKProductSubscriptionPeriod : NSObject {
   |            `- note: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:13:30: warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
11 | 
12 | /// An object containing the location and unique identifier of an Apple App Store storefront.
13 | @property(nonatomic, strong) SKStorefront *storefront API_AVAILABLE(ios(13.0));
   |                              `- warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
14 | 
15 | /// A list of SKPaymentTransactions, which each represents a single transaction

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: note: 'SKStorefront' has been explicitly marked deprecated here
14 | API_DEPRECATED("Use Storefront", ios(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKStorefront : NSObject
   |            `- note: 'SKStorefront' has been explicitly marked deprecated here
17 | 
18 | /* The three letter country code for the current storefront */

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:16:38: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
14 | 
15 | /// A list of SKPaymentTransactions, which each represents a single transaction
16 | @property(nonatomic, strong) NSArray<SKPaymentTransaction *> *transactions API_AVAILABLE(
   |                                      `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
17 |     ios(3.0), macos(10.7), watchos(6.2));
18 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:20:41: warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
18 | 
19 | /// An object that provides information needed to complete transactions.
20 | @property(nonatomic, weak, nullable) id<SKPaymentQueueDelegate> delegate API_AVAILABLE(
   |                                         `- warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
21 |     ios(13.0), macos(10.15), watchos(6.2));
22 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 76 | 
 77 | API_DEPRECATED("No longer supported", ios(13.0, 18.0), tvos(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 78 | @protocol SKPaymentQueueDelegate <NSObject>
    |           `- note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 79 | @optional
 80 | // Sent when the storefront changes while a payment is processing.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:25:36: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
23 | /// Remove a finished (i.e. failed or completed) transaction from the queue.  Attempting to finish a
24 | /// purchasing transaction will throw an exception.
25 | - (void)finishTransaction:(nonnull SKPaymentTransaction *)transaction;
   |                                    `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
26 | 
27 | /// Observers are not retained.  The transactions array will only be synchronized with the server

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:29:36: warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
27 | /// Observers are not retained.  The transactions array will only be synchronized with the server
28 | /// while the queue has observers.  This may require that the user authenticate.
29 | - (void)addTransactionObserver:(id<SKPaymentTransactionObserver>)observer;
   |                                    `- warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
30 | 
31 | /// Add a payment to the server queue.  The payment is copied to add an SKPaymentTransaction to the

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 89 | 
 90 | API_DEPRECATED("Use StoreKit 2 Transaction APIs", ios(3.0, 18.0), tvos(9.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 91 | @protocol SKPaymentTransactionObserver <NSObject>
    |           `- note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 92 | @required
 93 | // Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:34:21: warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
32 | /// transactions array.  The same payment can be added multiple times to create multiple
33 | /// transactions.
34 | - (void)addPayment:(SKPayment *_Nonnull)payment;
   |                     `- warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
35 | 
36 | /// Will add completed transactions for the current user back to the queue to be re-completed.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: note: 'SKPayment' has been explicitly marked deprecated here
17 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
   |            `- note: 'SKPayment' has been explicitly marked deprecated here
20 | @private
21 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  5 | #import <StoreKit/StoreKit.h>
  6 | #import "FIATransactionCache.h"
  7 | #import "FLTPaymentQueueProtocol.h"
    |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:
  8 | #import "FLTTransactionCacheProtocol.h"
  9 | 

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:61:32: warning: 'SKPaymentQueue' is deprecated: first deprecated in iOS 18.0 - No longer supported
59 | 
60 | /// Initialize this wrapper with an SKPaymentQueue
61 | - (instancetype)initWithQueue:(SKPaymentQueue *)queue NS_DESIGNATED_INITIALIZER;
   |                                `- warning: 'SKPaymentQueue' is deprecated: first deprecated in iOS 18.0 - No longer supported
62 | 
63 | /// The default initializer is unavailable, as it this must be initlai

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:25:12: note: 'SKPaymentQueue' has been explicitly marked deprecated here
 23 | API_DEPRECATED("No longer supported", ios(3.0, 18.0), tvos(9.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 24 | NS_SWIFT_SENDABLE
 25 | @interface SKPaymentQueue : NSObject {
    |            `- note: 'SKPaymentQueue' has been explicitly marked deprecated here
 26 | @private
 27 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:11:45: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
  9 | 
 10 | NS_ASSUME_NONNULL_BEGIN
 11 | typedef void (^TransactionsUpdated)(NSArray<SKPaymentTransaction *> *transactions);
    |                                             `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 12 | typedef void (^TransactionsRemoved)(NSArray<SKPaymentTransaction *> *transactions);
 13 | typedef void (^RestoreTransactionFailed)(NSError *error);

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:12:45: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 10 | NS_ASSUME_NONNULL_BEGIN
 11 | typedef void (^TransactionsUpdated)(NSArray<SKPaymentTransaction *> *transactions);
 12 | typedef void (^TransactionsRemoved)(NSArray<SKPaymentTransaction *> *transactions);
    |                                             `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 13 | typedef void (^RestoreTransactionFailed)(NSError *error);
 14 | typedef void (^RestoreCompletedTransactionsFinished)(void);

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:15:39: warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
 13 | typedef void (^RestoreTransactionFailed)(NSError *error);
 14 | typedef void (^RestoreCompletedTransactionsFinished)(void);
 15 | typedef BOOL (^ShouldAddStorePayment)(SKPayment *payment, SKProduct *product);
    |                                       `- warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
 16 | typedef void (^UpdatedDownloads)(NSArray<SKDownload *> *downloads);
 17 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: note: 'SKPayment' has been explicitly marked deprecated here
17 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
   |            `- note: 'SKPayment' has been explicitly marked deprecated here
20 | @private
21 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:15:59: warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
 13 | typedef void (^RestoreTransactionFailed)(NSError *error);
 14 | typedef void (^RestoreCompletedTransactionsFinished)(void);
 15 | typedef BOOL (^ShouldAddStorePayment)(SKPayment *payment, SKProduct *product);
    |                                                           `- warning: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product
 16 | typedef void (^UpdatedDownloads)(NSArray<SKDownload *> *downloads);
 17 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: note: 'SKProduct' has been explicitly marked deprecated here
39 | API_DEPRECATED("Use Product", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
40 | NS_SWIFT_SENDABLE
41 | @interface SKProduct : NSObject {
   |            `- note: 'SKProduct' has been explicitly marked deprecated here
42 | @private
43 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:16:42: warning: 'SKDownload' is deprecated: first deprecated in iOS 16.0 - Hosted content is no longer supported
 14 | typedef void (^RestoreCompletedTransactionsFinished)(void);
 15 | typedef BOOL (^ShouldAddStorePayment)(SKPayment *payment, SKProduct *product);
 16 | typedef void (^UpdatedDownloads)(NSArray<SKDownload *> *downloads);
    |                                          `- warning: 'SKDownload' is deprecated: first deprecated in iOS 16.0 - Hosted content is no longer supported
 17 | 
 18 | /// A protocol that conforms to SKPaymentTransactionObserver and handles SKPaymentQueue methods

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKDownload.h:26:181: note: 'SKDownload' has been explicitly marked deprecated here
24 | SK_EXTERN NSTimeInterval SKDownloadTimeRemainingUnknown API_DEPRECATED("Hosted content is no longer supported", ios(6.0, 16.0), macos(10.14, 13.0), tvos(9.0, 16.0), watchos(6.2, 9.0)) API_UNAVAILABLE(visionos);
25 | 
26 | SK_EXTERN_CLASS API_DEPRECATED("Hosted content is no longer supported", ios(6.0, 16.0), macos(10.8, 13.0), tvos(9.0, 16.0), watchos(6.2, 9.0)) API_UNAVAILABLE(visionos) @interface SKDownload : NSObject {
   |                                                                                                                                                                                     `- note: 'SKDownload' has been explicitly marked deprecated here
27 | @private
28 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:19:53: warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
 17 | 
 18 | /// A protocol that conforms to SKPaymentTransactionObserver and handles SKPaymentQueue methods
 19 | @protocol FLTPaymentQueueHandlerProtocol <NSObject, SKPaymentTransactionObserver>
    |                                                     `- warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
 20 | /// An object that provides information needed to complete transactions.
 21 | @property(nonatomic, weak, nullable) id<SKPaymentQueueDelegate> delegate API_AVAILABLE(

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 89 | 
 90 | API_DEPRECATED("Use StoreKit 2 Transaction APIs", ios(3.0, 18.0), tvos(9.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 91 | @protocol SKPaymentTransactionObserver <NSObject>
    |           `- note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 92 | @required
 93 | // Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:21:41: warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
 19 | @protocol FLTPaymentQueueHandlerProtocol <NSObject, SKPaymentTransactionObserver>
 20 | /// An object that provides information needed to complete transactions.
 21 | @property(nonatomic, weak, nullable) id<SKPaymentQueueDelegate> delegate API_AVAILABLE(
    |                                         `- warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
 22 |     ios(13.0), macos(10.15), watchos(6.2));
 23 | /// An object containing the location and unique identifier of an Apple App Store storefront.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 76 | 
 77 | API_DEPRECATED("No longer supported", ios(13.0, 18.0), tvos(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 78 | @protocol SKPaymentQueueDelegate <NSObject>
    |           `- note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 79 | @optional
 80 | // Sent when the storefront changes while a payment is processing.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:25:5: warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
 23 | /// An object containing the location and unique identifier of an Apple App Store storefront.
 24 | @property(nonatomic, readonly, nullable)
 25 |     SKStorefront *storefront API_AVAILABLE(ios(13.0), macos(10.15), watchos(6.2));
    |     `- warning: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront
 26 | 
 27 | /// Creates a new FIAPaymentQueueHandler.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: note: 'SKStorefront' has been explicitly marked deprecated here
14 | API_DEPRECATED("Use Storefront", ios(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
15 | NS_SWIFT_SENDABLE
16 | @interface SKStorefront : NSObject
   |            `- note: 'SKStorefront' has been explicitly marked deprecated here
17 | 
18 | /* The three letter country code for the current storefront */

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:74:36: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 72 | 
 73 | /// Can throw exceptions if the transaction type is purchasing, should always used in a @try block.
 74 | - (void)finishTransaction:(nonnull SKPaymentTransaction *)transaction;
    |                                    `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 75 | 
 76 | /// Attempt to restore transactions. Require app store receipt url.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:83:12: warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 81 | 
 82 | /// Return all transactions that are not marked as complete.
 83 | - (NSArray<SKPaymentTransaction *> *)getUnfinishedTransactions;
    |            `- warning: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)
 84 | 
 85 | /// This method needs to be called before any other methods.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: note: 'SKPaymentTransaction' has been explicitly marked deprecated here
25 | API_DEPRECATED("Use PurchaseResult from Product.purchase(confirmIn:options:)",ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
26 | NS_SWIFT_SENDABLE
27 | @interface SKPaymentTransaction : NSObject {
   |            `- note: 'SKPaymentTransaction' has been explicitly marked deprecated here
28 | @private
29 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FIATransactionCache.h"
 8 | #import "FLTPaymentQueueHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:
 9 | #import "FLTPaymentQueueProtocol.h"
10 | #import "FLTTransactionCacheProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:95:21: warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
 93 | /// @param payment Payment object to be added to the payment queue.
 94 | /// @return whether "addPayment" was successful.
 95 | - (BOOL)addPayment:(SKPayment *)payment;
    |                     `- warning: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)
 96 | 
 97 | /// Displays the price consent sheet.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: note: 'SKPayment' has been explicitly marked deprecated here
17 | API_DEPRECATED("Use Product.purchase(confirmIn:options:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKPayment : NSObject <NSCopying, NSMutableCopying> {
   |            `- note: 'SKPayment' has been explicitly marked deprecated here
20 | @private
21 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
12 | 
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:17:17: warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
15 | 
16 | @interface FIAPaymentQueueHandler
17 |     : NSObject <SKPaymentTransactionObserver, FLTPaymentQueueHandlerProtocol>
   |                 `- warning: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs
18 | @end
19 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 89 | 
 90 | API_DEPRECATED("Use StoreKit 2 Transaction APIs", ios(3.0, 18.0), tvos(9.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 91 | @protocol SKPaymentTransactionObserver <NSObject>
    |           `- note: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here
 92 | @required
 93 | // Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:15:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:15:
13 | #import "FIAObjectTranslator.h"
14 | #import "FIAPaymentQueueHandler.h"
15 | #import "FIAPPaymentQueueDelegate.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:15:
16 | #import "FIAPReceiptManager.h"
17 | #import "FIAPRequestHandler.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPPaymentQueueDelegate.h:19:49: warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
17 | API_AVAILABLE(ios(13), macos(10.15))
18 | API_UNAVAILABLE(tvos, watchos)
19 | @interface FIAPPaymentQueueDelegate : NSObject <SKPaymentQueueDelegate>
   |                                                 `- warning: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported
20 | - (id)initWithMethodChannel:(id<FLTMethodChannelProtocol>)methodChannel;
21 | @end

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 76 | 
 77 | API_DEPRECATED("No longer supported", ios(13.0, 18.0), tvos(13.0, 18.0), macos(10.15, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
 78 | @protocol SKPaymentQueueDelegate <NSObject>
    |           `- note: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here
 79 | @optional
 80 | // Sent when the storefront changes while a payment is processing.

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"
17 | #import "FIAPRequestHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:
18 | #import "FIATransactionCache.h"
19 | #import "FLTMethodChannelProtocol.h"

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:7:9: note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:7:
 5 | #import <Foundation/Foundation.h>
 6 | #import <StoreKit/StoreKit.h>
 7 | #import "FLTRequestHandlerProtocol.h"
   |         `- note: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:7:
 8 | 
 9 | NS_ASSUME_NONNULL_BEGIN

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTRequestHandlerProtocol.h:8:42: warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
 6 | 
 7 | NS_ASSUME_NONNULL_BEGIN
 8 | typedef void (^ProductRequestCompletion)(SKProductsResponse *_Nullable response,
   |                                          `- warning: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)
 9 |                                          NSError *_Nullable errror);
10 | /// A protocol that wraps SKRequest.

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: note: 'SKProductsResponse' has been explicitly marked deprecated here
42 | API_DEPRECATED("Get products using Product.products(for:)", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
43 | NS_SWIFT_SENDABLE
44 | @interface SKProductsResponse : NSObject {
   |            `- note: 'SKProductsResponse' has been explicitly marked deprecated here
45 | @private
46 |     id _internal;

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/in_app_purchase_storekit-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:
15 | #import "FIAPPaymentQueueDelegate.h"
16 | #import "FIAPReceiptManager.h"
17 | #import "FIAPRequestHandler.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:
18 | #import "FIATransactionCache.h"
19 | #import "FLTMethodChannelProtocol.h"

42 warnings generated.
/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:13:34: warning: 'SKRequest' is deprecated: first deprecated in iOS 18.0 - No longer supported
11 | @interface FIAPRequestHandler : NSObject <FLTRequestHandlerProtocol>
12 | 
13 | - (instancetype)initWithRequest:(SKRequest *)request;
   |                                  `- warning: 'SKRequest' is deprecated: first deprecated in iOS 18.0 - No longer supported
14 | - (void)startProductRequestWithCompletionHandler:(ProductRequestCompletion)completion;
15 | 

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKRequest.h:19:12: note: 'SKRequest' has been explicitly marked deprecated here
17 | API_DEPRECATED("No longer supported", ios(3.0, 18.0), macos(10.7, 15.0), watchos(6.2, 11.0), visionos(1.0, 2.0))
18 | NS_SWIFT_NONSENDABLE
19 | @interface SKRequest : NSObject {
   |            `- note: 'SKRequest' has been explicitly marked deprecated here
20 | @private
21 |     id _requestInternal;

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:14:40: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: 'SKProduct' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:17:58: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:27:12: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:21:48: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: 'SKProductDiscount' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:26:22: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: 'SKProductDiscount' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:29:49: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: 'SKProductsResponse' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:32:40: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: 'SKPayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:38:4: 'SKMutablePayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:52:12: 'SKMutablePayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:41:51: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:47:43: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: 'SKStorefront' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:51:43: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: 'SKStorefront' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:52:43: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:56:13: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentDiscount.h:16:12: 'SKPaymentDiscount' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:61:15: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:63:74: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: 'SKStorefront' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:67:15: 'SKPaymentDiscount' is deprecated: first deprecated in iOS 18.0 - Create a Product.PurchaseOption.promotionalOffer to use in Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentDiscount.h:16:12: 'SKPaymentDiscount' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:69:68: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: 'SKPayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:75:15: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: 'SKProductsResponse' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:77:68: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: 'SKProduct' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:81:15: 'SKProductDiscount' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionOffer

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductDiscount.h:33:12: 'SKProductDiscount' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:13:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAObjectTranslator.h:87:15: 'SKProductSubscriptionPeriod' is deprecated: first deprecated in iOS 18.0 - Use Product.SubscriptionPeriod

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:27:12: 'SKProductSubscriptionPeriod' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:13:30: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: 'SKStorefront' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:16:38: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:20:41: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:25:36: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:29:36: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:34:21: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: 'SKPayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueProtocol.h:61:32: 'SKPaymentQueue' is deprecated: first deprecated in iOS 18.0 - No longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:25:12: 'SKPaymentQueue' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:11:45: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:12:45: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:15:39: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: 'SKPayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:15:59: 'SKProduct' is deprecated: first deprecated in iOS 18.0 - Use Product

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProduct.h:41:12: 'SKProduct' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:16:42: 'SKDownload' is deprecated: first deprecated in iOS 16.0 - Hosted content is no longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKDownload.h:26:181: 'SKDownload' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:19:53: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:21:41: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:25:5: 'SKStorefront' is deprecated: first deprecated in iOS 18.0 - Use Storefront

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKStorefront.h:16:12: 'SKStorefront' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:74:36: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:83:12: 'SKPaymentTransaction' is deprecated: first deprecated in iOS 18.0 - Use PurchaseResult from Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentTransaction.h:27:12: 'SKPaymentTransaction' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:8:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTPaymentQueueHandlerProtocol.h:95:21: 'SKPayment' is deprecated: first deprecated in iOS 18.0 - Use Product.purchase(confirmIn:options:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPayment.h:19:12: 'SKPayment' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:14:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPaymentQueueHandler.h:17:17: 'SKPaymentTransactionObserver' is deprecated: first deprecated in iOS 18.0 - Use StoreKit 2 Transaction APIs

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:91:11: 'SKPaymentTransactionObserver' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:15:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:15:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPPaymentQueueDelegate.h:19:49: 'SKPaymentQueueDelegate' is deprecated: first deprecated in iOS 18.0 - No longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKPaymentQueue.h:78:11: 'SKPaymentQueueDelegate' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:7:9: in file included from /Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:7:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FLTRequestHandlerProtocol.h:8:42: 'SKProductsResponse' is deprecated: first deprecated in iOS 18.0 - Get products using Product.products(for:)

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKProductsRequest.h:44:12: 'SKProductsResponse' has been explicitly marked deprecated here

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/in_app_purchase_storekit/in_app_purchase_storekit-umbrella.h:17:

/Users/Erlan/.pub-cache/hosted/pub.dev/in_app_purchase_storekit-0.4.6+2/darwin/in_app_purchase_storekit/Sources/in_app_purchase_storekit_objc/include/in_app_purchase_storekit_objc/FIAPRequestHandler.h:13:34: 'SKRequest' is deprecated: first deprecated in iOS 18.0 - No longer supported

/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/StoreKit.framework/Headers/SKRequest.h:19:12: 'SKRequest' has been explicitly marked deprecated here

SwiftExplicitDependencyGeneratePcm arm64 /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/sentry_flutter-1PTG9WYMDKMMOSCK79IITQRIN.pcm

<module-includes>:1:9: note: in file included from <module-includes>:1:
1 | #import "Headers/sentry_flutter-umbrella.h"
  |         `- note: in file included from <module-includes>:1:
2 | 

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/sentry_flutter/sentry_flutter-umbrella.h:16:9: note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/sentry_flutter/sentry_flutter-umbrella.h:16:
14 | #import "SentryFlutterReplayBreadcrumbConverter.h"
15 | #import "SentryFlutterReplayScreenshotProvider.h"
16 | #import "SentryFlutterPlugin.h"
   |         `- note: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/sentry_flutter/sentry_flutter-umbrella.h:16:
17 | 
18 | FOUNDATION_EXPORT double sentry_flutterVersionNumber;

1 warning generated.
/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter_objc/SentryFlutterPlugin.h:10:64: warning: pointer is missing a nullability type specifier (_Nonnull, _Nullable, or _Null_unspecified)
 8 | + (nullable NSData *)fetchNativeAppStartAsBytes;
 9 | + (nullable NSData *)loadContextsAsBytes;
10 | + (nullable NSData *)loadDebugImagesAsBytes:(NSSet<NSString *> *)instructionAddresses;
   |                                                                |- warning: pointer is missing a nullability type specifier (_Nonnull, _Nullable, or _Null_unspecified)
   |                                                                |- note: insert '_Nullable' if the pointer may be null
   |                                                                `- note: insert '_Nonnull' if the pointer should never be null
11 | @end
12 | #endif

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/<module-includes>:1:9: in file included from <module-includes>:1:

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/sentry_flutter/sentry_flutter-umbrella.h:16:9: in file included from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/sentry_flutter/sentry_flutter-umbrella.h:16:

/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter_objc/SentryFlutterPlugin.h:10:64: pointer is missing a nullability type specifier (_Nonnull, _Nullable, or _Null_unspecified)


Build target Runner of project Runner with configuration Release
note: Run script build phase 'Run Script' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Runner' from project 'Runner')
note: Run script build phase 'Thin Binary' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Runner' from project 'Runner')
warning: Run script build phase 'Flutter Pub Get' will be run during every build because it does not specify any outputs. To address this issue, either add output dependencies to the script phase, or configure it to run in every build by unchecking "Based on dependency analysis" in the script phase. (in target 'Runner' from project 'Runner')


Run script build phase 'Run Script' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked.

Run script build phase 'Thin Binary' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked.

Run script build phase 'Flutter Pub Get' will be run during every build because it does not specify any outputs. To address this issue, either add output dependencies to the script phase, or configure it to run in every build by unchecking "Based on dependency analysis" in the script phase.


Build target webview_flutter_wkwebview of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ AuthenticationChallengeResponse.swift,\ AuthenticationChallengeResponseProxyAPIDelegate.swift,\ ErrorProxyAPIDelegate.swift,\ FlutterAssetManager.swift,\ FlutterViewFactory.swift,\ FrameInfoProxyAPIDelegate.swift,\ GetTrustResultResponse.swift,\ GetTrustResultResponseProxyAPIDelegate.swift,\ HTTPCookieProxyAPIDelegate.swift,\ HTTPCookieStoreProxyAPIDelegate.swift,\ HTTPURLResponseProxyAPIDelegate.swift,\ NavigationActionProxyAPIDelegate.swift,\ NavigationDelegateProxyAPIDelegate.swift,\ NavigationResponseProxyAPIDelegate.swift,\ NSObjectProxyAPIDelegate.swift,\ PreferencesProxyAPIDelegate.swift,\ ProxyAPIRegistrar.swift,\ ScriptMessageHandlerProxyAPIDelegate.swift,\ ScriptMessageProxyAPIDelegate.swift,\ ScrollViewDelegateProxyAPIDelegate.swift,\ ScrollViewProxyAPIDelegate.swift,\ SecCertificateProxyAPIDelegate.swift,\ SecTrustProxyAPIDelegate.swift,\ SecurityOriginProxyAPIDelegate.swift,\ SecWrappers.swift,\ StructWrappers.swift,\ UIDelegateProxyAPIDelegate.swift,\ UIViewProxyAPIDelegate.swift,\ URLAuthenticationChallengeProxyAPIDelegate.swift,\ URLCredentialProxyAPIDelegate.swift,\ URLProtectionSpaceProxyAPIDelegate.swift,\ URLProxyAPIDelegate.swift,\ URLRequestProxyAPIDelegate.swift,\ UserContentControllerProxyAPIDelegate.swift,\ UserScriptProxyAPIDelegate.swift,\ WebKitLibrary.g.swift,\ WebpagePreferencesProxyAPIDelegate.swift,\ WebsiteDataStoreProxyAPIDelegate.swift,\ WebViewConfigurationProxyAPIDelegate.swift,\ WebViewFlutterPlugin.swift,\ WebViewFlutterWKWebViewExternalAPI.swift,\ WebViewProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/AuthenticationChallengeResponse.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/AuthenticationChallengeResponseProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ErrorProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/FlutterAssetManager.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/FlutterViewFactory.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/FrameInfoProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/GetTrustResultResponse.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/GetTrustResultResponseProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/HTTPCookieProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/HTTPCookieStoreProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/HTTPURLResponseProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/NavigationActionProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/NavigationDelegateProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/NavigationResponseProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/NSObjectProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/PreferencesProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ProxyAPIRegistrar.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ScriptMessageHandlerProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ScriptMessageProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ScrollViewDelegateProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/ScrollViewProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecCertificateProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecTrustProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecurityOriginProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecWrappers.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/StructWrappers.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/UIDelegateProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/UIViewProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/URLAuthenticationChallengeProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/URLCredentialProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/URLProtectionSpaceProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/URLProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/URLRequestProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/UserContentControllerProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/UserScriptProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebKitLibrary.g.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebpagePreferencesProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebsiteDataStoreProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebViewConfigurationProxyAPIDelegate.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebViewFlutterPlugin.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebViewFlutterWKWebViewExternalAPI.swift /Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/WebViewProxyAPIDelegate.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/WebKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Network.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Distributed.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Network-9VNWWDZ5HA67SK7TGCYKQSWHZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/dnssd-62H4009Q10EGW9RZ7EPQ17LUH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/webview_flutter_wkwebview-5LTNHKXNSKIZVI3FXJ3XF8YS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/WebKit-26SVPKRT1PFWDUPEC2U5OKKWG.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/Flutter-1XZXZZQ0VVIICNDHB9CQ2DCRQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/webview_flutter_wkwebview.build/Objects-normal/arm64/webview_flutter_wkwebview-dependencies-19.json (in target 'webview_flutter_wkwebview' from project 'Pods')

CompileSwift normal arm64 (in target 'webview_flutter_wkwebview' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecTrustProxyAPIDelegate.swift:133:12: warning: 'SecTrustGetCertificateAtIndex' was deprecated in iOS 15.0: renamed to 'SecTrustCopyCertificateChain(_:)'
    return SecTrustGetCertificateAtIndex(trust, ix)
           ^
/Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecTrustProxyAPIDelegate.swift:133:12: note: use 'SecTrustCopyCertificateChain(_:)' instead
    return SecTrustGetCertificateAtIndex(trust, ix)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           SecTrustCopyCertificateChain

/Users/Erlan/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.23.3/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecTrustProxyAPIDelegate.swift:133:12: 'SecTrustGetCertificateAtIndex' was deprecated in iOS 15.0: renamed to 'SecTrustCopyCertificateChain(_:)'


Build target url_launcher_ios of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ Launcher.swift,\ messages.g.swift,\ URLLauncherPlugin.swift,\ URLLaunchSession.swift /Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/Launcher.swift /Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/messages.g.swift /Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/URLLauncherPlugin.swift /Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/URLLaunchSession.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SafariServices.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SafariServices-8M406PWPCHA60R1JKA4AGKD03.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/url_launcher_ios-B7FB6D57Y6MSDX704XTCINWFQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/Flutter-1XZXZZQ0VVIICNDHB9CQ2DCRQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/url_launcher_ios.build/Objects-normal/arm64/url_launcher_ios-dependencies-19.json (in target 'url_launcher_ios' from project 'Pods')

CompileSwift normal arm64 (in target 'url_launcher_ios' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/URLLauncherPlugin.swift:22:26: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
    UIApplication.shared.keyWindow?.rootViewController?.topViewController
                         ^

/Users/Erlan/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.6/ios/url_launcher_ios/Sources/url_launcher_ios/URLLauncherPlugin.swift:22:26: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes


Build target sentry_flutter of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ SentryFlutter.swift,\ SentryFlutterPlugin.swift /Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutter.swift /Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Products/Release-iphoneos/Sentry/Sentry.framework/Modules/Sentry.swiftmodule/arm64-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Synchronization.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMIDI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Distributed.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AudioToolbox.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Network.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/MetricKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/PDFKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/WebKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMIDI-77HOUU5KPHXLY0GDH3P5R5IJR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/WebKit-26SVPKRT1PFWDUPEC2U5OKKWG.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/sentry_flutter-1PTG9WYMDKMMOSCK79IITQRIN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVRouting-4XEM0UTK93GVCBNBY2KWSZ1WI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFAudio-AL0AXA4M3WOQHLUX3PQSS12YD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Network-9VNWWDZ5HA67SK7TGCYKQSWHZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AudioToolbox-6STKQWXS7L0THVI0AOR6YNN8F.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFoundation-1OGC7KECSN8FI4O3TP1RYEQF4.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/Sentry-1B3NQOCCSN7X0H3R8BCFJN72J.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/dnssd-62H4009Q10EGW9RZ7EPQ17LUH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MediaToolbox-3CJ6XWFEJVI89M1KN938Q93SM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MetricKit-D2HIWPXL9H0VZ03VESD4U5P4U.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/PDFKit-7XTKUB7BRYK7XZU3F7006MHO7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/Flutter-1XZXZZQ0VVIICNDHB9CQ2DCRQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/sentry_flutter.build/Objects-normal/arm64/sentry_flutter-dependencies-19.json (in target 'sentry_flutter' from project 'Pods')

CompileSwift normal arm64 (in target 'sentry_flutter' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift:292:56: warning: 'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead
          guard let windowScene = UIApplication.shared.windows.first?.windowScene else {
                                                       ^
/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift:447:64: warning: 'integrations' is deprecated: Setting `SentryOptions.integrations` is deprecated. Integrations should be enabled or disabled using their respective `SentryOptions.enable*` property.
            if let integrations = PrivateSentrySDKOnly.options.integrations {
                                                               ^

/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift:292:56: 'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead

/Users/Erlan/.pub-cache/hosted/pub.dev/sentry_flutter-9.8.0/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift:447:64: 'integrations' is deprecated: Setting `SentryOptions.integrations` is deprecated. Integrations should be enabled or disabled using their respective `SentryOptions.enable*` property.


Build target objective_c of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-58fe42ab844d6dbe79c9c814e450b5e7.o /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.c normal arm64 c com.apple.compilers.llvm.clang.1_0.compiler (in target 'objective_c' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/7187679823f38a2a940e0043cdf9d637-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Werror\=deprecated-objc-isa-usage -Werror\=objc-root-class -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-implicit-fallthrough -fstrict-aliasing -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/7187679823f38a2a940e0043cdf9d637-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/objective_c/objective_c-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-58fe42ab844d6dbe79c9c814e450b5e7.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-58fe42ab844d6dbe79c9c814e450b5e7.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.c -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-58fe42ab844d6dbe79c9c814e450b5e7.o

In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.c:7:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/objective_c.c:5:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/objective_c.h:9:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api_dl.h:10:
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:1794:11: warning: parameter 'port_id' not found in the function declaration [-Wdocumentation]
 1794 |  * \param port_id The port to be checked.
      |           ^~~~~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:1794:11: note: did you mean 'port'?
 1794 |  * \param port_id The port to be checked.
      |           ^~~~~~~
      |           port
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3354:11: warning: parameter 'path' not found in the function declaration [-Wdocumentation]
 3354 |  * \param path The asset id requested in the `@Native` external function.
      |           ^~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3354:11: note: did you mean 'asset_id'?
 3354 |  * \param path The asset id requested in the `@Native` external function.
      |           ^~~~
      |           asset_id
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3372:50: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
 3372 | typedef char* (*Dart_NativeAssetsAvailableAssets)();
      |                                                  ^
      |                                                   void
3 warnings generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:1794:11: Parameter 'port_id' not found in the function declaration

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:3354:11: Parameter 'path' not found in the function declaration

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:3372:50: A function declaration without a prototype is deprecated in all versions of C

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-e7b31f2812a8764af04962f5b82bac5c.o /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'objective_c' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/objective_c/objective_c-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-e7b31f2812a8764af04962f5b82bac5c.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-e7b31f2812a8764af04962f5b82bac5c.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/objective_c.build/Objects-normal/arm64/objective_c-e7b31f2812a8764af04962f5b82bac5c.o

In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.m:7:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/input_stream_adapter.m:5:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/input_stream_adapter.h:5:
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api_dl.h:10:
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:1794:11: warning: parameter 'port_id' not found in the function declaration [-Wdocumentation]
 1794 |  * \param port_id The port to be checked.
      |           ^~~~~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:1794:11: note: did you mean 'port'?
 1794 |  * \param port_id The port to be checked.
      |           ^~~~~~~
      |           port
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3354:11: warning: parameter 'path' not found in the function declaration [-Wdocumentation]
 3354 |  * \param path The asset id requested in the `@Native` external function.
      |           ^~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3354:11: note: did you mean 'asset_id'?
 3354 |  * \param path The asset id requested in the `@Native` external function.
      |           ^~~~
      |           asset_id
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/include/dart_api.h:3372:50: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
 3372 | typedef char* (*Dart_NativeAssetsAvailableAssets)();
      |                                                  ^
      |                                                   void
In file included from /Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/objective_c.m:8:
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/objective_c.m:80:34: warning: implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int' [-Wshorten-64-to-32]
   80 |   c_version.major = objc_version.majorVersion;
      |                   ~ ~~~~~~~~~~~~~^~~~~~~~~~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/objective_c.m:81:34: warning: implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int' [-Wshorten-64-to-32]
   81 |   c_version.minor = objc_version.minorVersion;
      |                   ~ ~~~~~~~~~~~~~^~~~~~~~~~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/ios/Classes/../../src/objective_c.m:82:34: warning: implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int' [-Wshorten-64-to-32]
   82 |   c_version.patch = objc_version.patchVersion;
      |                   ~ ~~~~~~~~~~~~~^~~~~~~~~~~~
6 warnings generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:1794:11: Parameter 'port_id' not found in the function declaration

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:3354:11: Parameter 'path' not found in the function declaration

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/include/dart_api.h:3372:50: A function declaration without a prototype is deprecated in all versions of C

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/objective_c.m:80:34: Implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int'

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/objective_c.m:81:34: Implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int'

/Users/Erlan/.pub-cache/hosted/pub.dev/objective_c-8.0.0/src/objective_c.m:82:34: Implicit conversion loses integer precision: 'NSInteger' (aka 'long') to 'int'


Build target flutter_local_notifications of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/FlutterLocalNotificationsPlugin.o /Users/Erlan/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.5.0/ios/flutter_local_notifications/Sources/flutter_local_notifications/FlutterLocalNotificationsPlugin.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'flutter_local_notifications' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/flutter_local_notifications/flutter_local_notifications-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/FlutterLocalNotificationsPlugin.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/FlutterLocalNotificationsPlugin.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.5.0/ios/flutter_local_notifications/Sources/flutter_local_notifications/FlutterLocalNotificationsPlugin.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/flutter_local_notifications.build/Objects-normal/arm64/FlutterLocalNotificationsPlugin.o

/Users/Erlan/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.5.0/ios/flutter_local_notifications/Sources/flutter_local_notifications/FlutterLocalNotificationsPlugin.m:972:30: warning: 'UNNotificationPresentationOptionAlert' is deprecated: first deprecated in iOS 14.0 [-Wdeprecated-declarations]
  972 |       presentationOptions |= UNNotificationPresentationOptionAlert;
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                              UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner
In module 'UserNotifications' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.5.0/ios/flutter_local_notifications/Sources/flutter_local_notifications/./include/flutter_local_notifications/FlutterLocalNotificationsPlugin.h:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UserNotifications.framework/Headers/UNUserNotificationCenter.h:84:5: note: 'UNNotificationPresentationOptionAlert' has been explicitly marked deprecated here
   84 |     UNNotificationPresentationOptionAlert API_DEPRECATED_WITH_REPLACEMENT("UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner", macos(10.14, 11.0), ios(10.0, 14.0), watchos(3.0, 7.0), tvos(10.0, 14.0)) = (1 << 2),
      |     ^
1 warning generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.5.0/ios/flutter_local_notifications/Sources/flutter_local_notifications/FlutterLocalNotificationsPlugin.m:972:30: 'UNNotificationPresentationOptionAlert' is deprecated: first deprecated in iOS 14.0


Build target firebase_messaging of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/FLTFirebaseMessagingPlugin.o /Users/Erlan/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.4/ios/firebase_messaging/Sources/firebase_messaging/FLTFirebaseMessagingPlugin.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'firebase_messaging' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/firebase_messaging/firebase_messaging-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/FLTFirebaseMessagingPlugin.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/FLTFirebaseMessagingPlugin.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.4/ios/firebase_messaging/Sources/firebase_messaging/FLTFirebaseMessagingPlugin.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_messaging.build/Objects-normal/arm64/FLTFirebaseMessagingPlugin.o

/Users/Erlan/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.4/ios/firebase_messaging/Sources/firebase_messaging/FLTFirebaseMessagingPlugin.m:348:32: warning: 'UNNotificationPresentationOptionAlert' is deprecated: first deprecated in iOS 14.0 [-Wdeprecated-declarations]
  348 |         presentationOptions |= UNNotificationPresentationOptionAlert;
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner
In module 'UserNotifications' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.4/ios/firebase_messaging/Sources/firebase_messaging/include/FLTFirebaseMessagingPlugin.h:15:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UserNotifications.framework/Headers/UNUserNotificationCenter.h:84:5: note: 'UNNotificationPresentationOptionAlert' has been explicitly marked deprecated here
   84 |     UNNotificationPresentationOptionAlert API_DEPRECATED_WITH_REPLACEMENT("UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner", macos(10.14, 11.0), ios(10.0, 14.0), watchos(3.0, 7.0), tvos(10.0, 14.0)) = (1 << 2),
      |     ^
1 warning generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.4/ios/firebase_messaging/Sources/firebase_messaging/FLTFirebaseMessagingPlugin.m:348:32: 'UNNotificationPresentationOptionAlert' is deprecated: first deprecated in iOS 14.0


Build target firebase_core of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/FLTFirebaseCorePlugin.o /Users/Erlan/.pub-cache/hosted/pub.dev/firebase_core-4.2.1/ios/firebase_core/Sources/firebase_core/FLTFirebaseCorePlugin.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'firebase_core' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/firebase_core/firebase_core-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/FLTFirebaseCorePlugin.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/FLTFirebaseCorePlugin.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/firebase_core-4.2.1/ios/firebase_core/Sources/firebase_core/FLTFirebaseCorePlugin.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/firebase_core.build/Objects-normal/arm64/FLTFirebaseCorePlugin.o

/Users/Erlan/.pub-cache/hosted/pub.dev/firebase_core-4.2.1/ios/firebase_core/Sources/firebase_core/FLTFirebaseCorePlugin.m:92:35: warning: incompatible pointer types assigning to 'NSString * _Nullable' from 'NSNull * _Nonnull' [-Wincompatible-pointer-types]
   92 |   pigeonOptions.deepLinkURLScheme = [NSNull null];
      |                                   ^ ~~~~~~~~~~~~~
1 warning generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/firebase_core-4.2.1/ios/firebase_core/Sources/firebase_core/FLTFirebaseCorePlugin.m:92:35: Incompatible pointer types assigning to 'NSString * _Nullable' from 'NSNull * _Nonnull'


Build target file_picker of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FileUtils.o /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'file_picker' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/file_picker/file_picker-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FileUtils.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FileUtils.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FileUtils.o

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:52:31: warning: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead. [-Wdeprecated-declarations]
   52 |             CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[format pathExtension], NULL);
      |                               ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FileUtils.h:7:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:317:1: note: 'UTTypeCreatePreferredIdentifierForTag' has been explicitly marked deprecated here
  317 | UTTypeCreatePreferredIdentifierForTag(
      | ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:52:69: warning: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead. [-Wdeprecated-declarations]
   52 |             CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[format pathExtension], NULL);
      |                                                                     ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FileUtils.h:7:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:258:26: note: 'kUTTagClassFilenameExtension' has been explicitly marked deprecated here
  258 | extern const CFStringRef kUTTagClassFilenameExtension                API_DEPRECATED("Use UTTagClassFilenameExtension instead.", ios(3.0, 15.0), macos(10.3, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:133:30: warning: unused variable 'exportError' [-Wunused-variable]
  133 |                     NSError *exportError = exporter.error;
      |                              ^~~~~~~~~~~
3 warnings generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:52:31: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:52:69: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FileUtils.m:133:30: Unused variable 'exportError'

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FilePickerPlugin.o /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'file_picker' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/file_picker/file_picker-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FilePickerPlugin.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FilePickerPlugin.dia -c /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/file_picker.build/Objects-normal/arm64/FilePickerPlugin.o

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:58:68: warning: 'windows' is deprecated: first deprecated in iOS 15.0 - Use UIWindowScene.windows on a relevant window scene instead [-Wdeprecated-declarations]
   58 |         for (UIWindow *window in [UIApplication sharedApplication].windows) {
      |                                                                    ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:109:62: note: 'windows' has been explicitly marked deprecated here
  109 | @property(nonatomic,readonly) NSArray<__kindof UIWindow *>  *windows API_DEPRECATED("Use UIWindowScene.windows on a relevant window scene instead", ios(2.0, 15.0), visionos(1.0, 1.0)) API_UNAVAILABLE(watchos);
      |                                                              ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:200:112: warning: 'UIDocumentPickerModeExportToService' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  200 |     self.documentPickerController = [[UIDocumentPickerViewController alloc] initWithURL:destinationPath inMode:UIDocumentPickerModeExportToService];
      |                                                                                                                ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:200:77: warning: 'initWithURL:inMode:' is deprecated: first deprecated in iOS 14.0 [-Wdeprecated-declarations]
  200 |     self.documentPickerController = [[UIDocumentPickerViewController alloc] initWithURL:destinationPath inMode:UIDocumentPickerModeExportToService];
      |                                                                             ^~~~~~~~~~~
      |                                                                             use initForExportingURLs:asCopy: or initForExportingURLs: instead
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:53:1: note: 'initWithURL:inMode:' has been explicitly marked deprecated here
   53 | - (instancetype)initWithURL:(NSURL *)url inMode:(UIDocumentPickerMode)mode NS_DESIGNATED_INITIALIZER API_DEPRECATED_WITH_REPLACEMENT("use initForExportingURLs:asCopy: or initForExportingURLs: instead", ios(8.0, 14.0), visionos(1.0, 1.0)) API_UNAVAILABLE(tvos, watchos);
      | ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:218:64: warning: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  218 |                                          inMode: isDirectory ? UIDocumentPickerModeOpen : UIDocumentPickerModeImport];
      |                                                                ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:218:91: warning: 'UIDocumentPickerModeImport' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  218 |                                          inMode: isDirectory ? UIDocumentPickerModeOpen : UIDocumentPickerModeImport];
      |                                                                                           ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:217:42: warning: 'initWithDocumentTypes:inMode:' is deprecated: first deprecated in iOS 14.0 [-Wdeprecated-declarations]
  217 |                                          initWithDocumentTypes: isDirectory ? @[@"public.folder"] : self.allowedExtensions
      |                                          ^~~~~~~~~~~~~~~~~~~~~
      |                                          use initForOpeningContentTypes:asCopy: or initForOpeningContentTypes: instead
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:41:1: note: 'initWithDocumentTypes:inMode:' has been explicitly marked deprecated here
   41 | - (instancetype)initWithDocumentTypes:(NSArray <NSString *>*)allowedUTIs inMode:(UIDocumentPickerMode)mode NS_DESIGNATED_INITIALIZER API_DEPRECATED_WITH_REPLACEMENT("use initForOpeningContentTypes:asCopy: or initForOpeningContentTypes: instead", ios(8.0, 14.0), visionos(1.0, 1.0)) API_UNAVAILABLE(tvos, watchos);
      | ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:52: warning: 'kUTTypeMovie' is deprecated: first deprecated in iOS 15.0 - Use UTTypeMovie or UTType.movie (swift) instead. [-Wdeprecated-declarations]
  261 |     NSArray<NSString*> * videoTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
      |                                                    ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FilePickerPlugin.h:5:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:880:26: note: 'kUTTypeMovie' has been explicitly marked deprecated here
  880 | extern const CFStringRef kUTTypeMovie                                API_DEPRECATED("Use UTTypeMovie or UTType.movie (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:77: warning: 'kUTTypeAVIMovie' is deprecated: first deprecated in iOS 15.0 - Use UTTypeAVI or UTType.avi (swift) instead. [-Wdeprecated-declarations]
  261 |     NSArray<NSString*> * videoTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
      |                                                                             ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FilePickerPlugin.h:5:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:892:26: note: 'kUTTypeAVIMovie' has been explicitly marked deprecated here
  892 | extern const CFStringRef kUTTypeAVIMovie                             API_DEPRECATED("Use UTTypeAVI or UTType.avi (swift) instead.", ios(8.0, 15.0), macos(10.10, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:105: warning: 'kUTTypeVideo' is deprecated: first deprecated in iOS 15.0 - Use UTTypeVideo or UTType.video (swift) instead. [-Wdeprecated-declarations]
  261 |     NSArray<NSString*> * videoTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
      |                                                                                                         ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FilePickerPlugin.h:5:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:881:26: note: 'kUTTypeVideo' has been explicitly marked deprecated here
  881 | extern const CFStringRef kUTTypeVideo                                API_DEPRECATED("Use UTTypeVideo or UTType.video (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:130: warning: 'kUTTypeMPEG4' is deprecated: first deprecated in iOS 15.0 - Use UTTypeMPEG4Movie or UTType.mpeg4 (swift) instead. [-Wdeprecated-declarations]
  261 |     NSArray<NSString*> * videoTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
      |                                                                                                                                  ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FilePickerPlugin.h:5:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:888:26: note: 'kUTTypeMPEG4' has been explicitly marked deprecated here
  888 | extern const CFStringRef kUTTypeMPEG4                                API_DEPRECATED("Use UTTypeMPEG4Movie or UTType.mpeg4 (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:262:53: warning: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead. [-Wdeprecated-declarations]
  262 |     NSArray<NSString*> * imageTypes = @[(NSString *)kUTTypeImage];
      |                                                     ^
In module 'MobileCoreServices' imported from /Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/include/file_picker/FilePickerPlugin.h:5:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:725:26: note: 'kUTTypeImage' has been explicitly marked deprecated here
  725 | extern const CFStringRef kUTTypeImage                                API_DEPRECATED("Use UTTypeImage or UTType.image (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:294:106: warning: 'UIActivityIndicatorViewStyleWhite' is deprecated: first deprecated in iOS 13.0 [-Wdeprecated-declarations]
  294 |     UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
      |                                                                                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                                                                          UIActivityIndicatorViewStyleMedium
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIActivityIndicatorView.h:19:5: note: 'UIActivityIndicatorViewStyleWhite' has been explicitly marked deprecated here
   19 |     UIActivityIndicatorViewStyleWhite API_DEPRECATED_WITH_REPLACEMENT("UIActivityIndicatorViewStyleMedium", ios(2.0, 13.0), tvos(9.0, 13.0)) API_UNAVAILABLE(visionos, watchos) = 1,
      |     ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:409:19: warning: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  409 |     if(controller.documentPickerMode == UIDocumentPickerModeOpen) {
      |                   ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:66:62: note: 'documentPickerMode' has been explicitly marked deprecated here
   66 | @property (nonatomic, assign, readonly) UIDocumentPickerMode documentPickerMode API_DEPRECATED("Use appropriate initializers instead", ios(8.0, 14.0), visionos(1.0, 1.0)) API_UNAVAILABLE(watchos);
      |                                                              ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:409:41: warning: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  409 |     if(controller.documentPickerMode == UIDocumentPickerModeOpen) {
      |                                         ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:410:17: warning: incompatible pointer types assigning to 'NSMutableArray<NSURL *> *' from 'NSArray<NSURL *> *' [-Wincompatible-pointer-types]
  410 |         newUrls = urls;
      |                 ^ ~~~~
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:412:19: warning: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  412 |     if(controller.documentPickerMode == UIDocumentPickerModeImport) {
      |                   ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:66:62: note: 'documentPickerMode' has been explicitly marked deprecated here
   66 | @property (nonatomic, assign, readonly) UIDocumentPickerMode documentPickerMode API_DEPRECATED("Use appropriate initializers instead", ios(8.0, 14.0), visionos(1.0, 1.0)) API_UNAVAILABLE(watchos);
      |                                                              ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:412:41: warning: 'UIDocumentPickerModeImport' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  412 |     if(controller.documentPickerMode == UIDocumentPickerModeImport) {
      |                                         ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:439:19: warning: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  439 |     if(controller.documentPickerMode == UIDocumentPickerModeOpen) {
      |                   ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:66:62: note: 'documentPickerMode' has been explicitly marked deprecated here
   66 | @property (nonatomic, assign, readonly) UIDocumentPickerMode documentPickerMode API_DEPRECATED("Use appropriate initializers instead", ios(8.0, 14.0), visionos(1.0, 1.0)) API_UNAVAILABLE(watchos);
      |                                                              ^
/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:439:41: warning: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead [-Wdeprecated-declarations]
  439 |     if(controller.documentPickerMode == UIDocumentPickerModeOpen) {
      |                                         ^
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target Support Files/file_picker/file_picker-prefix.pch:2:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIDocumentPickerViewController.h:30:29: note: 'UIDocumentPickerMode' has been explicitly marked deprecated here
   30 | typedef NS_ENUM(NSUInteger, UIDocumentPickerMode) {
      |                             ^
19 warnings generated.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:58:68: 'windows' is deprecated: first deprecated in iOS 15.0 - Use UIWindowScene.windows on a relevant window scene instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:200:112: 'UIDocumentPickerModeExportToService' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:200:77: 'initWithURL:inMode:' is deprecated: first deprecated in iOS 14.0

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:218:64: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:218:91: 'UIDocumentPickerModeImport' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:217:42: 'initWithDocumentTypes:inMode:' is deprecated: first deprecated in iOS 14.0

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:52: 'kUTTypeMovie' is deprecated: first deprecated in iOS 15.0 - Use UTTypeMovie or UTType.movie (swift) instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:77: 'kUTTypeAVIMovie' is deprecated: first deprecated in iOS 15.0 - Use UTTypeAVI or UTType.avi (swift) instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:105: 'kUTTypeVideo' is deprecated: first deprecated in iOS 15.0 - Use UTTypeVideo or UTType.video (swift) instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:261:130: 'kUTTypeMPEG4' is deprecated: first deprecated in iOS 15.0 - Use UTTypeMPEG4Movie or UTType.mpeg4 (swift) instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:262:53: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead.

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:294:106: 'UIActivityIndicatorViewStyleWhite' is deprecated: first deprecated in iOS 13.0

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:409:19: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:409:41: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:410:17: Incompatible pointer types assigning to 'NSMutableArray<NSURL *> *' from 'NSArray<NSURL *> *'

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:412:19: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:412:41: 'UIDocumentPickerModeImport' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:439:19: 'documentPickerMode' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead

/Users/Erlan/.pub-cache/hosted/pub.dev/file_picker-10.3.6/ios/file_picker/Sources/file_picker/FilePickerPlugin.m:439:41: 'UIDocumentPickerModeOpen' is deprecated: first deprecated in iOS 14.0 - Use appropriate initializers instead


Build target Sentry of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ Data+SentryTracing.swift,\ DecodeArbitraryData.swift,\ Dependencies.swift,\ Exports.swift,\ FileManager+SentryTracing.swift,\ HTTPHeaderSanitizer.swift,\ LoadValidator.swift,\ Locks.swift,\ NSNumberDecodableWrapper.swift,\ NumberExtensions.swift,\ SentryANRTracker.swift,\ SentryANRTrackerV2Delegate.swift,\ SentryANRType.swift,\ SentryApplication.swift,\ SentryApplicationExtensions.swift,\ SentryAppState.swift,\ SentryBaggageSerialization.swift,\ SentryBinaryImageCache.swift,\ SentryBreadcrumbCodable.swift,\ SentryClientReport.swift,\ SentryCodable.swift,\ SentryCrashWrapper.swift,\ SentryCurrentDateProvider.swift,\ SentryDebugMetaCodable.swift,\ SentryDefaultMaskRenderer.swift,\ SentryDefaultObjCRuntimeWrapper.swift,\ SentryDefaultViewRenderer.swift,\ SentryDiscardedEvent.swift,\ SentryDispatchQueueWrapper.swift,\ SentryDispatchSourceWrapper.swift,\ SentryEnabledFeaturesBuilder.swift,\ SentryEnvelope.swift,\ SentryEnvelopeHeader.swift,\ SentryEnvelopeItem.swift,\ SentryEnvelopeItemType.swift,\ SentryEventCodable.swift,\ SentryEventDecoder.swift,\ SentryExceptionCodable.swift,\ SentryExperimentalOptions.swift,\ SentryExtraPackages.swift,\ SentryFeedback.swift,\ SentryFileContents.swift,\ SentryFileIOTracker+SwiftHelpers.swift,\ SentryFileManagerProtocol.swift,\ SentryFrameCodable.swift,\ SentryFrameRemover.swift,\ SentryFramesDelayResult.swift,\ SentryGeoCodable.swift,\ SentryGlobalEventProcessor.swift,\ SentryGraphicsImageRenderer.swift,\ SentryIconography.swift,\ SentryId.swift,\ SentryInAppLogic.swift,\ SentryLevel.swift,\ SentryLog.swift,\ SentryLogAttribute.swift,\ SentryLogBatcher.swift,\ SentryLogger.swift,\ SentryLogLevel.swift,\ SentryLogMessage.swift,\ SentryMaskingPreviewView.swift,\ SentryMaskRenderer.swift,\ SentryMaskRendererV2.swift,\ SentryMeasurementValue.swift,\ SentryMechanismCodable.swift,\ SentryMechanismMetaCodable.swift,\ SentryMessage.swift,\ SentryMigrateSessionInit.swift,\ SentryMobileProvisionParser.swift,\ SentryMXCallStackTree.swift,\ SentryMXManager.swift,\ SentryNSErrorCodable.swift,\ SentryNSNotificationCenterWrapper.swift,\ SentryNSTimerFactory.swift,\ SentryObjCRuntimeWrapper.swift,\ SentryOnDemandReplay.swift,\ SentryOnDemandReplayError.swift,\ SentryPixelBuffer.swift,\ SentryProcessInfo.swift,\ SentryProfileOptions.swift,\ SentryRandom.swift,\ SentryRedactOptions.swift,\ SentryRedactRegion.swift,\ SentryRedactRegionType.swift,\ SentryRedactViewHelper.swift,\ SentryRenderVideoResult.swift,\ SentryReplayEvent.swift,\ SentryReplayFrame.swift,\ SentryReplayOptions.swift,\ SentryReplayRecording.swift,\ SentryReplayType.swift,\ SentryReplayVideoMaker.swift,\ SentryRequestCodable.swift,\ SentryRRWebBreadcrumbEvent.swift,\ SentryRRWebCustomEvent.swift,\ SentryRRWebEvent.swift,\ SentryRRWebMetaEvent.swift,\ SentryRRWebOptionsEvent.swift,\ SentryRRWebSpanEvent.swift,\ SentryRRWebTouchEvent.swift,\ SentryRRWebVideoEvent.swift,\ SentryScopePersistentStore.swift,\ SentryScopePersistentStore+Context.swift,\ SentryScopePersistentStore+Extras.swift,\ SentryScopePersistentStore+Fingerprint.swift,\ SentryScopePersistentStore+Helper.swift,\ SentryScopePersistentStore+String.swift,\ SentryScopePersistentStore+Tags.swift,\ SentryScopePersistentStore+User.swift,\ SentryScreenshotOptions.swift,\ SentryScreenshotSource.swift,\ SentrySDK.swift,\ SentrySdkInfo.swift,\ SentrySDKLog.swift,\ SentrySDKLog+Configure.swift,\ SentrySdkPackage.swift,\ SentrySDKSettings.swift,\ SentrySerializationSwift.swift,\ SentrySession.swift,\ SentrySessionReplay.swift,\ SentrySessionReplayDelegate.swift,\ SentrySRDefaultBreadcrumbConverter.swift,\ SentryStacktraceCodable.swift,\ SentrySysctl.swift,\ SentryThreadCodable.swift,\ SentryThreadWrapper.swift,\ SentryTouchTracker.swift,\ SentryTransactionNameSource.swift,\ SentryUIDeviceWrapper.swift,\ SentryUIRedactBuilder.swift,\ SentryURLRequestFactory.swift,\ SentryUserCodable.swift,\ SentryUserFeedback.swift,\ SentryUserFeedbackConfiguration.swift,\ SentryUserFeedbackFormConfiguration.swift,\ SentryUserFeedbackFormController.swift,\ SentryUserFeedbackFormViewModel.swift,\ SentryUserFeedbackIntegrationDriver.swift,\ SentryUserFeedbackThemeConfiguration.swift,\ SentryUserFeedbackWidget.swift,\ SentryUserFeedbackWidgetButtonMegaphoneIconView.swift,\ SentryUserFeedbackWidgetButtonView.swift,\ SentryUserFeedbackWidgetConfiguration.swift,\ SentryVideoFrameProcessor.swift,\ SentryVideoInfo.swift,\ SentryViewControllerBreadcrumbTracking.swift,\ SentryViewHierarchyProvider.swift,\ SentryViewPhotographer.swift,\ SentryViewRenderer.swift,\ SentryViewRendererV2.swift,\ SentryViewScreenshotProvider.swift,\ SentryWatchdogTerminationAttributesProcessor.swift,\ StringExtensions.swift,\ SwiftDescriptor.swift,\ SwizzleClassNameExclude.swift,\ ThreadSafeApplication.swift,\ UIImageHelper.swift,\ UIViewExtensions.swift,\ UrlSanitized.swift,\ URLSessionTaskHelper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/Data+SentryTracing.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/DecodeArbitraryData.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/Dependencies.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Exports.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/FileManager+SentryTracing.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/HTTPHeaderSanitizer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/LoadValidator.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Extensions/Locks.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/NSNumberDecodableWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Extensions/NumberExtensions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/ANR/SentryANRTracker.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/ANR/SentryANRTrackerV2Delegate.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/ANR/SentryANRType.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryApplication.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryApplicationExtensions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryAppState.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryBaggageSerialization.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryBinaryImageCache.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryBreadcrumbCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryClientReport.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryCrash/SentryCrashWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryCurrentDateProvider.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryDebugMetaCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryDefaultMaskRenderer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDefaultObjCRuntimeWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryDefaultViewRenderer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryDiscardedEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchQueueWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchSourceWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryEnabledFeaturesBuilder.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelope.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeHeader.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeItem.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryEnvelopeItemType.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryEventCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryEventDecoder.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryExceptionCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryExperimentalOptions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryExtraPackages.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryFeedback.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryFileContents.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/SentryFileIOTracker+SwiftHelpers.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentryFileManagerProtocol.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryFrameCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryCrash/SentryFrameRemover.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/FramesTracking/SentryFramesDelayResult.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryGeoCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SentryGlobalEventProcessor.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryGraphicsImageRenderer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryIconography.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Protocol/SentryId.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryInAppLogic.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/Log/SentryLevel.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentryLog.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentryLogAttribute.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogBatcher.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogger.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentryLogLevel.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentryLogMessage.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/Preview/SentryMaskingPreviewView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryMaskRenderer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryMaskRendererV2.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Transaction/SentryMeasurementValue.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismMetaCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMessage.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryMigrateSessionInit.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryMobileProvisionParser.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/MetricKit/SentryMXCallStackTree.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/MetricKit/SentryMXManager.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryNSErrorCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryNSNotificationCenterWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryNSTimerFactory.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryObjCRuntimeWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryOnDemandReplay.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryOnDemandReplayError.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryPixelBuffer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryProcessInfo.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/Performance/SentryProfileOptions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryRandom.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Protocol/SentryRedactOptions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryRedactRegion.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryRedactRegionType.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryRedactViewHelper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryRenderVideoResult.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayFrame.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayOptions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayRecording.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayType.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayVideoMaker.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryRequestCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebBreadcrumbEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebCustomEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebMetaEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebOptionsEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebSpanEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebTouchEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebVideoEvent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Context.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Extras.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Fingerprint.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Helper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+String.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Tags.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+User.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Screenshot/SentryScreenshotOptions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryScreenshotSource.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySDK.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkInfo.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/SentrySDKLog.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentrySDKLog+Configure.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkPackage.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/SentrySDKSettings.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySerializationSwift.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentrySession.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySessionReplay.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySessionReplayDelegate.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySRDefaultBreadcrumbConverter.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryStacktraceCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySysctl.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryThreadCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryThreadWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryTouchTracker.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/Performance/SentryTransactionNameSource.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryUIDeviceWrapper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryUIRedactBuilder.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryURLRequestFactory.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryUserCodable.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedback.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/Configuration/SentryUserFeedbackConfiguration.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/Configuration/SentryUserFeedbackFormConfiguration.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackFormController.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackFormViewModel.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackIntegrationDriver.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/Configuration/SentryUserFeedbackThemeConfiguration.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidget.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonMegaphoneIconView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/Configuration/SentryUserFeedbackWidgetConfiguration.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryVideoFrameProcessor.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryVideoInfo.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Protocol/SentryViewControllerBreadcrumbTracking.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryViewHierarchyProvider.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewPhotographer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewRenderer.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewRendererV2.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewScreenshotProvider.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/WatchdogTerminations/Processors/SentryWatchdogTerminationAttributesProcessor.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Extensions/StringExtensions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/SwiftDescriptor.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Integrations/Performance/SwizzleClassNameExclude.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/ThreadSafeApplication.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/UIImageHelper.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Extensions/UIViewExtensions.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/UrlSanitized.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/URLSessionTaskHelper.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Network.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/WebKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/PDFKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AudioToolbox.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMIDI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/MetricKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Synchronization.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Distributed.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/_SentryPrivate-9V0608BLS3M7OT5WATLJKER8L.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MetricKit-D2HIWPXL9H0VZ03VESD4U5P4U.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MediaToolbox-3CJ6XWFEJVI89M1KN938Q93SM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVRouting-4XEM0UTK93GVCBNBY2KWSZ1WI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/dnssd-62H4009Q10EGW9RZ7EPQ17LUH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMIDI-77HOUU5KPHXLY0GDH3P5R5IJR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/PDFKit-7XTKUB7BRYK7XZU3F7006MHO7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFoundation-1OGC7KECSN8FI4O3TP1RYEQF4.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Network-9VNWWDZ5HA67SK7TGCYKQSWHZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/WebKit-26SVPKRT1PFWDUPEC2U5OKKWG.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFAudio-AL0AXA4M3WOQHLUX3PQSS12YD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/Sentry-4KPOFWXIQIMOIX6U7XC3FMCNV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AudioToolbox-6STKQWXS7L0THVI0AOR6YNN8F.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/Sentry.build/Objects-normal/arm64/Sentry-dependencies-19.json (in target 'Sentry' from project 'Pods')

CompileSwift normal arm64 (in target 'Sentry' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/Data+SentryTracing.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/FileManager+SentryTracing.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/LoadValidator.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryAppState.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryBinaryImageCache.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryBreadcrumbCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryCrash/SentryCrashWrapper.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryDebugMetaCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchQueueWrapper.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchSourceWrapper.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryEnabledFeaturesBuilder.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelope.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeHeader.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeItem.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryEventCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryExceptionCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryFeedback.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/SentryFileIOTracker+SwiftHelpers.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryFrameCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryGeoCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogBatcher.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogger.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismMetaCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMessage.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryMigrateSessionInit.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryNSErrorCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryOnDemandReplay.swift:5:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayEvent.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayRecording.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryRequestCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebEvent.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebOptionsEvent.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Context.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Extras.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Fingerprint.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Helper.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Tags.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+User.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryScreenshotSource.swift:4:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySDK.swift:2:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkInfo.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentrySDKLog+Configure.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkPackage.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySerializationSwift.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentrySession.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySessionReplay.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySRDefaultBreadcrumbConverter.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryStacktraceCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySysctl.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryThreadCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryTouchTracker.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryURLRequestFactory.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryUserCodable.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackFormViewModel.swift:5:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackIntegrationDriver.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonMegaphoneIconView.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonView.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryViewHierarchyProvider.swift:3:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewPhotographer.swift:4:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/WatchdogTerminations/Processors/SentryWatchdogTerminationAttributesProcessor.swift:1:22: warning: using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution
@_implementationOnly import _SentryPrivate
                     ^

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/Data+SentryTracing.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/FileManager+SentryTracing.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/LoadValidator.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryAppState.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Helper/SentryBinaryImageCache.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryBreadcrumbCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentryCrash/SentryCrashWrapper.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryDebugMetaCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchQueueWrapper.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryDispatchSourceWrapper.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryEnabledFeaturesBuilder.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelope.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeHeader.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryEnvelopeItem.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryEventCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryExceptionCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryFeedback.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/Performance/IO/SentryFileIOTracker+SwiftHelpers.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryFrameCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryGeoCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogBatcher.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryLogger.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMechanismMetaCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryMessage.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentryMigrateSessionInit.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryNSErrorCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryOnDemandReplay.swift:5:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayEvent.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryReplayRecording.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryRequestCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebEvent.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/RRWeb/SentryRRWebOptionsEvent.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Context.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Extras.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Fingerprint.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Helper.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+Tags.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Persistence/SentryScopePersistentStore+User.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryScreenshotSource.swift:4:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySDK.swift:2:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkInfo.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentrySDKLog+Configure.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySdkPackage.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySerializationSwift.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/SentrySession.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySessionReplay.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentrySRDefaultBreadcrumbConverter.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryStacktraceCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Helper/SentrySysctl.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryThreadCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/SessionReplay/SentryTouchTracker.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryURLRequestFactory.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Protocol/Codable/SentryUserCodable.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackFormViewModel.swift:5:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackIntegrationDriver.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonMegaphoneIconView.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/UserFeedback/SentryUserFeedbackWidgetButtonView.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Tools/SentryViewHierarchyProvider.swift:3:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Core/Tools/ViewCapture/SentryViewPhotographer.swift:4:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Sentry/Sources/Swift/Integrations/WatchdogTerminations/Processors/SentryWatchdogTerminationAttributesProcessor.swift:1:22: Using '@_implementationOnly' without enabling library evolution for 'Sentry' may lead to instability during execution


Build target SDWebImage of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOCoder.o /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SDWebImage' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/SDWebImage/SDWebImage-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOCoder.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOCoder.dia -c /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOCoder.o

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:64: warning: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead. [-Wdeprecated-declarations]
  208 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:317:1: note: 'UTTypeCreatePreferredIdentifierForTag' has been explicitly marked deprecated here
  317 | UTTypeCreatePreferredIdentifierForTag(
      | ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:102: warning: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead. [-Wdeprecated-declarations]
  208 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                      ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:258:26: note: 'kUTTagClassFilenameExtension' has been explicitly marked deprecated here
  258 | extern const CFStringRef kUTTagClassFilenameExtension                API_DEPRECATED("Use UTTagClassFilenameExtension instead.", ios(3.0, 15.0), macos(10.3, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:173: warning: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead. [-Wdeprecated-declarations]
  208 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                                                                                             ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:725:26: note: 'kUTTypeImage' has been explicitly marked deprecated here
  725 | extern const CFStringRef kUTTypeImage                                API_DEPRECATED("Use UTTypeImage or UTType.image (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:210:17: warning: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead. [-Wdeprecated-declarations]
  210 |             if (UTTypeIsDynamic((__bridge CFStringRef)typeIdentifierHint)) {
      |                 ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:536:1: note: 'UTTypeIsDynamic' has been explicitly marked deprecated here
  536 | UTTypeIsDynamic(CFStringRef inUTI)                                   API_DEPRECATED("Use UTType.dynamic instead.", ios(8.0, 15.0), macos(10.10, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      | ^
4 warnings generated.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:64: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:102: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:208:173: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOCoder.m:210:17: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead.

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOAnimatedCoder.o /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SDWebImage' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/SDWebImage/SDWebImage-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOAnimatedCoder.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOAnimatedCoder.dia -c /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageIOAnimatedCoder.o

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:64: warning: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead. [-Wdeprecated-declarations]
  652 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:20:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:317:1: note: 'UTTypeCreatePreferredIdentifierForTag' has been explicitly marked deprecated here
  317 | UTTypeCreatePreferredIdentifierForTag(
      | ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:102: warning: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead. [-Wdeprecated-declarations]
  652 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                      ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:20:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:258:26: note: 'kUTTagClassFilenameExtension' has been explicitly marked deprecated here
  258 | extern const CFStringRef kUTTagClassFilenameExtension                API_DEPRECATED("Use UTTagClassFilenameExtension instead.", ios(3.0, 15.0), macos(10.3, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:173: warning: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead. [-Wdeprecated-declarations]
  652 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                                                                                             ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:20:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:725:26: note: 'kUTTypeImage' has been explicitly marked deprecated here
  725 | extern const CFStringRef kUTTypeImage                                API_DEPRECATED("Use UTTypeImage or UTType.image (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:654:17: warning: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead. [-Wdeprecated-declarations]
  654 |             if (UTTypeIsDynamic((__bridge CFStringRef)typeIdentifierHint)) {
      |                 ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:20:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:536:1: note: 'UTTypeIsDynamic' has been explicitly marked deprecated here
  536 | UTTypeIsDynamic(CFStringRef inUTI)                                   API_DEPRECATED("Use UTType.dynamic instead.", ios(8.0, 15.0), macos(10.10, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      | ^
4 warnings generated.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:64: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:102: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:652:173: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageIOAnimatedCoder.m:654:17: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead.

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageCacheDefine.o /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SDWebImage' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/SDWebImage/SDWebImage-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageCacheDefine.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageCacheDefine.dia -c /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/SDImageCacheDefine.o

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:64: warning: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead. [-Wdeprecated-declarations]
   89 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:317:1: note: 'UTTypeCreatePreferredIdentifierForTag' has been explicitly marked deprecated here
  317 | UTTypeCreatePreferredIdentifierForTag(
      | ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:102: warning: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead. [-Wdeprecated-declarations]
   89 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                      ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:258:26: note: 'kUTTagClassFilenameExtension' has been explicitly marked deprecated here
  258 | extern const CFStringRef kUTTagClassFilenameExtension                API_DEPRECATED("Use UTTagClassFilenameExtension instead.", ios(3.0, 15.0), macos(10.3, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:173: warning: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead. [-Wdeprecated-declarations]
   89 |             typeIdentifierHint = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtensionHint, kUTTypeImage);
      |                                                                                                                                                                             ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTCoreTypes.h:725:26: note: 'kUTTypeImage' has been explicitly marked deprecated here
  725 | extern const CFStringRef kUTTypeImage                                API_DEPRECATED("Use UTTypeImage or UTType.image (swift) instead.", ios(3.0, 15.0), macos(10.4, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      |                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:91:17: warning: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead. [-Wdeprecated-declarations]
   91 |             if (UTTypeIsDynamic((__bridge CFStringRef)typeIdentifierHint)) {
      |                 ^
In module 'CoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:17:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:536:1: note: 'UTTypeIsDynamic' has been explicitly marked deprecated here
  536 | UTTypeIsDynamic(CFStringRef inUTI)                                   API_DEPRECATED("Use UTType.dynamic instead.", ios(8.0, 15.0), macos(10.10, 12.0), tvos(9.0, 15.0), watchos(1.0, 8.0));
      | ^
4 warnings generated.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:64: 'UTTypeCreatePreferredIdentifierForTag' is deprecated: first deprecated in iOS 15.0 - Use the UTType class instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:102: 'kUTTagClassFilenameExtension' is deprecated: first deprecated in iOS 15.0 - Use UTTagClassFilenameExtension instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:89:173: 'kUTTypeImage' is deprecated: first deprecated in iOS 15.0 - Use UTTypeImage or UTType.image (swift) instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/SDImageCacheDefine.m:91:17: 'UTTypeIsDynamic' is deprecated: first deprecated in iOS 15.0 - Use UTType.dynamic instead.

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/NSData+ImageContentType.o /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/NSData+ImageContentType.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SDWebImage' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -include /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/Target\ Support\ Files/SDWebImage/SDWebImage-prefix.pch -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/NSData+ImageContentType.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/NSData+ImageContentType.dia -c /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/NSData+ImageContentType.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/SDWebImage.build/Objects-normal/arm64/NSData+ImageContentType.o

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/NSData+ImageContentType.m:159:16: warning: 'UTTypeConformsTo' is deprecated: first deprecated in iOS 15.0 - Use -[UTType conformsToType:] instead. [-Wdeprecated-declarations]
  159 |     } else if (UTTypeConformsTo(uttype, kSDUTTypeRAW)) {
      |                ^
In module 'MobileCoreServices' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/NSData+ImageContentType.m:14:
In module 'CoreServices' imported from /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/MobileCoreServices.framework/Headers/MobileCoreServices.h:9:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/CoreServices.framework/Headers/UTType.h:472:1: note: 'UTTypeConformsTo' has been explicitly marked deprecated here
  472 | UTTypeConformsTo(
      | ^
1 warning generated.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/SDWebImage/SDWebImage/Core/NSData+ImageContentType.m:159:16: 'UTTypeConformsTo' is deprecated: first deprecated in iOS 15.0 - Use -[UTType conformsToType:] instead.


Build target GoogleSignIn of project Pods with configuration Release

CompileC /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/GIDActivityIndicatorViewController.o /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/GoogleSignIn/GoogleSignIn/Sources/GIDAppCheck/UI/GIDActivityIndicatorViewController.m normal arm64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'GoogleSignIn' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    
    Using response file: /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp
    
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -ivfsstatcache /Users/Erlan/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphoneos26.1-23B77-69b33fc7382b27d9b5d46e82a00f8e78.sdkstatcache -fmessage-length\=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit\=0 -fno-color-diagnostics -fmodules-prune-interval\=86400 -fmodules-prune-after\=345600 -fbuild-session-file\=/Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -fmodules-validate-once-per-build-session -Wnon-modular-include-in-framework-module -Werror\=non-modular-include-in-framework-module -Wno-trigraphs -Wno-missing-field-initializers -Wno-missing-prototypes -Werror\=return-type -Wdocumentation -Wunreachable-code -Wno-implicit-atomic-properties -Werror\=deprecated-objc-isa-usage -Wno-objc-interface-ivars -Werror\=objc-root-class -Wno-arc-repeated-use-of-weak -Wimplicit-retain-self -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wno-float-conversion -Wnon-literal-null-conversion -Wobjc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wdeprecated-implementations -Wno-implicit-fallthrough -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Wno-sign-conversion -Winfinite-recursion -Wcomma -Wblock-capture-autoreleasing -Wstrict-prototypes -Wno-semicolon-before-method-body -Wunguarded-availability @/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/e6072d4f65d7061329687fe24e3d63a7-common-args.resp -MMD -MT dependencies -MF /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/GIDActivityIndicatorViewController.d --serialize-diagnostics /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/GIDActivityIndicatorViewController.dia -c /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/GoogleSignIn/GoogleSignIn/Sources/GIDAppCheck/UI/GIDActivityIndicatorViewController.m -o /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/GoogleSignIn.build/Objects-normal/arm64/GIDActivityIndicatorViewController.o

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/GoogleSignIn/GoogleSignIn/Sources/GIDAppCheck/UI/GIDActivityIndicatorViewController.m:34:13: warning: 'UIActivityIndicatorViewStyleGray' is deprecated: first deprecated in iOS 13.0 [-Wdeprecated-declarations]
   34 |     style = UIActivityIndicatorViewStyleGray;
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |             UIActivityIndicatorViewStyleMedium
In module 'UIKit' imported from /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/GoogleSignIn/GoogleSignIn/Sources/GIDAppCheck/UI/GIDActivityIndicatorViewController.h:21:
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIActivityIndicatorView.h:20:5: note: 'UIActivityIndicatorViewStyleGray' has been explicitly marked deprecated here
   20 |     UIActivityIndicatorViewStyleGray API_DEPRECATED_WITH_REPLACEMENT("UIActivityIndicatorViewStyleMedium", ios(2.0, 13.0)) API_UNAVAILABLE(tvos, visionos, watchos) = 2,
      |     ^
1 warning generated.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/GoogleSignIn/GoogleSignIn/Sources/GIDAppCheck/UI/GIDActivityIndicatorViewController.m:34:13: 'UIActivityIndicatorViewStyleGray' is deprecated: first deprecated in iOS 13.0


Build target DKPhotoGallery of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ DKPDFView.swift,\ DKPhotoBaseImagePreviewVC.swift,\ DKPhotoBasePreviewVC.swift,\ DKPhotoContentAnimationView.swift,\ DKPhotoGallery.swift,\ DKPhotoGalleryContentVC.swift,\ DKPhotoGalleryInteractiveTransition.swift,\ DKPhotoGalleryItem.swift,\ DKPhotoGalleryResource.swift,\ DKPhotoGalleryScrollView.swift,\ DKPhotoGalleryTransitionController.swift,\ DKPhotoGalleryTransitionDismiss.swift,\ DKPhotoGalleryTransitionPresent.swift,\ DKPhotoImageDownloader.swift,\ DKPhotoImagePreviewVC.swift,\ DKPhotoImageUtility.swift,\ DKPhotoImageView.swift,\ DKPhotoIncrementalIndicator.swift,\ DKPhotoPDFPreviewVC.swift,\ DKPhotoPlayerPreviewVC.swift,\ DKPhotoPreviewFactory.swift,\ DKPhotoProgressIndicator.swift,\ DKPhotoProgressIndicatorProtocol.swift,\ DKPhotoQRCodeResultVC.swift,\ DKPhotoWebVC.swift,\ DKPlayerView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PDFPreview/DKPDFView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoBaseImagePreviewVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/DKPhotoBasePreviewVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/DKPhotoContentAnimationView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGallery.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Transition/DKPhotoGalleryInteractiveTransition.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryItem.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Resource/DKPhotoGalleryResource.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryScrollView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Transition/DKPhotoGalleryTransitionController.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Transition/DKPhotoGalleryTransitionDismiss.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Transition/DKPhotoGalleryTransitionPresent.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageDownloader.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImagePreviewVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageUtility.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PDFPreview/DKPhotoPDFPreviewVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PlayerPreview/DKPhotoPlayerPreviewVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoPreviewFactory.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/DKPhotoProgressIndicator.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/DKPhotoProgressIndicatorProtocol.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/QRCode/DKPhotoQRCodeResultVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/QRCode/DKPhotoWebVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PlayerPreview/DKPlayerView.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Photos.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Network.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Synchronization.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Distributed.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreLocation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Products/Release-iphoneos/SwiftyGif/SwiftyGif.framework/Modules/SwiftyGif.swiftmodule/arm64-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AudioToolbox.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/WebKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/PDFKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/TipKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreData.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMIDI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ExtensionFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Spatial.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVRouting-4XEM0UTK93GVCBNBY2KWSZ1WI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUI-1JSS6Q5TK6JFX1EFIR05RE5PM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AudioToolbox-6STKQWXS7L0THVI0AOR6YNN8F.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/WebKit-26SVPKRT1PFWDUPEC2U5OKKWG.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFoundation-1OGC7KECSN8FI4O3TP1RYEQF4.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVKit-C9Q4KLN5WIK7I76R8I5CMHNTQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/PDFKit-7XTKUB7BRYK7XZU3F7006MHO7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreData-3HTYRBZKSWH6F8SWE6UT85JK7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/dnssd-62H4009Q10EGW9RZ7EPQ17LUH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFAudio-AL0AXA4M3WOQHLUX3PQSS12YD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Network-9VNWWDZ5HA67SK7TGCYKQSWHZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ExtensionFoundation-4E5895T1N0HAHH17JD98RQOC7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_LocationEssentials-57HBWC29OYME86VF4FPE4751L.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MobileCoreServices-YXJL4857GSZOGJ8PTSLJZ2QA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/SwiftyGif-97M8Q1SWVT92HXGD1TXGK9DP1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/DKPhotoGallery-A297HUK069M473L5ODJOUW6EE.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreServices-77VMZVLDO1O82YCBZ90IKKQQ9.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Spatial-AIGJ7N9DLHYYHZJ9DBLIJFDF6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMIDI-77HOUU5KPHXLY0GDH3P5R5IJR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/SDWebImage-7E9ADO76BZXFO369WV29UI2FI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MediaToolbox-3CJ6XWFEJVI89M1KN938Q93SM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreLocation-6MS86VN9XZ98WCKZN0E2N39IQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Photos-F1OD2TS7I62RHVAZP98M8QF99.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/DKPhotoGallery.build/Objects-normal/arm64/DKPhotoGallery-dependencies-19.json (in target 'DKPhotoGallery' from project 'Pods')

CompileSwift normal arm64 (in target 'DKPhotoGallery' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PDFPreview/DKPDFView.swift:50:48: warning: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'
        return UIActivityIndicatorView(style: .gray)
                                               ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PDFPreview/DKPDFView.swift:50:48: note: use 'UIActivityIndicatorView.Style.medium' instead
        return UIActivityIndicatorView(style: .gray)
                                               ^~~~
                                               UIActivityIndicatorView.Style.medium
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoBaseImagePreviewVC.swift:171:30: warning: 'UIPreviewAction' was deprecated in iOS 13.0: Please use UIContextMenuInteraction.
        let saveActionItem = UIPreviewAction(title: DKPhotoGalleryResource.localizedStringWithKey("preview.3DTouch.saveImage.title"),
                             ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGallery.swift:144:62: warning: 'statusBarStyle' was deprecated in iOS 13.0: Use the statusBarManager property of the window scene instead.
    private let defaultStatusBarStyle = UIApplication.shared.statusBarStyle
                                                             ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:39:52: warning: using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead
internal protocol DKPhotoGalleryContentDataSource: class {
                                                   ^~~~~
                                                   AnyObject
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:55:50: warning: using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead
internal protocol DKPhotoGalleryContentDelegate: class {
                                                 ^~~~~
                                                 AnyObject
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:107:14: warning: 'automaticallyAdjustsScrollViewInsets' was deprecated in iOS 11.0: Use UIScrollView's contentInsetAdjustmentBehavior instead
        self.automaticallyAdjustsScrollViewInsets = false
             ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageDownloader.swift:92:87: warning: 'kUTTypeGIF' was deprecated in iOS 15.0: Use UTTypeGIF or UTType.gif (swift) instead.
            let isGif = (asset.value(forKey: "uniformTypeIdentifier") as? String) == (kUTTypeGIF as String)
                                                                                      ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageDownloader.swift:94:42: warning: 'requestImageData(for:options:resultHandler:)' was deprecated in iOS 13
                PHImageManager.default().requestImageData(for: asset,
                                         ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImagePreviewVC.swift:34:42: warning: 'contentEdgeInsets' was deprecated in iOS 15.0: This property is ignored when using UIButtonConfiguration
        self.downloadOriginalImageButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                                         ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/QRCode/DKPhotoWebVC.swift:46:56: warning: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'
        self.spinner = UIActivityIndicatorView(style: .gray)
                                                       ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/QRCode/DKPhotoWebVC.swift:46:56: note: use 'UIActivityIndicatorView.Style.medium' instead
        self.spinner = UIActivityIndicatorView(style: .gray)
                                                       ^~~~
                                                       UIActivityIndicatorView.Style.medium
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PlayerPreview/DKPlayerView.swift:152:48: warning: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'
        return UIActivityIndicatorView(style: .gray)
                                               ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PlayerPreview/DKPlayerView.swift:152:48: note: use 'UIActivityIndicatorView.Style.medium' instead
        return UIActivityIndicatorView(style: .gray)
                                               ^~~~
                                               UIActivityIndicatorView.Style.medium
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:161:124: warning: forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.
        scrollView.addObserver(self, forKeyPath: DKPhotoIncrementalIndicator.contentSizeKeyPath, options: [.new], context: &DKPhotoIncrementalIndicator.context)
                                                                                                                           ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:162:126: warning: forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.
        scrollView.addObserver(self, forKeyPath: DKPhotoIncrementalIndicator.contentOffsetKeyPath, options: [.new], context: &DKPhotoIncrementalIndicator.context)
                                                                                                                             ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:171:23: warning: forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.
        if context == &DKPhotoIncrementalIndicator.context {
                      ^

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PDFPreview/DKPDFView.swift:50:48: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoBaseImagePreviewVC.swift:171:30: 'UIPreviewAction' was deprecated in iOS 13.0: Please use UIContextMenuInteraction.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGallery.swift:144:62: 'statusBarStyle' was deprecated in iOS 13.0: Use the statusBarManager property of the window scene instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:39:52: Using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:55:50: Using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoGalleryContentVC.swift:107:14: 'automaticallyAdjustsScrollViewInsets' was deprecated in iOS 11.0: Use UIScrollView's contentInsetAdjustmentBehavior instead

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageDownloader.swift:92:87: 'kUTTypeGIF' was deprecated in iOS 15.0: Use UTTypeGIF or UTType.gif (swift) instead.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImageDownloader.swift:94:42: 'requestImageData(for:options:resultHandler:)' was deprecated in iOS 13

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/ImagePreview/DKPhotoImagePreviewVC.swift:34:42: 'contentEdgeInsets' was deprecated in iOS 15.0: This property is ignored when using UIButtonConfiguration

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/QRCode/DKPhotoWebVC.swift:46:56: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/Preview/PlayerPreview/DKPlayerView.swift:152:48: 'gray' was deprecated in iOS 13.0: renamed to 'UIActivityIndicatorView.Style.medium'

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:161:124: Forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:162:126: Forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKPhotoGallery/DKPhotoGallery/DKPhotoIncrementalIndicator.swift:171:23: Forming 'UnsafeMutableRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.


Build target DKImagePickerController of project Pods with configuration Release

SwiftCompile normal arm64 Compiling\ DKAsset.swift,\ DKAsset+Export.swift,\ DKAsset+Fetch.swift,\ DKAssetGroup.swift,\ DKAssetGroupCellItemProtocol.swift,\ DKAssetGroupDetailBaseCell.swift,\ DKAssetGroupDetailCameraCell.swift,\ DKAssetGroupDetailImageCell.swift,\ DKAssetGroupDetailVC.swift,\ DKAssetGroupDetailVideoCell.swift,\ DKAssetGroupGridLayout.swift,\ DKAssetGroupListVC.swift,\ DKImageAssetExporter.swift,\ DKImageBaseManager.swift,\ DKImageDataManager.swift,\ DKImageExtensionController.swift,\ DKImageExtensionGallery.swift,\ DKImageGroupDataManager.swift,\ DKImagePickerController.swift,\ DKImagePickerControllerBaseUIDelegate.swift,\ DKImagePickerControllerResource.swift,\ DKPermissionView.swift,\ DKPopoverViewController.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/Model/DKAsset.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/Model/DKAsset+Export.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/Model/DKAsset+Fetch.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/Model/DKAssetGroup.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/Cell/DKAssetGroupCellItemProtocol.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/Cell/DKAssetGroupDetailBaseCell.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/Cell/DKAssetGroupDetailCameraCell.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/Cell/DKAssetGroupDetailImageCell.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKAssetGroupDetailVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/Cell/DKAssetGroupDetailVideoCell.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKAssetGroupGridLayout.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKAssetGroupListVC.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImageAssetExporter.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/DKImageBaseManager.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/DKImageDataManager.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImageExtensionController.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/Extensions/DKImageExtensionGallery.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/DKImageGroupDataManager.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerController.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerControllerBaseUIDelegate.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/Resource/DKImagePickerControllerResource.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKPermissionView.swift /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKPopoverViewController.swift /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Darwin.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Symbols.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Builtin_float.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Photos.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DeveloperToolsSupport.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/QuartzCore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Accessibility.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreLocation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/PDFKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreImage.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMedia.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/TipKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ExtensionFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation2.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Dispatch.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/ObjectiveC.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Products/Release-iphoneos/DKPhotoGallery/DKPhotoGallery.framework/Modules/DKPhotoGallery.swiftmodule/arm64-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/System.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUICore.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreMIDI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreVideo.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_Concurrency.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/DataDetection.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreText.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Spatial.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/XPC.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_StringProcessing.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Metal.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/FileProvider.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreData.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Products/Release-iphoneos/SwiftyGif/SwiftyGif.framework/Modules/SwiftyGif.swiftmodule/arm64-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UIKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Observation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Foundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/simd.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AudioToolbox.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreTransferable.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/OSLog.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFoundation.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Distributed.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Synchronization.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation1.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Combine.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/UniformTypeIdentifiers.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Network.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/WebKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/SwiftUI.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/Swift.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/CoreGraphics.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/_DarwinFoundation3.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVKit.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/os.swiftmodule/arm64e-apple-ios.swiftmodule /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/prebuilt-modules/26.1/AVFAudio.swiftmodule/arm64e-apple-ios.swiftmodule /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DataDetection-9CR8VZ5W5TPOLVWGF266PJRJY.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreFoundation-5MACJ3LS11LKEF6PHFABSZRPX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftShims-800DJGBDKYCHTXFHT7WQV3MMZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ObjectiveC-3O3EQGR5A91AZ5JHS0HPMV7CM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/dnssd-62H4009Q10EGW9RZ7EPQ17LUH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/FileProvider-E8KU3UX6LF2E10CNCF65DJIOX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/PDFKit-7XTKUB7BRYK7XZU3F7006MHO7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_object-A2AKMX2Q79T2LOZ4WPVJ5S6OJ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIKit-9I6QO6TLZUODETG8YHMSM0ZAD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Dispatch-C1W5U9QG3162D7LQZKWF27Q60.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreData-3HTYRBZKSWH6F8SWE6UT85JK7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_limits-E2B5NT1AHE4NJVUW5E0KWQXXB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OpenGLES-C2LG7ML0SO29A1PUVCPQPIGJO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MobileCoreServices-YXJL4857GSZOGJ8PTSLJZ2QA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Accessibility-7TZTMZZ5WBEQRXXMNBRYEDSIA.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Network-9VNWWDZ5HA67SK7TGCYKQSWHZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_tgmath-A9S16TYRAPL49KL17UP0JQF6T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreLocation-6MS86VN9XZ98WCKZN0E2N39IQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MediaToolbox-3CJ6XWFEJVI89M1KN938Q93SM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_float-HJOC1DY9UYPETWYPXQFUSHEC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreTransferable-407KTE3L8CH7025EHMJ11P9X8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdint-94B9JARYQASHFSDRYJG9SXXUB.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation3-466C3GYQ5GOWQC35TQEOSH1KD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdbool-6XI4WHRYPXNC4R96MZACI1456.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFAudio-AL0AXA4M3WOQHLUX3PQSS12YD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreGraphics-3CNSWYFJZF0TN3TM596ENY8Z5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AudioToolbox-6STKQWXS7L0THVI0AOR6YNN8F.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Symbols-5Q8XCY1E0NXC557E2MPILRSP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UniformTypeIdentifiers-1UWV5DITQYQMOS94UOYWGYAPI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/OSLog-EK0CLOWSOKYAAWT53C71G8H3C.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ExtensionFoundation-4E5895T1N0HAHH17JD98RQOC7.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Metal-79M3LJHTCS8EQRCJJYUU0FEUP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_SwiftConcurrencyShims-5JEE079RT5QLSZ6TDSOHGC54.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreVideo-41OSF5KQFCVRI7BL4PA1E3ERT.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/DKImagePickerController-9PY0A5JEAGU0K3NFU269JJ5H6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreImage-4TAY6HKZLQL62L1OUI9MP6XUV.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudio-BIEHEI0ONYQP2LCCYR5GLJO9R.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stddef-2YJ1PRP469KRYSI4WTPA4W81I.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/SwiftyGif-97M8Q1SWVT92HXGD1TXGK9DP1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/SDWebImage-7E9ADO76BZXFO369WV29UI2FI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/QuartzCore-23Z9GTF1VYJBOM7F8AIR4QXSF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Darwin-96H3TDDL4ZIF8S1UTORM80XUS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/MachO-79XWNPJR5T0667Q2Z2AKFOI1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UserNotifications-4ILJR40J3YQFYF2RZ8YLFRML3.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrauth-B3GU1A5C7096VQFV8C8YDGUSD.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_LocationEssentials-57HBWC29OYME86VF4FPE4751L.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMedia-4LGCFL8C65EX0G9JBLFNLSZWN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/XPC-66GZYN9O8F5ZRGM91CLC7ZNX6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdatomic-1K8UQ1H42FRZGJDG9QAI3KJT6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ImageIO-C6MDIA9KHBEK26ZA36PBTE2H0.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Foundation-3RSSWZ9YADJSP6M3OI0VGXD2T.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreAudioTypes-7BMFPEWE0EI80BUX3UD7QTRP.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreServices-77VMZVLDO1O82YCBZ90IKKQQ9.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/WebKit-26SVPKRT1PFWDUPEC2U5OKKWG.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/UIUtilities-IQJC44JWJX8ZJGVRFSDK6VTF.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreMIDI-77HOUU5KPHXLY0GDH3P5R5IJR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVKit-C9Q4KLN5WIK7I76R8I5CMHNTQ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUICore-8J9AVHGOYTQHHR1E7P33H4QHO.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/simd-B2DT97D74SZ6BFFTLP5YNZCW1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/DKPhotoGallery-DF3RJZ4S2IPQJOEVCGS34O35K.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os_workgroup-BDRBA2M1WOMJTR28FL20JOB1S.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation1-1KODRATYHWLGE5ULK9F0ESZBX.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Photos-F1OD2TS7I62RHVAZP98M8QF99.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Security-A80WVZH0ZL5RC0UNIHBCW9YMK.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/ptrcheck-1WWJ5I6FJCXNFLQHSVPHZHLCZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVFoundation-1OGC7KECSN8FI4O3TP1RYEQF4.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/IOSurface-2DHG81RCMOXNE2WYZX3SAKWUZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_DarwinFoundation2-1ZI4SX4LI1LP8BE2PHD0VR5UR.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CFNetwork-B5MQPEZ11725FYWWXF7W8RYLS.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_stdarg-5CBCIVU1D1C3QAKIDVJ4F45N8.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_AvailabilityInternal-286H7W35871XBYJJL0CIBIN7A.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Spatial-AIGJ7N9DLHYYHZJ9DBLIJFDF6.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/SwiftUI-1JSS6Q5TK6JFX1EFIR05RE5PM.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/DeveloperToolsSupport-AWKBAROX0D1MTTNSAA8HWUMAC.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/os-31WZRG3RHXCGGRP6Z4E3B8HZN.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/AVRouting-4XEM0UTK93GVCBNBY2KWSZ1WI.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_inttypes-CK6UF26ZMW1CNY27D3MHWD3P1.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/CoreText-3JQ7NL85OFZEJDSZ144HMY7DZ.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/_Builtin_intrinsics-6AEBNSBDHDC61ZGPNOMPQ1WQ5.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/sys_types-83M14KEU9T6AWPRVUUZQCI9NH.pcm /Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Intermediates.noindex/Pods.build/Release-iphoneos/DKImagePickerController.build/Objects-normal/arm64/DKImagePickerController-dependencies-19.json (in target 'DKImagePickerController' from project 'Pods')

CompileSwift normal arm64 (in target 'DKImagePickerController' from project 'Pods')
    cd /Users/Erlan/Desktop/app-flutter-online-course/ios/Pods
    

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKAssetGroupDetailVC.swift:344:14: warning: 'frameInterval' was deprecated in iOS 10.0: preferredFramesPerSecond
        link.frameInterval = 1
             ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImageAssetExporter.swift:557:38: warning: capture of 'fileManager' with non-Sendable type 'FileManager' in an isolated local function; this is an error in the Swift 6 language mode
                                try? fileManager.removeItem(at: auxiliaryDirectory)
                                     ^
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS26.1.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSFileManager.h:96:12: note: class 'FileManager' does not conform to the 'Sendable' protocol
@interface NSFileManager : NSObject
           ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/DKImageDataManager.swift:154:43: warning: 'requestImageData(for:options:resultHandler:)' was deprecated in iOS 13
        let imageRequestID = self.manager.requestImageData(
                                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/Extensions/DKImageExtensionGallery.swift:35:38: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
                UIApplication.shared.keyWindow!.rootViewController!.present(photoGallery: gallery)
                                     ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerController.swift:265:45: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
            targetVC = UIApplication.shared.keyWindow!.rootViewController!
                                            ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerController.swift:281:34: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
            UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true,
                                 ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKPopoverViewController.swift:30:43: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
        let window = UIApplication.shared.keyWindow!
                                          ^
/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKPopoverViewController.swift:43:43: warning: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
        let window = UIApplication.shared.keyWindow!
                                          ^

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/View/DKAssetGroupDetailVC.swift:344:14: 'frameInterval' was deprecated in iOS 10.0: preferredFramesPerSecond

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImageAssetExporter.swift:557:38: Capture of 'fileManager' with non-Sendable type 'FileManager' in an isolated local function; this is an error in the Swift 6 language mode

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImageDataManager/DKImageDataManager.swift:154:43: 'requestImageData(for:options:resultHandler:)' was deprecated in iOS 13

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/Extensions/DKImageExtensionGallery.swift:35:38: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerController.swift:265:45: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKImagePickerController.swift:281:34: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKPopoverViewController.swift:30:43: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

/Users/Erlan/Desktop/app-flutter-online-course/ios/Pods/DKImagePickerController/Sources/DKImagePickerController/DKPopoverViewController.swift:43:43: 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

