-- LLDB integration loaded --
FirebaseEarlyInit: +load invoked before constructors
FirebaseEarlyInit(load): call stack at first configure attempt:
0   Runner.debug.dylib                  0x000000010229694c FirebaseEarlyInitLogCallStackOnce + 84
1   Runner.debug.dylib                  0x00000001022966c0 ConfigureFirebaseOnObjCIfNeeded + 60
2   Runner.debug.dylib                  0x0000000102296878 +[FirebaseEarlyInitSentinel load] + 60
3   libobjc.A.dylib                     0x000000018007a63c load_images + 644
4   dyld                                0x0000000100a38418 _ZN5dyld412RuntimeState14notifyObjCInitEPKNS_6LoaderE + 248
5   dyld                                0x0000000100a3cfe0 _ZNK5dyld46Loader23runInitializersBottomUpERNS_12RuntimeStateERN5dyld35ArrayIPKS0_EES8_ + 292
6   dyld                                0x0000000100a3cf8c _ZNK5dyld46Loader23runInitializersBottomUpERNS_12RuntimeStateERN5dyld35ArrayIPKS0_EES8_ + 208
7   dyld                                0x0000000100a403a4 _ZZNK5dyld46Loader38runInitializersBottomUpPlusUpwardLinksERNS_12RuntimeStateEENK3$_0clEv + 136
8   dyld                                0x0000000100a3d098 _ZNK5dyld46Loader38runInitializersBottomUpPlusUpwardLinksERNS_12RuntimeStateE + 96
9   dyld                                0x0000000100a4e370 _ZN5dyld44APIs25runAllInitializersForMainEv + 224
10  dyld                                0x0000000100a2dd3c _ZN5dyld4L7prepareERNS_4APIsEPKN6mach_o6HeaderE + 2192
11  dyld                                0x0000000100a2d348 _dyld_sim_prepare + 840
12  ???                                 0x0000000100b9c898 0x0 + 4307142808
13  ???                                 0x0000000100b9b344 0x0 + 4307137348
14  ???                                 0x0000000100b9b1d8 0x0 + 4307136984
15  ???                                 0x0000000100b9ab4c 0x0 + 4307135308
FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer
FirebaseEarlyInit(constructor0): FIRApp already configured before ObjC hook
FirebaseEarlyInit: configuring Firebase before UIApplicationMain
FirebaseEarlyInit(constructor_default): FIRApp already configured before ObjC hook
AppDelegate: FIRApp was already configured before configureFirebaseBeforeMain()
AppDelegate: App Check uses DeviceCheck provider
AppDelegate: Firebase configured before UIApplicationMain (debugProvider=OFF)
AppDelegate: iOS FCM enabled=YES
MainThreadIOMonitor: -[NSData initWithContentsOfFile:options:error:] (/Users/Erlan/Library/Developer/CoreSimulator/Devices/F7F7D5FA-5763-4D8D-9D6E-7937BE64B0BA/data/Containers/Bundle/Application/45A0C103-C59D-4637-9ED4-D27B9DFAF66D/Runner.app/Base.lproj/Main.storyboardc/Info-8.0+.plist)
0   Runner.debug.dylib                  0x000000010229732c MTILogOnce + 156
1   Runner.debug.dylib                  0x0000000102297188 -[NSData(MainThreadIOMonitor) mti_initWithContentsOfFile:options:error:] + 120
2   Foundation                          0x0000000180e4a5c4 +[NSDictionary(NSDictionary) newWithContentsOf:immutable:] + 96
3   UIKitCore                           0x0000000185e06058 +[UIStoryboard storyboardWithName:bundle:] + 168
4   UIKitCore                           0x0000000185c5d810 -[UIApplication _storyboardInitialMenu] + 112
5   UIKitCore                           0x0000000185c7a544 -[UIApplication buildMenuWithBuilder:] + 44
6   UIKitCore                           0x0000000186179cec -[UIMenuSystem _buildMenuWithBuilder:fromResponderChain:atLocation:inCoordinateSpace:] + 92
7   UIKitCore                           0x00000001850a2900 -[_UIMainMenuSystem _buildMenuWithBuilder:fromResponderChain:atLocation:inCoordinateSpace:] + 112
8   UIKitCore                           0x0000000186179c2c -[UIMenuSystem _newBuilderFromResponderChain:atLocation:inCoordinateSpace:] + 96
9   UIKitCore                           0x00000001850a27d4 -[_UIMainMenuSystem _automaticallyRebuildIfNeeded] + 172
10  UIKitCore                           0x00000001850a280c -[_UIMainMenuSystem _keyCommands] + 20
11  UIKitCore                           0x0000000185c75eec -[UIApplication _keyCommands] + 80
12  UIKitCore                           0x0000000185c86ab0 -[UIResponder _enumerateKeyCommandsInChainWithOptions:usingBlock:] + 436
13  UIKitCore                           0x0000000185c75b74 -[UIApplication _immediatelyUpdateSerializableKeyCommandsForResponder:] + 164
14  UIKitCore                           0x00000001861729a8 -[_UIAfterCACommitBlock run] + 64
15  UIKitCore                           0x0000000186172dbc -[_UIAfterCACommitQueue flush] + 164
16  UIKitCore                           0x0000000185c6654c _runAfterCACommitDeferredBlocks + 256
17  UIKitCore                           0x0000000185c58028 _cleanUpAfterCAFlushAndRunDeferredBlocks + 76
18  UIKitCore                           0x0000000185c580f0 _UIApplicationFlushCATransaction + 68
19  UIKitCore                           0x0000000185b88c60 __setupUpdateSequence_block_invoke_2 + 356
20  UIKitCore                           0x00000001851bd0c0 _UIUpdateSequenceRun + 76
21  UIKitCore                           0x0000000185b884f4 schedulerStepScheduledMainSection + 204
22  UIKitCore                           0x0000000185b87910 runloopSourceCallback + 80
23  CoreFoundation                      0x0000000180429368 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 24
24  CoreFoundation                      0x00000001804292b0 __CFRunLoopDoSource0 + 168
25  CoreFoundation                      0x0000000180428a94 __CFRunLoopDoSources0 + 312
26  CoreFoundation                      0x0000000180423434 __CFRunLoopRun + 780
27  CoreFoundation                      0x0000000180422cec CFRunLoopRunSpecific + 536
28  GraphicsServices                    0x0000000191004d00 GSEventRunModal + 164
29  UIKitCore                           0x0000000185c597d4 -[UIApplication _run] + 796
30  UIKitCore                           0x0000000185c5dba0 UIApplicationMain + 124
31  Runner.debug.dylib                  0x0000000102296a70 __debug_main_executable_dylib_entry_point + 116
32  dyld                                0x0000000100a2d3d4 start_sim + 20
33  ???                                 0x0000000100b9ab98 0x0 + 4307135384
fopen failed for data file: errno = 2 (No such file or directory)
Errors found! Invalidating cache...
fopen failed for data file: errno = 2 (No such file or directory)
Errors found! Invalidating cache...
flutter: The Dart VM service is listening on http://127.0.0.1:64475/UUbmwn2Ap4g=/
BizPluginRegistrant: registerEssentialPlugins
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
NativeBootstrapCoordinator: native bootstrap channel created
StoreKit2Bridge: channels installed
NativeBootstrapCoordinator: StoreKit2Bridge installed on Flutter controller
flutter: INFO: Firebase bootstrap deferred to post-frame stage
flutter: supabase.supabase_flutter: INFO: ***** Supabase init completed *****
[SentryFlutterPlugin] Async native init scheduled in 0.00 s
[SentryFlutterPlugin] Async native init started
[Sentry] [warning] [1764660281.072133] [SentryFileManager:1015] No data found at /Users/Erlan/Library/Developer/CoreSimulator/Devices/F7F7D5FA-5763-4D8D-9D6E-7937BE64B0BA/data/Containers/Data/Application/D3635F2D-EC83-4A80-9362-6E312826378D/Library/Caches/io.sentry/804a8cb284b96249456d4baf749f096ecda63106/session.current
flutter: currentUserProvider: auth session = false, user = null
FlutterSemanticsScrollView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
flutter: INFO: Firebase.initializeApp() completed (post_frame_bootstrap)
MainThreadIOMonitor: -[NSBundle bundleIdentifier] (/Users/Erlan/Library/Developer/Xcode/DerivedData/Runner-buockbtbzrabkocxzjqzasuuozki/Build/Products/Debug-iphonesimulator/Flutter.framework)
0   Runner.debug.dylib                  0x000000010229732c MTILogOnce + 156
1   Runner.debug.dylib                  0x000000010229780c -[NSBundle(MainThreadIOMonitor) mti_bundleIdentifier] + 148
2   AutoFillUI                          0x00000001d9ae5a0c -[AFUITargetDetectionController _detectionDisabledForResponder:] + 164
3   AutoFillUI                          0x00000001d9ae5b84 -[AFUITargetDetectionController autoFillModeForResponder:] + 40
4   UIKitCore                           0x0000000185b4119c -[UIKBAutofillController needAutofillCandidate:delegateAsResponder:keyboardState:] + 452
5   UIKitCore                           0x00000001852cd4fc -[_UIKeyboardStateManager needAutofillCandidate:] + 1044
6   UIKitCore                           0x00000001852d5540 -[_UIKeyboardStateManager _setupDelegate:delegateSame:hardwareKeyboardStateChanged:endingInputSessionIdentifier:force:delayEndInputSession:] + 1160
7   UIKitCore                           0x00000001852d387c -[_UIKeyboardStateManager setDelegate:force:delayEndInputSession:] + 624
8   UIKitCore                           0x0000000185647e50 -[UIKeyboardSceneDelegate _reloadInputViewsForKeyWindowSceneResponder:force:fromBecomeFirstResponder:] + 2876
9   UIKitCore                           0x0000000185646ec0 -[UIKeyboardSceneDelegate _reloadInputViewsForResponder:force:fromBecomeFirstResponder:] + 84
10  UIKitCore                           0x0000000185c8a080 -[UIResponder(UIResponderInputViewAdditions) _reloadInputViewsFromFirstResponder:] + 84
11  UIKitCore                           0x0000000185c84b64 -[UIResponder becomeFirstResponder] + 744
12  UIKitCore                           0x00000001861bd978 -[UIView(Hierarchy) becomeFirstResponder] + 100
13  Flutter                             0x00000001059eaec8 -[FlutterTextInputPlugin handleMethodCall:result:] + 200
14  Flutter                             0x00000001059bf568 __47-[FlutterEngine maybeSetupPlatformViewChannels]_block_invoke_3 + 100
15  Flutter                             0x0000000105ec0d60 __45-[FlutterMethodChannel setMethodCallHandler:]_block_invoke + 164
16  Flutter                             0x0000000105a0fee0 ___ZN7flutter25PlatformMessageHandlerIos21HandlePlatformMessageENSt3_fl10unique_ptrINS_15PlatformMessageENS1_14default_deleteIS3_EEEE_block_invoke + 108
17  libdispatch.dylib                   0x000000010092fec8 _dispatch_call_block_and_release + 24
18  libdispatch.dylib                   0x0000000100949798 _dispatch_client_callout + 12
19  libdispatch.dylib                   0x000000010093f408 _dispatch_main_queue_drain + 1220
20  libdispatch.dylib                   0x000000010093ef34 _dispatch_main_queue_callback_4CF + 40
21  CoreFoundation                      0x0000000180428e9c __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
22  CoreFoundation                      0x00000001804238a8 __CFRunLoopRun + 1920
23  CoreFoundation                      0x0000000180422cec CFRunLoopRunSpecific + 536
24  GraphicsServices                    0x0000000191004d00 GSEventRunModal + 164
25  UIKitCore                           0x0000000185c597d4 -[UIApplication _run] + 796
26  UIKitCore                           0x0000000185c5dba0 UIApplicationMain + 124
27  Runner.debug.dylib                  0x0000000102296a70 __debug_main_executable_dylib_entry_point + 116
28  dyld                                0x0000000100a2d3d4 start_sim + 20
29  ???                                 0x0000000100b9ab98 0x0 + 4307135384
AddInstanceForFactory: No factory registered for id <CFUUID 0x60000073d680> F8BB1C28-BAE8-11D6-9C31-00039315CD46
       LoudnessManager.mm:721   unable to open stream for LoudnessManager plist
