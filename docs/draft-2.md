-- LLDB integration loaded --
FirebaseEarlyInit: +load invoked before constructors
FirebaseEarlyInit(load): call stack at first configure attempt:
0   Runner                              0x00000001048e80ac ConfigureFirebaseOnObjCIfNeeded + 120
1   Runner                              0x00000001048e821c +[FirebaseEarlyInitSentinel load] + 48
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
MainThreadIOMonitor: -[NSBundle bundleIdentifier] (/private/var/containers/Bundle/Application/E0204E96-A023-46BC-B9DF-FB9EB5696DF5/Runner.app)
(
	0   Runner                              0x00000001048e8cb0 __MTILogOnce_block_invoke_2 + 108
	1   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	2   libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	3   Runner                              0x00000001048e8844 MTILogOnce + 152
	4   Runner                              0x00000001048e89e4 -[NSBundle(MainThreadIOMonitor) mti_bundleIdentifier] + 68
	5   BaseBoard                           0x0000000192ed7714 B8E90B10-9618-3E8F-8660-7423D55C5DFE + 87828
	6   UIKitCore                           0x000000018ba3c270 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 291440
	7   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	8   libdispatch.dylib                   0x0000000105d4b790 _dispatch_once_callout + 140
	9   UIKitCore                           0x000000018ba3c24c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 291404
	10  UIKitCore                           0x000000018ba3bb88 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 289672
	11  UIKitCore                           0x000000018ba3c444 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 291908
	12  UIKitCore                           0x000000018ba3ba64 UIApplicationMain + 316
	13  Runner                              0x00000001048e8284 main + 88
	14  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
)
MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/1D51E110-90DA-4F38-923A-F072FA5F0F74/Library)
(
	0   Runner                              0x00000001048e8cb0 __MTILogOnce_block_invoke_2 + 108
	1   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	2   libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	3   Runner                              0x00000001048e8844 MTILogOnce + 152
	4   Runner                              0x00000001048e895c -[NSFileManager(MainThreadIOMonitor) mti_createDirectoryAtPath:withIntermediateDirectories:attributes:error:] + 92
	5   UIKitCore                           0x000000018baa016c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 700780
	6   UIKitCore                           0x000000018bc1c3b0 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 2257840
	7   UIKitCore                           0x000000018bc1bdc4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 2256324
	8   UIKitCore                           0x000000018bc1c2e0 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 2257632
	9   UIKitCore                           0x000000018ba95064 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 655460
	10  UIKitCore                           0x000000018ce07fb4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21049268
	11  UIKitCore                           0x000000018ce0959c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21054876
	12  UIKitCore                           0x000000018ce0d5c0 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21071296
	13  UIKitCore                           0x000000018c419cc4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10636484
	14  UIKitCore                           0x000000018ba94620 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 652832
	15  UIKitCore                           0x000000018ba92b80 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646016
	16  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
	17  Runner                              0x00000001048e8284 main + 88
	18  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
)
BizPluginRegistrant: registerEssentialPlugins
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
NativeBootstrapCoordinator: native bootstrap channel created
StoreKit2Bridge: channels installed
NativeBootstrapCoordinator: StoreKit2Bridge installed on Flutter controller
flutter: INFO: Firebase bootstrap deferred to post-frame stage
MainThreadIOMonitor: -[NSData initWithContentsOfFile:options:error:] (/System/Library/CoreServices/SystemVersion.plist)
(
	0   Runner                              0x00000001048e8cb0 __MTILogOnce_block_invoke_2 + 108
	1   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	2   libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	3   Runner                              0x00000001048e8844 MTILogOnce + 152
	4   Runner                              0x00000001048e8770 -[NSData(MainThreadIOMonitor) mti_initWithContentsOfFile:options:error:] + 72
	5   Foundation                          0x0000000184028a14 218DA4DC-727A-3341-B59E-8FDB39A2D7C4 + 9439764
	6   ManagedConfiguration                0x00000001aa92a524 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 13604
	7   ManagedConfiguration                0x00000001aa92a4dc MCProductBuildVersion + 32
	8   ManagedConfiguration                0x00000001aa928c14 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 7188
	9   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	10  libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	11  ManagedConfiguration                0x00000001aa928a68 MCHasMigrated + 136
	12  ManagedConfiguration                0x00000001aa928af4 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 6900
	13  ManagedConfiguration                0x00000001aa99e65c AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 489052
	14  libMobileGestaltExtensions.dylib    0x00000001c6904edc _MGSCopyLocalizedString + 1252
	15  libMobileGestalt.dylib              0x00000001b315d2e4 libMobileGestalt.dylib + 4836
	16  libMobileGestalt.dylib              0x00000001b315dbc4 MGGetBoolAnswer + 36
	17  UIKitCore                           0x000000018d217a94 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25307796
	18  UIKitCore                           0x000000018d217ae0 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25307872
	19  UIKitCore                           0x000000018d217d14 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25308436
	20  UIKitCore                           0x000000018d19b684 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 24798852
	21  UIKitCore                           0x000000018d17f378 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 24683384
	22  Flutter                             0x00000001065accac $s26InternalFlutterSwiftCommon8LogLevelOMa + 107940
	23  Flutter                             0x00000001065ab0a8 $s26InternalFlutterSwiftCommon8LogLevelOMa + 100768
	24  Flutter                             0x00000001065a65cc $s26InternalFlutterSwiftCommon8LogLevelOMa + 81604
	25  Flutter                             0x0000000106a579d4 InternalFlutterGpu_Texture_AsImage + 20316
	26  Flutter                             0x00000001065ed860 $s26InternalFlutterSwiftCommon8LogLevelOMa + 373080
	27  libdispatch.dylib                   0x0000000105d4863c _dispatch_call_block_and_release + 32
	28  libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	29  libdispatch.dylib                   0x0000000105d834c0 _dispatch_main_queue_drain.cold.5 + 876
	30  libdispatch.dylib                   0x0000000105d58778 _dispatch_main_queue_drain + 180
	31  libdispatch.dylib                   0x0000000105d586b4 _dispatch_main_queue_callback_4CF + 44
	32  CoreFoundation                      0x000000018611c2c8 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 434888
	33  CoreFoundation                      0x00000001860cfb3c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 121660
	34  CoreFoundation                      0x00000001860cea6c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 117356
	35  GraphicsServices                    0x0000000226cf8498 GSEventRunModal + 120
	36  UIKitCore                           0x000000018ba92ba4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646052
	37  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
	38  Runner                              0x00000001048e8284 main + 88
	39  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
)
MainThreadIOMonitor: +[NSData dataWithContentsOfFile:options:error:] (/var/mobile/Library/UserConfigurationProfiles/PublicInfo/PublicEffectiveUserSettings.plist)
(
	0   Runner                              0x00000001048e8cb0 __MTILogOnce_block_invoke_2 + 108
	1   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	2   libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	3   Runner                              0x00000001048e8844 MTILogOnce + 152
	4   Runner                              0x00000001048e88c4 +[NSData(MainThreadIOMonitor) mti_dataWithContentsOfFile:options:error:] + 72
	5   ManagedConfiguration                0x00000001aa949fe8 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 143336
	6   ManagedConfiguration                0x00000001aa929050 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 8272
	7   ManagedConfiguration                0x00000001aa92b028 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 16424
	8   libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	9   libdispatch.dylib                   0x0000000105d593cc _dispatch_lane_barrier_sync_invoke_and_complete + 172
	10  ManagedConfiguration                0x00000001aa92afa4 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 16292
	11  ManagedConfiguration                0x00000001aa9d1ccc AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 699596
	12  ManagedConfiguration                0x00000001aa99e500 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 488704
	13  ManagedConfiguration                0x00000001aa99e94c AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 489804
	14  ManagedConfiguration                0x00000001aa99e694 AE14250B-B54E-30C5-9FAD-29C7D67288D4 + 489108
	15  libMobileGestaltExtensions.dylib    0x00000001c6904edc _MGSCopyLocalizedString + 1252
	16  libMobileGestalt.dylib              0x00000001b315d2e4 libMobileGestalt.dylib + 4836
	17  libMobileGestalt.dylib              0x00000001b315dbc4 MGGetBoolAnswer + 36
	18  UIKitCore                           0x000000018d217a94 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25307796
	19  UIKitCore                           0x000000018d217ae0 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25307872
	20  UIKitCore                           0x000000018d217d14 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 25308436
	21  UIKitCore                           0x000000018d19b684 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 24798852
	22  UIKitCore                           0x000000018d17f378 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 24683384
	23  Flutter                             0x00000001065accac $s26InternalFlutterSwiftCommon8LogLevelOMa + 107940
	24  Flutter                             0x00000001065ab0a8 $s26InternalFlutterSwiftCommon8LogLevelOMa + 100768
	25  Flutter                             0x00000001065a65cc $s26InternalFlutterSwiftCommon8LogLevelOMa + 81604
	26  Flutter                             0x0000000106a579d4 InternalFlutterGpu_Texture_AsImage + 20316
	27  Flutter                             0x00000001065ed860 $s26InternalFlutterSwiftCommon8LogLevelOMa + 373080
	28  libdispatch.dylib                   0x0000000105d4863c _dispatch_call_block_and_release + 32
	29  libdispatch.dylib                   0x0000000105d622d0 _dispatch_client_callout + 16
	30  libdispatch.dylib                   0x0000000105d834c0 _dispatch_main_queue_drain.cold.5 + 876
	31  libdispatch.dylib                   0x0000000105d58778 _dispatch_main_queue_drain + 180
	32  libdispatch.dylib                   0x0000000105d586b4 _dispatch_main_queue_callback_4CF + 44
	33  CoreFoundation                      0x000000018611c2c8 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 434888
	34  CoreFoundation                      0x00000001860cfb3c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 121660
	35  CoreFoundation                      0x00000001860cea6c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 117356
	36  GraphicsServices                    0x0000000226cf8498 GSEventRunModal + 120
	37  UIKitCore                           0x000000018ba92ba4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646052
	38  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
	39  Runner                              0x00000001048e8284 main + 88
	40  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
)
StoreKit2Bridge: fetchProducts [C838B521-A486-4E2F-A801-BAD1ACEA50AC] ids=gp_300,gp_1000,gp_2000
StoreKit2Bridge: fetchProducts [C838B521-A486-4E2F-A801-BAD1ACEA50AC] completed (found=0, invalid=3)