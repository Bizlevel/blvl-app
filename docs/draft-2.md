-- LLDB integration loaded --
FirebaseEarlyInit: +load invoked before constructors
FirebaseEarlyInit(load): call stack at first configure attempt:
0   Runner                              0x00000001046f00ac ConfigureFirebaseOnObjCIfNeeded + 120
1   Runner                              0x00000001046f021c +[FirebaseEarlyInitSentinel load] + 48
2   libobjc.A.dylib                     0x000000018307deb0 AF9349A3-834F-369E-ACE5-C50571C9C7BA + 122544
3   dyld                                0x0000000183105448 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 144456
4   dyld                                0x000000018310623c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 148028
5   dyld                                0x0000000183106044 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 147524
6   dyld                                0x0000000183105f3c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 147260
7   dyld                                0x0000000183103fe8 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 139240
8   dyld                                0x00000001830f785c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 88156
9   dyld                                0x00000001830e6dd8 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 19928
FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer
FirebaseEarlyInit(constructor0): FIRApp already configured before ObjC hook
FirebaseEarlyInit: configuring Firebase before UIApplicationMain
FirebaseEarlyInit(constructor_default): FIRApp already configured before ObjC hook
AppDelegate: FIRApp was already configured before configureFirebaseBeforeMain()
AppDelegate: App Check uses DeviceCheck provider
AppDelegate: Firebase configured before UIApplicationMain (debugProvider=OFF)
AppDelegate: iOS FCM enabled=NO
`UIScene` lifecycle will soon be required. Failure to adopt will result in an assert in the future.
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
BizPluginRegistrant: registerEssentialPlugins
AppDelegate: native bootstrap channel created
StoreKit2Bridge: channels installed
AppDelegate: StoreKit2Bridge installed on Flutter controller
flutter: INFO: Firebase bootstrap deferred to post-frame stage
AppDelegate: skip APNs token registration (iOS FCM disabled)
StoreKit2Bridge: fetchProducts [4CA18875-D610-4999-810E-47BEECE45BBB] ids=gp_300,gp_1000,gp_2000
StoreKit2Bridge: fetchProducts [4CA18875-D610-4999-810E-47BEECE45BBB] completed (found=0, invalid=3)