104967          HALC_ProxyIOContext.cpp:1622  HALC_ProxyIOContext::IOWorkLoop: skipping cycle due to overload
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021804b0 UIView:0x101d6a260.height == 124.2   (active)>",
    "<NSLayoutConstraint:0x600002186030 V:|-(>=6)-[UIView:0x101d6a260]   (active, names: '|':UIView:0x101d6b220 )>",
    "<NSLayoutConstraint:0x600002186080 V:[UIView:0x101d6a260]-(0)-|   (active, names: '|':UIView:0x101d6b220 )>",
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x6000021763a0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021804b0 UIView:0x101d6a260.height == 124.2   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186030 V:|-(>=6)-[UIView:0x101d6a260]   (active, names: '|':UIView:0x101d6b220 )>",
    "<NSLayoutConstraint:0x600002186080 V:[UIView:0x101d6a260]-(0)-|   (active, names: '|':UIView:0x101d6b220 )>",
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x6000021763a0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002186080 V:[UIView:0x101d6a260]-(0)-|   (active, names: '|':UIView:0x101d6b220 )>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x6000021763a0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021763a0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x600002181ea0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002181ea0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x60000218a5d0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x60000218a5d0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x60000218aa80 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x60000218aa80 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x60000217e4e0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x60000217e4e0 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186a80 UIKBTutorialSinglePageView:0x101c68280.height == 0.99*UIScrollView:0x104ab9000.height   (active)>",
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002178be0 V:|-(0)-[UILayoutGuide:0x600003b31ea0'']   (active, names: '|':UIKBTutorialSinglePageView:0x101c68280 )>",
    "<NSLayoutConstraint:0x60000217a440 V:[UILayoutGuide:0x600003b31ea0'']-(0)-[UIView:0x101d6b220]   (active)>",
    "<NSLayoutConstraint:0x60000216caa0 UILayoutGuide:0x600003b31f80''.bottom == UIKBTutorialSinglePageView:0x101c68280.bottom   (active)>",
    "<NSLayoutConstraint:0x60000216b8e0 UILayoutGuide:0x600003b31f80''.top == UILabel:0x101c68ef0.firstBaseline   (active)>",
    "<NSLayoutConstraint:0x600002198910 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002198910 V:[UIView:0x101d6b220]-(20)-[UILabel:0x101c68ef0]   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002171590 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021819f0 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021819f0 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x60000218a260 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x60000218a260 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002116850 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600002116850 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x6000021716d0 V:|-(0)-[UIScrollView:0x104ab9000]   (active, names: '|':UIKBTutorialMultipageView:0x101c69200 )>",
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021997c0 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021997c0 UIScrollView:0x104ab9000.bottom == UIKBTutorialMultipageView:0x101c69200.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002187340 V:|-(0)-[UIKBTutorialMultipageView:0x101c69200]   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x6000021873e0 V:[UIKBTutorialMultipageView:0x101c69200]-(>=0)-[UIButton:0x101678ba0]   (active)>",
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>",
    "<NSLayoutConstraint:0x600002186fd0 V:[UIButton:0x101678ba0]-(0)-|   (active, names: '|':UIView:0x101d76f60 )>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021876b0 UIButton:0x101678ba0.height == 21   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600002186df0 V:|-(0)-[UIView:0x101d76f60]   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x600002186f80 UIContinuousPathIntroduct....top == SystemInputAssistantView.top   (active, names: UIContinuousPathIntroduct...:0x101677a90, SystemInputAssistantView:0x101a1df50 )>",
    "<NSLayoutConstraint:0x600002187250 UIContinuousPathIntroduct....bottom == UIInputSetContainerView:0x101a3e540.bottom   (active, names: UIContinuousPathIntroduct...:0x101677a90 )>",
    "<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>",
    "<NSLayoutConstraint:0x600002164c30 'assistantView.top' V:|-(0)-[SystemInputAssistantView]   (active, names: SystemInputAssistantView:0x101a1df50, '|':UIInputSetHostView:0x101a3f070 )>",
    "<NSLayoutConstraint:0x6000021980a0 'UIInputViewSetPlacement_GenericApplicator<UIInputViewSetPlacementOffScreenDown>.vertical' V:[UIInputSetContainerView:0x101a3e540]-(0)-[UIInputSetHostView:0x101a3f070]   (active)>",
    "<NSLayoutConstraint:0x600002187480 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide']-(34)-|   (active, names: UIContinuousPathIntroduct...:0x101677a90, '|':UIContinuousPathIntroduct...:0x101677a90 )>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x6000021879d0 UILayoutGuide:0x600003b1f720'UIViewSafeAreaLayoutGuide'.bottom == UIView:0x101d76f60.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
If you want to see the backtrace, please set CG_NUMERICS_SHOW_BACKTRACE environmental variable.
FlutterSemanticsScrollView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
flutter: currentUserProvider: auth session = true, user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: querying users table for 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: raw response: {id: 4e46bca3-e742-4bb4-bc97-1e5832d753a3, name: Ерлан А, email: deus2111@gmail.com, about: Булочки пеку., goal: Круасаны по рецепту бабушки научиться делать., business_area: Пекарни, experience_level: 10 лет, onboarding_completed: true, current_level: 11, avatar_id: 5, business_size: 5-50 сотрудников, key_challenges: [Команда, Масштабирование], learning_style: Практические примеры, business_region: Казахстан}
flutter: UserRepository.fetchProfile: loaded user 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: goal = "Круасаны по рецепту бабушки научиться делать."
flutter: UserRepository.fetchProfile: about = "Булочки пеку."
flutter: currentUserProvider: repository returned true
FlutterSemanticsScrollView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.