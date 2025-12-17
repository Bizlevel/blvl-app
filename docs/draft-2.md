-- LLDB integration loaded --
BizPluginRegistrant: registerEssentialPlugins
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
NativeBootstrapCoordinator: native bootstrap channel created
flutter: STARTUP[main.ensure_initialized] {t_ms: 0}
flutter: STARTUP[main.run_app] {t_ms: 0}
flutter: STARTUP[ui.bootstrap.first_frame] {t_ms: 3895}
flutter: STARTUP[bootstrap.start] {t_ms: 3903}
flutter: STARTUP[bootstrap.dotenv.start] {t_ms: 3903}
flutter: STARTUP[bootstrap.dotenv.ok] {t_ms: 3912}
flutter: STARTUP[bootstrap.supabase.start] {t_ms: 3913}
flutter: STARTUP[bootstrap.supabase.ok] {t_ms: 3919}
flutter: INFO: Supabase bootstrap completed
flutter: STARTUP[bootstrap.hive.start] {t_ms: 3919}
flutter: INFO: Hive.initFlutter() starting...
flutter: INFO: Hive.initFlutter() completed successfully
flutter: STARTUP[bootstrap.hive.ok] {t_ms: 3926}
flutter: INFO: Hive bootstrap completed
flutter: STARTUP[bootstrap.done] {t_ms: 3927}
flutter: STARTUP[postframe.start] {t_ms: 3944}
flutter: STARTUP[postframe.local_services.start] {t_ms: 3944}
flutter: INFO: Hive already initialized, skipping
flutter: STARTUP[ui.router.first_frame] {t_ms: 3944, w: 393, h: 852, dpr: 3.0}
flutter: STARTUP[postframe.local_services.ok] {t_ms: 3944}
flutter: STARTUP[postframe.launch_route.start] {t_ms: 3944}
flutter: STARTUP[postframe.launch_route.ok] {t_ms: 5583}
flutter: STARTUP[postframe.push_auth_gate.setup] {t_ms: 5583}
flutter: STARTUP[postframe.done] {t_ms: 5583}
flutter: STARTUP[postframe.sentry.deferred.start] {t_ms: 7879}
[SentryFlutterPlugin] Async native init disabled, starting immediately
[SentryFlutterPlugin] Async native init started
MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/9713DB6E-E228-485A-ACD2-5A3E1F902671/Library/Caches)
0   Runner                              0x00000001005585a0 MTILogOnce + 104
1   Runner                              0x0000000100558988 -[NSFileManager(MainThreadIOMonitor) mti_createDirectoryAtPath:withIntermediateDirectories:attributes:error:] + 224
2   Runner                              0x0000000100602044 createDirectoryIfNotExists + 76
3   Runner                              0x00000001005d1368 +[SentryAsyncLogWrapper initializeAsyncLogFile] + 108
4   Runner                              0x0000000100629cb8 +[SentrySDKInternal startWithOptions:] + 252
5   Runner                              0x000000010062a12c +[SentrySDKInternal startWithConfigureOptions:] + 84
6   Runner                              0x00000001006a776c $s6Sentry0A3SDKC5start16configureOptionsyySo0aE0Cc_tFZTm + 140
7   Runner                              0x00000001007073d0 $s14sentry_flutter19SentryFlutterPluginC13initNativeSdk33_491F737C4EFC5E801AEAEA4C4751A42DLL_6resultySo0D10MethodCallC_yypSgctF015$syXlSgIeyBy_ypU7Iegn_TRyXlSgIeyBy_Tf1ncn_nTf4nng_n + 2184
8   Runner                              0x0000000100708428 $s14sentry_flutter19SentryFlutterPluginC6handle_6resultySo0D10MethodCallC_yypSgctF015$syXlSgIeyBy_ypL7Iegn_TRyXlSgIeyBy_Tf1ncn_nTf4nng_n + 216
9   Runner                              0x0000000100701d48 $s14sentry_flutter19SentryFlutterPluginC6handle_6resultySo0D10MethodCallC_yypSgctFTo + 80
10  Flutter                             0x00000001026bb9d4 InternalFlutterGpu_Texture_AsImage + 20316
11  Flutter                             0x0000000102251860 $s26InternalFlutterSwiftCommon8LogLevelOMa + 373080
12  libdispatch.dylib                   0x0000000101a5463c _dispatch_call_block_and_release + 32
13  libdispatch.dylib                   0x0000000101a6e2d0 _dispatch_client_callout + 16
14  libdispatch.dylib                   0x0000000101a8f4c0 _dispatch_main_queue_drain.cold.5 + 876
15  libdispatch.dylib                   0x0000000101a64778 _dispatch_main_queue_drain + 180
16  libdispatch.dylib                   0x0000000101a646b4 _dispatch_main_queue_callback_4CF + 44
17  CoreFoundation                      0x000000018611c2c8 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 434888
18  CoreFoundation                      0x00000001860cfb3c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 121660
19  CoreFoundation                      0x00000001860cea6c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 117356
20  GraphicsServices                    0x0000000226cf8498 GSEventRunModal + 120
21  UIKitCore                           0x000000018ba92ba4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646052
22  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
23  Runner                              0x0000000100558050 main + 80
24  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
<0x1075cda40> Gesture: System gesture gate timed out.
MainThreadIOMonitor: -[NSData initWithContentsOfFile:options:error:] (/private/var/containers/Bundle/Application/AB3086BC-7546-44D9-8CA8-1CA90953AE1F/Runner.app/Base.lproj/Main.storyboardc/Info-8.0+.plist)
0   Runner                              0x00000001005585a0 MTILogOnce + 104
1   Runner                              0x00000001005584a4 -[NSData(MainThreadIOMonitor) mti_initWithContentsOfFile:options:error:] + 84
2   Foundation                          0x0000000184028a14 218DA4DC-727A-3341-B59E-8FDB39A2D7C4 + 9439764
3   UIKitCore                           0x000000018cfafebc A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 22785724
4   UIKitCore                           0x000000018ce0e288 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21074568
5   UIKitCore                           0x000000018ce2a6ac A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21190316
6   UIKitCore                           0x000000018d33eec8 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26517192
7   UIKitCore                           0x000000018d33ee08 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26517000
8   UIKitCore                           0x000000018d33a2ec A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26497772
9   UIKitCore                           0x000000018d341760 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26527584
10  UIKitCore                           0x000000018d342e90 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26533520
11  UIKitCore                           0x000000018d340d78 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 26525048
12  Flutter                             0x0000000102226464 $s26InternalFlutterSwiftCommon8LogLevelOMa + 195932
13  Flutter                             0x00000001022309d8 $s26InternalFlutterSwiftCommon8LogLevelOMa + 238288
14  Flutter                             0x000000010220f284 $s26InternalFlutterSwiftCommon8LogLevelOMa + 101244
15  Flutter                             0x000000010220eecc $s26InternalFlutterSwiftCommon8LogLevelOMa + 100292
16  Flutter                             0x000000010220a5cc $s26InternalFlutterSwiftCommon8LogLevelOMa + 81604
17  Flutter                             0x00000001026bb9d4 InternalFlutterGpu_Texture_AsImage + 20316
18  Flutter                             0x0000000102251860 $s26InternalFlutterSwiftCommon8LogLevelOMa + 373080
19  libdispatch.dylib                   0x0000000101a5463c _dispatch_call_block_and_release + 32
20  libdispatch.dylib                   0x0000000101a6e2d0 _dispatch_client_callout + 16
21  libdispatch.dylib                   0x0000000101a8f4c0 _dispatch_main_queue_drain.cold.5 + 876
22  libdispatch.dylib                   0x0000000101a64778 _dispatch_main_queue_drain + 180
23  libdispatch.dylib                   0x0000000101a646b4 _dispatch_main_queue_callback_4CF + 44
24  CoreFoundation                      0x000000018611c2c8 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 434888
25  CoreFoundation                      0x00000001860cfb3c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 121660
26  CoreFoundation                      0x00000001860cea6c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 117356
27  GraphicsServices                    0x0000000226cf8498 GSEventRunModal + 120
28  UIKitCore                           0x000000018ba92ba4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646052
29  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
30  Runner                              0x0000000100558050 main + 80
31  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008
Could not find cached accumulator for token=F0C7D447 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=AAB8F0EF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=557EA80F type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=3B80FCFF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=DBA40407 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=CF95DE3A type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=2CE48ADE type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=BC9C28B4 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=1E1BF063 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=3BE311AB type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=903BE6CF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=2B31114F type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=1A435B4D type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=FF3C0E6F type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=23758306 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=04D3F1A2 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=1F26D1CF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=CF9D733E type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=4EF16396 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=7496C17B type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=3AEF97EE type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
nw_read_request_report [C2] Receive failed with error "Operation timed out"
nw_read_request_report [C2] Receive failed with error "Operation timed out"
nw_read_request_report [C2] Receive failed with error "Operation timed out"
Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x123bb6710 V:|-(7)-[TUIKeyboardContentView:0x12e346d80]   (active, names: '|':TUIKeyplaneView:0x12e30cc00 )>",
    "<NSLayoutConstraint:0x123bb6c60 V:[TUIKeyboardContentView:0x12e346d80]-(10)-|   (active, names: '|':TUIKeyplaneView:0x12e30cc00 )>",
    "<NSLayoutConstraint:0x123bb7200 V:|-(0)-[TUIKeyplaneView:0x12e30cc00]   (active, names: UIKeyboardLayoutStar Prev...:0x10b4bea00, '|':UIKeyboardLayoutStar Prev...:0x10b4bea00 )>",
    "<NSLayoutConstraint:0x123bb61c0 V:[TUIKeyplaneView:0x12e30cc00]-(0)-|   (active, names: UIKeyboardLayoutStar Prev...:0x10b4bea00, '|':UIKeyboardLayoutStar Prev...:0x10b4bea00 )>",
    "<NSLayoutConstraint:0x123bb6300 V:|-(0)-[UIKeyboardLayoutStar Prev...]   (active, names: UIKeyboardLayoutStar Prev...:0x10b4bea00, '|':UIKeyboardImpl:0x12e30c400 )>",
    "<NSLayoutConstraint:0x123bb4e10 V:[UIKeyboardLayoutStar Prev...]-(0)-|   (active, names: UIKeyboardLayoutStar Prev...:0x10b4bea00, '|':UIKeyboardImpl:0x12e30c400 )>",
    "<NSLayoutConstraint:0x12e2b7570 '_UITemporaryLayoutHeight' UIKeyboardImpl:0x12e30c400.height == 250   (active)>",
    "<NSLayoutConstraint:0x123bb6f30 'TUIKeyplane.height' TUIKeyboardContentView:0x12e346d80.height == 216   (active)>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x123bb6f30 'TUIKeyplane.height' TUIKeyboardContentView:0x12e346d80.height == 216   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
...retrieving local-only general pasteboard failed with error: Error Domain=PBErrorDomain Code=10 "Pasteboard com.apple.UIKit.pboard.general is not available at this time." UserInfo={NSLocalizedDescription=Pasteboard com.apple.UIKit.pboard.general is not available at this time.}
Message from debugger: killed