-- LLDB integration loaded --
Dart execution mode: JIT
flutter: The Dart VM service is listening on http://127.0.0.1:62521/Z5mqgJvWbfw=/
BizPluginRegistrant: registerEssentialPlugins
FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
NativeBootstrapCoordinator: native bootstrap channel created
flutter: STARTUP[main.ensure_initialized] {t_ms: 0}
flutter: STARTUP[main.run_app] {t_ms: 4}
flutter: STARTUP[ui.bootstrap.first_frame] {t_ms: 7827}
XPC connection interrupted
flutter: STARTUP[bootstrap.start] {t_ms: 7843}
flutter: STARTUP[bootstrap.dotenv.start] {t_ms: 7843}
flutter: STARTUP[bootstrap.dotenv.ok] {t_ms: 8676}
flutter: STARTUP[bootstrap.supabase.start] {t_ms: 8676}
flutter: supabase.supabase_flutter: INFO: ***** Supabase init completed *****
flutter: STARTUP[bootstrap.supabase.ok] {t_ms: 9478}
flutter: INFO: Supabase bootstrap completed
flutter: STARTUP[bootstrap.hive.start] {t_ms: 9478}
flutter: INFO: Hive.initFlutter() starting...
flutter: INFO: Hive.initFlutter() completed successfully
flutter: STARTUP[bootstrap.hive.ok] {t_ms: 10627}
flutter: INFO: Hive bootstrap completed
flutter: STARTUP[bootstrap.done] {t_ms: 10627}
flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: supabase.auth: INFO: Refresh session
flutter: supabase.auth: INFO: Refresh session
flutter: STARTUP[postframe.start] {t_ms: 15387}
flutter: STARTUP[postframe.local_services.start] {t_ms: 15387}
flutter: INFO: Hive already initialized, skipping
flutter: STARTUP[ui.router.first_frame] {t_ms: 15388, w: 393, h: 852, dpr: 3.0}
flutter: STARTUP[postframe.local_services.ok] {t_ms: 15395}
flutter: STARTUP[postframe.launch_route.start] {t_ms: 15395}
flutter: STARTUP[postframe.launch_route.ok] {t_ms: 16920}
flutter: STARTUP[postframe.push_auth_gate.setup] {t_ms: 16921}
flutter: STARTUP[postframe.push_auth_gate.skip] {t_ms: 16921, reason: ENABLE_CLOUD_PUSH=false}
flutter: STARTUP[postframe.done] {t_ms: 16922}
flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: supabase.auth: INFO: Refresh session
flutter: supabase.auth: INFO: Refresh session
flutter: supabase.auth: INFO: Refresh session
flutter: supabase.auth: INFO: Refresh session
flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
flutter: UserRepository.fetchProfile: about = "Самогоноварение"
flutter: currentUserProvider: repository returned true
flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
flutter: UserRepository.fetchProfile: about = "Самогоноварение"
flutter: currentUserProvider: repository returned true
flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
flutter: UserRepository.fetchProfile: about = "Самогоноварение"
flutter: currentUserProvider: repository returned true
flutter: STARTUP[postframe.sentry.deferred.start] {t_ms: 22618}
[SentryFlutterPlugin] Async native init disabled, starting immediately
[SentryFlutterPlugin] Async native init started
MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/5FADD295-292F-4E83-859E-9D9C852C45D0/Library/Caches)
0   Runner.debug.dylib                  0x0000000103fb48d0 MTILogOnce + 156
1   Runner.debug.dylib                  0x0000000103fb4b64 -[NSFileManager(MainThreadIOMonitor) mti_createDirectoryAtPath:withIntermediateDirectories:attributes:error:] + 140
2   Runner.debug.dylib                  0x00000001040fc220 createDirectoryIfNotExists + 112
3   Runner.debug.dylib                  0x000000010409eaec +[SentryAsyncLogWrapper initializeAsyncLogFile] + 232
4   Runner.debug.dylib                  0x000000010422e9d4 $s6Sentry0A13SDKLogSupportC9configure_15diagnosticLevelySb_AA0aF0OtFZ + 108
5   Runner.debug.dylib                  0x000000010422ea30 $s6Sentry0A13SDKLogSupportC9configure_15diagnosticLevelySb_AA0aF0OtFZTo + 76
6   Runner.debug.dylib                  0x0000000104145ec0 +[SentrySDKInternal startWithOptions:] + 340
7   Runner.debug.dylib                  0x0000000104146578 +[SentrySDKInternal startWithConfigureOptions:] + 112
8   Runner.debug.dylib                  0x0000000104226e10 $s6Sentry0A3SDKC5start16configureOptionsyySo0aE0Cc_tFZ + 176
9   Runner.debug.dylib                  0x00000001042e2b64 $s14sentry_flutter19SentryFlutterPluginC13initNativeSdk33_491F737C4EFC5E801AEAEA4C4751A42DLL_6resultySo0D10MethodCallC_yypSgctFyycfU0_ + 444
10  Runner.debug.dylib                  0x00000001042e24b4 $s14sentry_flutter19SentryFlutterPluginC13initNativeSdk33_491F737C4EFC5E801AEAEA4C4751A42DLL_6resultySo0D10MethodCallC_yypSgctF + 2140
11  Runner.debug.dylib                  0x00000001042e16d0 $s14sentry_flutter19SentryFlutterPluginC6handle_6resultySo0D10MethodCallC_yypSgctF + 256
12  Runner.debug.dylib                  0x00000001042e1c20 $s14sentry_flutter19SentryFlutterPluginC6handle_6resultySo0D10MethodCallC_yypSgctFTo + 140
13  Flutter                             0x00000001075dc440 __45-[FlutterMethodChannel setMethodCallHandler:]_block_invoke + 164
14  Flutter                             0x0000000107167378 ___ZN7flutter25PlatformMessageHandlerIos21HandlePlatformMessageENSt3_fl10unique_ptrINS_15PlatformMessageENS1_14default_deleteIS3_EEEE_block_invoke + 116
15  libdispatch.dylib                   0x000000010396863c _dispatch_call_block_and_release + 32
16  libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
17  libdispatch.dylib                   0x00000001039a34b4 _dispatch_main_queue_drain.cold.5 + 876
18  libdispatch.dylib                   0x0000000103978778 _dispatch_main_queue_drain + 180
19  libdispatch.dylib                   0x00000001039786b4 _dispatch_main_queue_callback_4CF + 44
20  CoreFoundation                      0x000000018730b2b4 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 434868
21  CoreFoundation                      0x00000001872beb3c 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 121660
22  CoreFoundation                      0x00000001872bda6c 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 117356
23  GraphicsServices                    0x0000000228eec498 GSEventRunModal + 120
24  UIKitCore                           0x000000018cc96df8 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 646648
25  UIKitCore                           0x000000018cc3fe54 UIApplicationMain + 336
26  Runner.debug.dylib                  0x0000000103fb4060 __debug_main_executable_dylib_entry_point + 96
27  dyld                                0x00000001842aae28 A4040D49-9446-38E5-842B-EB8F9C971C22 + 20008
[Sentry] [warning] [1768819022.542643] [SentryFileManager:972] No data found at /var/mobile/Containers/Data/Application/5FADD295-292F-4E83-859E-9D9C852C45D0/Library/Caches/io.sentry/804a8cb284b96249456d4baf749f096ecda63106/session.current
flutter: STARTUP[postframe.sentry.deferred.ok] {t_ms: 24373}
<0x105619a40> Gesture: System gesture gate timed out.
flutter: CHIPS http_status=200
flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
<0x105619a40> Gesture: System gesture gate timed out.
MainThreadIOMonitor: -[NSData initWithContentsOfFile:options:error:] (/AppleInternal/Library/Assistant/InternalConfig.plist)
0   Runner.debug.dylib                  0x0000000103fb48d0 MTILogOnce + 156
1   Runner.debug.dylib                  0x0000000103fb472c -[NSData(MainThreadIOMonitor) mti_initWithContentsOfFile:options:error:] + 120
2   Foundation                          0x0000000185212cc4 DF782AC5-CC02-358C-A2F7-149703F5F44A + 9596100
3   Foundation                          0x0000000185212bc4 DF782AC5-CC02-358C-A2F7-149703F5F44A + 9595844
4   AssistantServices                   0x00000001954fbaac 53C47C6B-3CD4-3BFF-BECF-E7042A29643F + 15020
5   libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
6   libdispatch.dylib                   0x000000010396b790 _dispatch_once_callout + 140
7   AssistantServices                   0x00000001954fba60 AFInternalConfigValueForKey + 120
8   AssistantServices                   0x00000001954fb71c 53C47C6B-3CD4-3BFF-BECF-E7042A29643F + 14108
9   libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
10  libdispatch.dylib                   0x000000010396b790 _dispatch_once_callout + 140
11  AssistantServices                   0x00000001954fb894 AFPreferencesSupportedLanguages + 72
12  AssistantServices                   0x00000001954fb678 53C47C6B-3CD4-3BFF-BECF-E7042A29643F + 13944
13  libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
14  libdispatch.dylib                   0x000000010396b790 _dispatch_once_callout + 140
15  AssistantServices                   0x00000001954fb658 AFPreferencesSupportedDictationLanguages + 72
16  AssistantServices                   0x00000001954fb5dc 53C47C6B-3CD4-3BFF-BECF-E7042A29643F + 13788
17  libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
18  libdispatch.dylib                   0x000000010396b790 _dispatch_once_callout + 140
19  AssistantServices                   0x00000001954fb5a8 AFPreferencesLanguageIsSupportedForDictation + 116
20  AssistantServices                   0x00000001955adfd0 53C47C6B-3CD4-3BFF-BECF-E7042A29643F + 745424
21  UIKitCore                           0x000000018dd32c50 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 18062416
22  UIKitCore                           0x000000018dd405d0 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 18118096
23  UIKitCore                           0x000000018cf0af30 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 3219248
24  UIKitCore                           0x000000018de36c04 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 19127300
25  UIKitCore                           0x000000018cf63570 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 3581296
26  CoreFoundation                      0x00000001872b5f78 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 85880
27  CoreFoundation                      0x0000000187422c68 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 1580136
28  UIKitCore                           0x000000018cf64948 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 3586376
29  UIKitCore                           0x000000018ddca3f4 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 18682868
30  UIKitCore                           0x000000018e13c1b8 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 22294968
31  UIKitCore                           0x000000018ddbfb5c 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 18639708
32  UIKitCore                           0x000000018de4c750 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 19216208
33  UIKitCore                           0x000000018e58de10 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 26824208
34  UIKitCore                           0x000000018de4c544 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 19215684
35  UIKitCore                           0x000000018de54dac 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 19250604
36  UIKitCore                           0x000000018d9ffecc 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14708428
37  UIKitCore                           0x000000018d9fea04 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14703108
38  UIKitCore                           0x000000018d9fe438 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14701624
39  UIKitCore                           0x000000018d9ff4f0 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14705904
40  UIKitCore                           0x000000018d9ff554 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14706004
41  UIKitCore                           0x000000018d9fc96c 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 14694764
42  UIKitCore                           0x000000018de22fc8 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 19046344
43  libdispatch.dylib                   0x00000001039822e0 _dispatch_client_callout + 16
44  libdispatch.dylib                   0x000000010396c0d8 _dispatch_continuation_pop + 672
45  libdispatch.dylib                   0x000000010398218c _dispatch_source_latch_and_call + 448
46  libdispatch.dylib                   0x0000000103980cd4 _dispatch_source_invoke + 872
47  libdispatch.dylib                   0x00000001039a3398 _dispatch_main_queue_drain.cold.5 + 592
48  libdispatch.dylib                   0x0000000103978778 _dispatch_main_queue_drain + 180
49  libdispatch.dylib                   0x00000001039786b4 _dispatch_main_queue_callback_4CF + 44
50  CoreFoundation                      0x000000018730b2b4 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 434868
51  CoreFoundation                      0x00000001872beb3c 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 121660
52  CoreFoundation                      0x00000001872bda6c 0BE54DBE-1ADC-3588-BFFA-E7C99E8D8208 + 117356
53  GraphicsServices                    0x0000000228eec498 GSEventRunModal + 120
54  UIKitCore                           0x000000018cc96df8 6519DAFB-3D75-3374-9276-10E7CE4F4DC5 + 646648
55  UIKitCore                           0x000000018cc3fe54 UIApplicationMain + 336
56  Runner.debug.dylib                  0x0000000103fb4060 __debug_main_executable_dylib_entry_point + 96
57  dyld                                0x00000001842aae28 A4040D49-9446-38E5-842B-EB8F9C971C22 + 20008
containerToPush is nil, will not push anything to candidate receiver for request token: 94711EEA
<0x105619a40> Gesture: System gesture gate timed out.
flutter: 🔧 DEBUG: sendMessageWithRAG начался
flutter: 🔧 DEBUG: session.user.id = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: 🔧 DEBUG: chatId = null
flutter: CHIPS http_status=200
flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: 🔧 DEBUG: sendMessageWithRAG начался
flutter: 🔧 DEBUG: session.user.id = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: 🔧 DEBUG: chatId = null
flutter: CHIPS http_status=200
flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: LEO_DIALOG popInvoked didPop=true result=null allowPop=true caseMode=false
flutter: LEO_DIALOG dispose caseMode=false chatId=null
<<<< FigApplicationStateMonitor >>>> signalled err=-19431 at <>:474
<<<< FigApplicationStateMonitor >>>> signalled err=-19431 at <>:474
<<<< PlayerRemoteXPC >>>> signalled err=-12860 at <>:1525
<<<< PlayerRemoteXPC >>>> signalled err=-12860 at <>:1525
flutter: CHIPS http_status=200
flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
Could not find cached accumulator for token=F5660E79 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=8A8A6199 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=2BE4AA71 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=FA14B04C type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=7B36D397 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=A9C027F7 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=8BC86789 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=3A6D7022 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=A6A88196 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=005F82B0 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=C296293A type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=F174BD5B type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=2CE0CCE3 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=9DAF2200 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=94E158D3 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=CE39FB4E type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=4E0C6126 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=1D34C808 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=1AA493A1 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=93AFB51D type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=D8B48CFF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=9B8E86B1 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=4669A021 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=C9286830 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=0EB60825 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=73BB43AF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=5BBDB7B5 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=A9A7FA81 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=7890148F type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=E651C758 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=CEEB54F4 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=4873C892 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
Could not find cached accumulator for token=E6777373 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
flutter: 🔧 DEBUG: sendMessageWithRAG начался
flutter: 🔧 DEBUG: session.user.id = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
flutter: 🔧 DEBUG: chatId = null
flutter: CHIPS http_status=200
flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]