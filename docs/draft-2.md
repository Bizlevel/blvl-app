-- LLDB integration loaded --
FirebaseEarlyInit: +load invoked before constructors
FirebaseEarlyInit(load): call stack at first configure attempt:
0   Runner.debug.dylib                  0x0000000103fdc304 FirebaseEarlyInitLogCallStackOnce + 84
1   Runner.debug.dylib                  0x0000000103fdc078 ConfigureFirebaseOnObjCIfNeeded + 60
2   Runner.debug.dylib                  0x0000000103fdc230 +[FirebaseEarlyInitSentinel load] + 60
3   libobjc.A.dylib                     0x000000018307deb0 AF9349A3-834F-369E-ACE5-C50571C9C7BA + 122544
4   dyld                                0x0000000183105448 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 144456
5   dyld                                0x000000018310623c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 148028
6   dyld                                0x00000001831061e8 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 147944
7   dyld                                0x0000000183106044 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 147524
8   dyld                                0x0000000183105f3c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 147260
9   dyld                                0x0000000183103fe8 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 139240
10  dyld                                0x00000001830f785c EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 88156
11  dyld                                0x00000001830e6dd8 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 19928
FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer
FirebaseEarlyInit(constructor0): FIRApp already configured before ObjC hook
FirebaseEarlyInit: configuring Firebase before UIApplicationMain
FirebaseEarlyInit(constructor_default): FIRApp already configured before ObjC hook
AppDelegate: FIRApp was already configured before configureFirebaseBeforeMain()
AppDelegate: App Check uses DeviceCheck provider
AppDelegate: Firebase configured before UIApplicationMain (debugProvider=OFF)
AppDelegate: iOS FCM enabled=YES
Dart execution mode: JIT
flutter: The Dart VM service is listening on http://127.0.0.1:64562/cHLjcCYLWnc=/
BizPluginRegistrant: registerEssentialPlugins
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
NativeBootstrapCoordinator: native bootstrap channel created
StoreKit2Bridge: channels installed
NativeBootstrapCoordinator: StoreKit2Bridge installed on Flutter controller
flutter: INFO: Firebase bootstrap deferred to post-frame stage
flutter: supabase.supabase_flutter: INFO: ***** Supabase init completed *****
[SentryFlutterPlugin] Async native init scheduled in 0.00 s
[SentryFlutterPlugin] Async native init started
flutter: currentUserProvider: auth session = true, user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: querying users table for 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: supabase.auth: INFO: Refresh session
flutter: INFO: Firebase.initializeApp() completed (post_frame_bootstrap)
flutter: currentUserProvider: auth session = true, user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: querying users table for 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: REMINDER_PREFS[cloud_fetch_start] {source: prefetch}
flutter: UserRepository.fetchProfile: raw response: {id: 4e46bca3-e742-4bb4-bc97-1e5832d753a3, name: Ерлан А, email: deus2111@gmail.com, about: Булочки пеку., goal: Круасаны по рецепту бабушки научиться делать., business_area: Пекарни, experience_level: 10 лет, onboarding_completed: true, current_level: 11, avatar_id: 5, business_size: 5-50 сотрудников, key_challenges: [Команда, Масштабирование], learning_style: Практические примеры, business_region: Казахстан}
flutter: UserRepository.fetchProfile: loaded user 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: goal = "Круасаны по рецепту бабушки научиться делать."
flutter: UserRepository.fetchProfile: about = "Булочки пеку."
flutter: currentUserProvider: repository returned true
flutter: REMINDER_PREFS[cloud_fetch_empty] {source: prefetch}
flutter: UserRepository.fetchProfile: raw response: {id: 4e46bca3-e742-4bb4-bc97-1e5832d753a3, name: Ерлан А, email: deus2111@gmail.com, about: Булочки пеку., goal: Круасаны по рецепту бабушки научиться делать., business_area: Пекарни, experience_level: 10 лет, onboarding_completed: true, current_level: 11, avatar_id: 5, business_size: 5-50 сотрудников, key_challenges: [Команда, Масштабирование], learning_style: Практические примеры, business_region: Казахстан}
flutter: UserRepository.fetchProfile: loaded user 4e46bca3-e742-4bb4-bc97-1e5832d753a3
flutter: UserRepository.fetchProfile: goal = "Круасаны по рецепту бабушки научиться делать."
flutter: UserRepository.fetchProfile: about = "Булочки пеку."
flutter: currentUserProvider: repository returned true
flutter: ProfileScreen: authState session = true
flutter: ProfileScreen: user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3, onboardingCompleted = true
flutter: ProfileScreen: authState session = true
flutter: ProfileScreen: user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3, onboardingCompleted = true
MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/0A091418-1DCE-444F-899B-9AF383F4E47F/Library/Saved Application State/bizlevel.kz.savedState)
0   Runner.debug.dylib                  0x0000000103fdcce4 MTILogOnce + 156
1   Runner.debug.dylib                  0x0000000103fdcf78 -[NSFileManager(MainThreadIOMonitor) mti_createDirectoryAtPath:withIntermediateDirectories:attributes:error:] + 140
2   Foundation                          0x00000001837bcc28 218DA4DC-727A-3341-B59E-8FDB39A2D7C4 + 609320
3   Foundation                          0x00000001837bf204 218DA4DC-727A-3341-B59E-8FDB39A2D7C4 + 619012
4   UIKitCore                           0x000000018ce2e97c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 21207420
5   UIKitCore                           0x000000018bda0c00 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 3849216
6   UIKitCore                           0x000000018bd9fc94 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 3845268
7   UIKitCore                           0x000000018c41a820 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10639392
8   UIKitCore                           0x000000018bacda58 _UIScenePerformActionsWithLifecycleActionMask + 112
9   UIKitCore                           0x000000018c41a540 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10638656
10  UIKitCore                           0x000000018c41a04c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10637388
11  UIKitCore                           0x000000018c41a358 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10638168
12  UIKitCore                           0x000000018c419de4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10636772
13  UIKitCore                           0x000000018c425264 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10682980
14  UIKitCore                           0x000000018c896af8 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 15342328
15  UIKitCore                           0x000000018bace870 _UISceneSettingsDiffActionPerformChangesWithTransitionContextAndCompletion + 224
16  UIKitCore                           0x000000018c424f60 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 10682208
17  UIKitCore                           0x000000018c2642d8 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 8843992
18  UIKitCore                           0x000000018c26336c A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 8840044
19  UIKitCore                           0x000000018c263f44 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 8843076
20  UIKitCore                           0x000000018c8bfc60 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 15510624
21  FrontBoardServices                  0x00000001a5da6bd4 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 130004
22  FrontBoardServices                  0x00000001a5da584c 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 125004
23  FrontBoardServices                  0x00000001a5da6884 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 129156
24  FrontBoardServices                  0x00000001a5e169c8 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 588232
25  FrontBoardServices                  0x00000001a5dd2ad8 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 309976
26  FrontBoardServices                  0x00000001a5db2f0c 97BBB5BC-AF24-3231-BF5E-3E28DB22D4A6 + 179980
27  libdispatch.dylib                   0x00000001033fe2d0 _dispatch_client_callout + 16
28  libdispatch.dylib                   0x00000001033e8998 _dispatch_block_invoke_direct + 296
29  BoardServices                       0x000000019d7f61d4 B63514F9-371F-33F0-83CC-23FB457ADF2D + 37332
30  BoardServices                       0x000000019d7f6054 B63514F9-371F-33F0-83CC-23FB457ADF2D + 36948
31  CoreFoundation                      0x000000018611af24 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 429860
32  CoreFoundation                      0x000000018611ae98 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 429720
33  CoreFoundation                      0x00000001860f8acc B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 289484
34  CoreFoundation                      0x00000001860cf6d8 B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 120536
35  CoreFoundation                      0x00000001860cea6c B4A0233B-F37D-3EF6-A977-E4F36199C5A4 + 117356
36  GraphicsServices                    0x0000000226cf8498 GSEventRunModal + 120
37  UIKitCore                           0x000000018ba92ba4 A0E1CEFB-FD01-36F9-B823-51B092E4DBC6 + 646052
38  UIKitCore                           0x000000018ba3ba78 UIApplicationMain + 336
39  Runner.debug.dylib                  0x0000000103fdc428 __debug_main_executable_dylib_entry_point + 116
40  dyld                                0x00000001830e6e28 EF27E386-3CFF-3752-B152-D96A0AA9EFFD + 20008