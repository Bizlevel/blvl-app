default	11:16:21.108031+0500	Runner	[ {"framework": "Photos", "swizzle":[ {"class":"PHAsset", "methods": { "prefixes":["fetch","enumerate"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread"], "performance issue type":["hang"] }, {"class":"PHFetchResult", "methods": { "prefixes":["fetch","enumerate"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread"], "performance issue type":["hang"] } ] }, {"framework": "CoreLocation", "swizzle":[ {"class":"CLLocationManager", "instance methods": { "names":["authorizationStatus", "monitoredRegions", "accuracyAuthorization"] }, "class methods": { "names":["locationServicesEnabled"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreImage", "swizzle":[ {"class":"CIContext", "instance methods": { "names":["createCGImage:fromRect:", "initWithOptions:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"HealthKit", "swizzle":[ {"class":"HKHealthStore", "instance methods": { "names":["authorizationStatusForType:"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreData", "swizzle":[ {"class":"NSManagedObjectContext", "instance methods": { "names":["performBlockAndWait:", "executeFetchRequest:error:", "mergeChangesFromContextDidSaveNotification:","save:", "countForFetchRequest:error:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["Database access on main thread", "Database access on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreML", "swizzle":[ {"class":"MLModel", "class methods": { "names":["modelWithContentsOfURL:error:"] }, "duplicate detection type":"AllFrames", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"Foundation", "swizzle":[ {"class":"NSOperation", "instance methods": { "names":["waitUntilFinished", "waitUntilFinishedOrTimeout:"] }, "duplicate detection type":"AllFrames", "antipattern type":["waiting for operation completion on main thread", "waiting for operation completion on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSThread", "class methods": { "names":["sleepForTimeInterval:"] }, "duplicate detection type":"AllFrames", "antipattern type":["Sleep", "Sleep"], "performance issue type":["hang", "launch"] }, {"class":"NSBundle", "instance methods": { "names":["bundlePath", "bundleIdentifier", "loadAndReturnError:"] }, "class methods": { "names":["bundleWithIdentifier:", "allFrameworks", "allBundles", "pathForResource:ofType:inDirectory:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSKeyedArchiver", "class methods": { "names":["archivedDataWithRootObject:", "archivedDataWithRootObject:requiringSecureCoding:error:", "archiveRootObject:toFile:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSKeyedUnarchiver", "class methods": { "names":["unarchiveTopLevelObjectWithData:error:", "decodeObjectForKey:", "unarchiveObjectWithData:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSFileManager", "methods": { "prefixes":["remove", "create", "move", "copy"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "Excessive IO on any thread", "IO on main thread"], "performance issue type":["hang", "disk write", "launch"] }, {"class":"NSFileManager", "instance methods": { "names":["synchronouslyGetFileProviderServicesForItemAtURL:completionHandler:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSData", "methods": { "prefixes":["initWithContents", "dataWithContents"] }, "instance methods": { "names":["enumerateByteRangesUsingBlock:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"AVFCore", "swizzle":[ {"class":"AVAsset", "class methods": { "names":["assetWithURL:"] }, "duplicate detection type":"NonSystemFramesOnly", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVAsset", "instance methods": { "names":["mediaSelectionGroupForMediaCharacteristic:"] }, "duplicate detection type":"AllFrames", "antipattern type":["Conditional waiting on main thread", "Conditional waiting on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVAsset", "instance methods": { "names":["tracksWithMediaType:"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVURLAsset", "instance methods": { "names":["tracks"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"AVFAudio", "swizzle":[ {"class":"AVAudioSession", "instance methods": { "names":["setActive:withOptions:error:", "category", "setCategory:mode:options:error:", "setCategory:mode:routeSharingPolicy:options:error:", "setCategory:withOptions:error:", "setCategory:error:", "currentRoute", "outputVolume", "setAllowHapticsAndSystemSoundsDuringRecording:error:", "isPiPAvailable"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"StoreKit", "swizzle":[ {"class":"SKPaymentQueue", "class methods": { "names":["canMakePayments"] }, "duplicate detection type":"AllFrames", "antipattern type":["Semaphore on main thread", "Semaphore on main thread"], "performance issue type":["hang", "launch"] }, {"class":"SKPaymentQueue", "instance methods": { "names":["storefront"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreTelephony", "swizzle":[ {"class":"CTCellularPlanProvisioning", "instance methods": { "names":["supportsCellularPlan"] }, "duplicate detection type":"AllFrames", "antipattern type":["Semaphore on main thread", "Semaphore on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"Vision", "swizzle":[ {"class":"VNImageRequestHandler", "methods": { "prefixes":["performRequest"] }, "duplicate detection type":"AllFrames", "antipattern type":["Computer vision tasks on main thread", "Computer vision tasks on main thread"], "performance issue type":["hang", "launch"] } ] } ]
default	11:16:21.123219+0500	Runner	FirebaseEarlyInit: +load invoked before constructors
default	11:16:21.129014+0500	Runner	FirebaseEarlyInit(load): call stack at first configure attempt:
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
default	11:16:21.130970+0500	Runner	[0x1039ec1c0] activating connection: mach=true listener=false peer=false name=com.apple.cfprefsd.daemon.system
default	11:16:21.131052+0500	Runner	[0x1039ec300] activating connection: mach=true listener=false peer=false name=com.apple.cfprefsd.daemon
default	11:16:21.217911+0500	Runner	FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer
default	11:16:21.220140+0500	Runner	FirebaseEarlyInit(constructor0): FIRApp already configured before ObjC hook
default	11:16:21.220182+0500	Runner	FirebaseEarlyInit: configuring Firebase before UIApplicationMain
default	11:16:21.220201+0500	Runner	FirebaseEarlyInit(constructor_default): FIRApp already configured before ObjC hook
default	11:16:21.220288+0500	Runner	AppDelegate: FIRApp was already configured before configureFirebaseBeforeMain()
default	11:16:21.220350+0500	Runner	AppDelegate: App Check uses DeviceCheck provider
default	11:16:21.220410+0500	Runner	AppDelegate: Firebase configured before UIApplicationMain (debugProvider=OFF)
default	11:16:21.220453+0500	Runner	AppDelegate: iOS FCM enabled=YES
default	11:16:21.261151+0500	Runner	[C:1] Alloc com.apple.frontboard.systemappservices
default	11:16:21.261181+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:16:21.261185+0500	Runner	Creating new background assertion
default	11:16:21.261210+0500	Runner	[0x105670000] activating connection: mach=false listener=false peer=false name=(anonymous)
default	11:16:21.261229+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:21.261270+0500	Runner	Initializing connection
default	11:16:21.261306+0500	Runner	Removing all cached process handles
default	11:16:21.261385+0500	Runner	Creating connection to com.apple.runningboard
default	11:16:21.261396+0500	Runner	Sending handshake request attempt #1 to server
default	11:16:21.261425+0500	Runner	[0x105670140] activating connection: mach=true listener=false peer=false name=com.apple.runningboard
default	11:16:21.261544+0500	Runner	Handshake succeeded
default	11:16:21.261584+0500	Runner	Identity resolved as app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>
default	11:16:21.261692+0500	Runner	Cache loaded with 6210 pre-cached in CacheData and 80 items in CacheExtra.
default	11:16:21.850696+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:21.850703+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x1055dcec0>: taskID = 1, taskName = Launch Background Task for Coalescing, creationTime = 923288 (elapsed = 0).
default	11:16:21.850716+0500	Runner	Realizing settings extension _UIApplicationSceneKeyboardSettings on FBSSceneSettings
default	11:16:21.850791+0500	Runner	Realizing settings extension <_UISceneOcclusionSettings> on FBSSceneSettings
default	11:16:21.850877+0500	Runner	Realizing settings extension <_UISceneInterfaceProtectionSettings> on FBSSceneSettings
default	11:16:21.850914+0500	Runner	Realizing settings extension _UISceneLayoutPreferencesHostSettingsExtension on FBSSceneSettings
default	11:16:21.850955+0500	Runner	Realizing settings extension _UISceneSafeAreaSettingsExtension on FBSSceneSettings
default	11:16:21.850963+0500	Runner	Deactivation reason added: 10; deactivation reasons: 0 -> 1024; animating application lifecycle event: 0
default	11:16:21.851016+0500	Runner	activating monitor for service com.apple.frontboard.open
default	11:16:21.851041+0500	Runner	Realizing settings extension _UISceneLayoutPreferenceClientSettingsExtension on FBSSceneClientSettings
default	11:16:21.851052+0500	Runner	activating monitor for service com.apple.frontboard.workspace-service
default	11:16:21.851106+0500	Runner	FBSWorkspace registering source: com.apple.frontboard.systemappservices
default	11:16:21.851304+0500	Runner	Realizing settings extension <_UIHomeAffordanceHostSceneSettings> on FBSSceneSettings
default	11:16:21.851339+0500	Runner	Realizing settings extension _UISystemShellSceneHostingEnvironmentSettings on FBSSceneSettings
default	11:16:21.851386+0500	Runner	Realizing settings extension _UISceneRenderingEnvironmentSettings on FBSSceneSettings
default	11:16:21.851404+0500	Runner	FBSWorkspace connected to endpoint : <BSServiceConnectionEndpoint: 0x1056e0880; target: com.apple.frontboard.systemappservices; service: com.apple.frontboard.workspace-service>
default	11:16:21.851497+0500	Runner	<FBSWorkspaceScenesClient:0x10560ada0 com.apple.frontboard.systemappservices> attempting immediate handshake from activate
default	11:16:21.851514+0500	Runner	<FBSWorkspaceScenesClient:0x10560ada0 com.apple.frontboard.systemappservices> sent handshake
default	11:16:21.851540+0500	Runner	Realizing settings extension <_UISceneRenderingEnvironmentClientSettings> on FBSSceneClientSettings
default	11:16:21.851922+0500	Runner	Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x1056e0f00>
default	11:16:21.851934+0500	Runner	Realizing settings extension <_UISceneTransitioningHostSettings> on FBSSceneSettings
default	11:16:21.852026+0500	Runner	Realizing settings extension <_UISceneFocusSystemSettings> on FBSSceneSettings
default	11:16:21.852051+0500	Runner	Evaluated capturing state as 0 on <UIScreen: 0x105670780> for initial
default	11:16:21.852056+0500	Runner	Realizing settings extension _UISceneOrientationSettingsExtension on FBSSceneSettings
default	11:16:21.852097+0500	Runner	Evaluated capturing state as 0 on <UIScreen: 0x105670780> for CADisplay KVO
default	11:16:21.852253+0500	Runner	Realizing settings extension _UISceneOrientationClientSettingsExtension on FBSSceneClientSettings
default	11:16:21.852279+0500	Runner	Realizing settings extension _UISceneWindowingControlClientSettings on FBSSceneClientSettings
default	11:16:21.852351+0500	Runner	Realizing settings extension <_UISceneHostingContentSizePreferenceClientSettings> on FBSSceneClientSettings
default	11:16:21.852489+0500	Runner	Read CategoryName: per-app = 1, category name = (null)
default	11:16:21.852504+0500	Runner	Realizing settings extension _UISceneHostingTraitCollectionPropagationSettings on FBSSceneSettings
default	11:16:21.852567+0500	Runner	Read CategoryName: per-app = 0, category name = (null)
default	11:16:21.852607+0500	Runner	Realizing settings extension <_UISceneHostingSheetPresentationSettings> on FBSSceneSettings
default	11:16:21.852634+0500	Runner	Realizing settings extension <_UISceneHostingSheetPresentationClientSettings> on FBSSceneClientSettings
default	11:16:21.852705+0500	Runner	Realizing settings extension <_UISceneHostingEventDeferringSettings> on FBSSceneSettings
default	11:16:21.852845+0500	Runner	Realizing settings extension <UIKit__UITypedKeyValueSceneSettings> on FBSSceneSettings
default	11:16:21.852869+0500	Runner	Realizing settings extension <UIKit__UITypedKeyValueSceneSettings> on FBSSceneClientSettings
default	11:16:21.852890+0500	Runner	Realizing settings extension <_UISceneHostingViewControllerPreferencePropagationClientSettings> on FBSSceneClientSettings
default	11:16:21.852921+0500	Runner	Realizing settings extension <_UISceneZoomTransitionSettings> on FBSSceneSettings
default	11:16:21.852961+0500	Runner	Realizing settings extension FBSSceneSettingsCore on FBSSceneSettings
fault	11:16:21.852982+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 14 0A 90 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 14 09 90 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C EC 9D 06 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 60 9D 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A4 9C 06 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 58 9C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 04 16 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 40 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 42 00 00 AF 93 49 A3 83 4F 36 9E AC E5 C5 05 71 C9 C7 BA B0 DE 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 48 34 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 42 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 41 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 44 40 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 3F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 1F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 5C 58 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:21.853334+0500	Runner	Realizing settings extension FBSSceneClientSettingsCore on FBSSceneClientSettings
fault	11:16:21.855753+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 14 0A 90 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 14 09 90 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C EC 9D 06 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 60 9D 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A4 9C 06 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 58 9C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 04 16 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 40 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 42 00 00 AF 93 49 A3 83 4F 36 9E AC E5 C5 05 71 C9 C7 BA B0 DE 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 48 34 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 42 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 41 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 44 40 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 3F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 1F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 5C 58 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:21.855896+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 59 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 39 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A0 2C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 29 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C E0 1C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 0C 17 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 16 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 40 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 42 00 00 AF 93 49 A3 83 4F 36 9E AC E5 C5 05 71 C9 C7 BA B0 DE 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 48 34 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 42 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 41 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 44 40 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 3F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 1F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 5C 58 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:21.855952+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 59 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 39 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A0 2C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 29 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C E0 1C 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 0C 17 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 16 06 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 40 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 42 00 00 AF 93 49 A3 83 4F 36 9E AC E5 C5 05 71 C9 C7 BA B0 DE 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 48 34 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 42 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 41 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 44 40 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 3C 3F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD E8 1F 02 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 5C 58 01 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:21.855972+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'4D 21 AE 11 C4 E1 33 A6 8F 11 63 BA 02 CB D1 00 EC 51 00 00 4D 21 AE 11 C4 E1 33 A6 8F 11 63 BA 02 CB D1 00 68 48 00 00 4D 21 AE 11 C4 E1 33 A6 8F 11 63 BA 02 CB D1 00 5C 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:22.080833+0500	Runner	nw_path_evaluator_start [1FC95D70-A5E8-43C8-A5B8-01EA983CBF3D <NULL> generic, attribution: developer]
	path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:22.080936+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x1057fe340>
default	11:16:22.080954+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.080966+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.080980+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 3, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 0).
default	11:16:22.081238+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 3
default	11:16:22.081259+0500	Runner	Ending task with identifier 3 and description: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 3, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x1057fe340>
default	11:16:22.081274+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x1057fe580>
default	11:16:22.081293+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105664190> (used by background task with identifier 3: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 3, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 0))
default	11:16:22.081305+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.082483+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.082967+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 4, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 0).
default	11:16:22.150511+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 4
default	11:16:22.150598+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x1057fe340>
default	11:16:22.150657+0500	Runner	Ending task with identifier 4 and description: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 4, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 1), _expireHandler: <__NSMallocBlock__: 0x1057fe2c0>
default	11:16:22.150873+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105664190> (used by background task with identifier 4: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 4, taskName = GDTCCTUploader-upload, creationTime = 923288 (elapsed = 1))
default	11:16:22.150907+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.150926+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.150940+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 5, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0).
default	11:16:22.153589+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 2
default	11:16:22.153651+0500	Runner	Ending task with identifier 2 and description: <_UIBackgroundTaskInfo: 0x10571a380>: taskID = 2, taskName = Persistent SceneSession Map Update, creationTime = 923288 (elapsed = 1), _expireHandler: <__NSGlobalBlock__: 0x1f2ad6308>
default	11:16:22.153788+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105664190> (used by background task with identifier 2: <_UIBackgroundTaskInfo: 0x10571a380>: taskID = 2, taskName = Persistent SceneSession Map Update, creationTime = 923288 (elapsed = 1))
default	11:16:22.153804+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 5
default	11:16:22.153848+0500	Runner	Ending task with identifier 5 and description: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 5, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x1057fe580>
default	11:16:22.153935+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105664190> (used by background task with identifier 5: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 5, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0))
default	11:16:22.154000+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x1057fe380>
default	11:16:22.154052+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.154107+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105664190>
default	11:16:22.154139+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 6, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0).
default	11:16:22.156826+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 6
default	11:16:22.156896+0500	Runner	Ending task with identifier 6 and description: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 6, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x1057fe380>
default	11:16:22.157042+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105664190> (used by background task with identifier 6: <_UIBackgroundTaskInfo: 0x10571b000>: taskID = 6, taskName = GDTCCTUploader-upload, creationTime = 923289 (elapsed = 0))
default	11:16:22.795160+0500	Runner	[0x1056721c0] activating connection: mach=true listener=false peer=false name=com.apple.analyticsd
default	11:16:22.948195+0500	Runner	Received configuration update from daemon (initial)
default	11:16:22.949840+0500	Runner	[0x105672440] activating connection: mach=true listener=false peer=false name=com.apple.fontservicesd
fault	11:16:23.906728+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 6C B1 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B0 73 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 6D 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 72 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 64 00 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B4 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:23.906851+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 6C B1 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B0 73 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 6D 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 72 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 64 00 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B4 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:23.907033+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfURL:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 1C 0A 90 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 50 09 90 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 DC 6D 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 72 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 64 00 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B4 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:23.907433+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfURL:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 1C 0A 90 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 50 09 90 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 DC 6D 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 72 22 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 64 00 0A 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 B4 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:23.907578+0500	Runner	flutter: The Dart VM service is listening on http://127.0.0.1:64562/cHLjcCYLWnc=/
fault	11:16:23.909497+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 9F 87 C6 16 7A FD 3E DC B5 B0 92 BA 55 23 A7 AF 1C 13 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 9F 87 C6 16 7A FD 3E DC B5 B0 92 BA 55 23 A7 AF 4C 12 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D0 82 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 85 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 F8 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:23.909763+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 9F 87 C6 16 7A FD 3E DC B5 B0 92 BA 55 23 A7 AF 1C 13 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 9F 87 C6 16 7A FD 3E DC B5 B0 92 BA 55 23 A7 AF 4C 12 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D0 82 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 85 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 F8 2F 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 9C 45 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C0 85 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 C4 4C A2 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 20 F6 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 80 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
error	11:16:24.472661+0500	Runner	FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
default	11:16:24.472776+0500	Runner	NativeBootstrapCoordinator: native bootstrap channel created
default	11:16:24.472795+0500	Runner	NativeBootstrapCoordinator: StoreKit2Bridge installed on Flutter controller
default	11:16:24.473952+0500	Runner	<UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34) Scene updated orientation preferences: none -> ( Pu Ll Lr )
default	11:16:24.473969+0500	Runner	Key window API is scene-level: YES
default	11:16:24.473980+0500	Runner	UIWindowScene: 0x105774200: Window became key in scene: UIWindow: 0x105648000; contextId: 0x3C6DE330: reason: UIWindowScene: 0x105774200: Window requested to become key in scene: 0x105648000
default	11:16:24.473993+0500	Runner	Key window needs update: 1; currentKeyWindowScene: 0x0; evaluatedKeyWindowScene: 0x105774200; currentApplicationKeyWindow: 0x0; evaluatedApplicationKeyWindow: 0x105648000; reason: UIWindowScene: 0x105774200: Window requested to become key in scene: 0x105648000
default	11:16:24.474003+0500	Runner	Window did become application key: UIWindow: 0x105648000; contextId: 0x3C6DE330; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	11:16:24.474014+0500	Runner	[0x105738a80] Begin local event deferring requested for token: 0x105472fa0; environments: 1; reason: UIWindowScene: 0x105774200: Begin event deferring in keyboardFocus for window: 0x105648000
default	11:16:24.474095+0500	Runner	BKSHIDEventDeliveryManager - connection activation
default	11:16:24.474117+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:16:24.474142+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:16:24.474159+0500	Runner	Ignoring already applied deactivation reason: 5; deactivation reasons: 2080
default	11:16:24.474183+0500	Runner	Deactivation reason added: 12; deactivation reasons: 2080 -> 6176; animating application lifecycle event: 1
fault	11:16:24.474576+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 1C 88 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 63 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:24.475106+0500	Runner	Deactivation reason removed: 11; deactivation reasons: 6176 -> 4128; animating application lifecycle event: 1
default	11:16:24.475217+0500	Runner	Realizing settings extension <_UISceneIntelligenceSupportSettings> on FBSSceneSettings
default	11:16:24.476903+0500	Runner	establishing connection to agent
default	11:16:24.477473+0500	Runner	[0x110095cc0] Session created.
default	11:16:24.477494+0500	Runner	[0x110095cc0] Session created from connection [0x11e2a4280]
default	11:16:24.477566+0500	Runner	[0x11e2a4280] activating connection: mach=true listener=false peer=false name=com.apple.uiintelligencesupport.agent
default	11:16:24.477775+0500	Runner	[0x110095cc0] Session activated
default	11:16:24.477834+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:16:24.477875+0500	Runner	Will add backgroundTask with taskName: Persistent SceneSession Map Update, expirationHandler: <__NSGlobalBlock__: 0x1f2ad6308>
default	11:16:24.477883+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:16:24.477890+0500	Runner	Creating new background assertion
default	11:16:24.477900+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x110095f90>
default	11:16:24.477986+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x110095f90>
default	11:16:24.477994+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x105719940>: taskID = 7, taskName = Persistent SceneSession Map Update, creationTime = 923291 (elapsed = 0).
fault	11:16:24.478959+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 1C 88 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 63 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:24.479012+0500	Runner	Create activity from XPC object <nw_activity 50:1 [B78ACF73-CEC7-435A-A9B6-1F8AAA3F1B6E] (reporting strategy default)>
default	11:16:24.479018+0500	Runner	Create activity from XPC object <nw_activity 50:2 [F91A3C7D-F4C8-435A-A116-68925B7A3FFF] (reporting strategy default)>
default	11:16:24.479034+0500	Runner	Set activity <nw_activity 50:1 [B78ACF73-CEC7-435A-A9B6-1F8AAA3F1B6E] (reporting strategy default)> as the global parent
default	11:16:24.479062+0500	Runner	AggregateDictionary is deprecated and has been removed. Please migrate to Core Analytics.
default	11:16:24.479088+0500	Runner	Target list changed: <CADisplay:LCD primary>
default	11:16:24.479193+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:16:24.479249+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:16:24.479376+0500	Runner	Read Per-App on Init: Smart invert = (null)
default	11:16:24.479384+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:16:24.479398+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:16:24.479407+0500	Runner	Deactivation reason removed: 12; deactivation reasons: 4128 -> 32; animating application lifecycle event: 1
default	11:16:24.479413+0500	Runner	Send setDeactivating: N (-DeactivationReason:SuspendedEventsOnly)
default	11:16:24.479429+0500	Runner	Deactivation reason removed: 5; deactivation reasons: 32 -> 0; animating application lifecycle event: 0
default	11:16:24.479434+0500	Runner	Creating hang event with BundleID: bizlevel.kz
default	11:16:24.479446+0500	Runner	Updating event->rollingFGTimestamp from INVALID_FOREGROUND_TIMESTAMP to 22158988707777
default	11:16:24.479480+0500	Runner	Updating configuration of monitor M51431-1
default	11:16:24.479660+0500	Runner	[0x11e2a52c0] activating connection: mach=true listener=false peer=false name=com.apple.hangtracermonitor
default	11:16:24.479722+0500	Runner	Creating side-channel connection to com.apple.runningboard
default	11:16:24.479753+0500	Runner	Skip setting user action callback for 3rd party apps
default	11:16:24.479854+0500	Runner	[0x11e2a52c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:24.479871+0500	Runner	[0x11e2a5b80] activating connection: mach=true listener=false peer=false name=com.apple.runningboard
default	11:16:24.480074+0500	Runner	[0x11e2a5cc0] activating connection: mach=true listener=false peer=false name=com.apple.lsd.mapdb
default	11:16:24.480113+0500	Runner	Hit the server for a process handle 1f3ee9730000c8e7 that resolved to: [app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>:51431]
default	11:16:24.480124+0500	Runner	Received state update for 51431 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	11:16:24.480552+0500	Runner	Received state update for 51431 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	11:16:24.482017+0500	Runner	startConnection
default	11:16:24.482054+0500	Runner	[0x11e2a4640] activating connection: mach=true listener=false peer=false name=com.apple.UIKit.KeyboardManagement.hosted
default	11:16:24.819740+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 7
default	11:16:24.819766+0500	Runner	Ending task with identifier 7 and description: <_UIBackgroundTaskInfo: 0x105719940>: taskID = 7, taskName = Persistent SceneSession Map Update, creationTime = 923291 (elapsed = 0), _expireHandler: <__NSGlobalBlock__: 0x1f2ad6308>
default	11:16:24.819845+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x110095f90> (used by background task with identifier 7: <_UIBackgroundTaskInfo: 0x105719940>: taskID = 7, taskName = Persistent SceneSession Map Update, creationTime = 923291 (elapsed = 0))
default	11:16:24.819871+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x110095f90> for task identifier: 7
default	11:16:24.823352+0500	Runner	flutter: INFO: Firebase bootstrap deferred to post-frame stage
fault	11:16:24.823415+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle loadAndReturnError:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B0 C7 8D 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 20 2D 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 0C 2C 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 8C 1D 00 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 80 1C 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 44 92 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 6C 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:24.825071+0500	Runner	App is being debugged, do not track this hang
default	11:16:24.825088+0500	Runner	Hang detected: 0.58s (debugger attached, not reporting)
default	11:16:24.825140+0500	Runner	Scene target of keyboard event deferring environment did change: 1; scene: UIWindowScene: 0x105774200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	11:16:24.825160+0500	Runner	[0x105738a80] Scene target of event deferring environments did update: scene: 0x105774200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 1; eligibleForRecordRemoval: 1;
default	11:16:24.825172+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x105774200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	11:16:24.825185+0500	Runner	Stack[KeyWindow] 0x105712130: Migrate scenes from LastOneWins -> SystemShellManaged
default	11:16:24.825193+0500	Runner	Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
default	11:16:24.825252+0500	Runner	Realizing settings extension SBUISecureRenderingSettingsExtension on FBSSceneSettings
default	11:16:24.825391+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:16:24.825447+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
fault	11:16:24.825894+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle loadAndReturnError:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B0 C7 8D 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 20 2D 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 0C 2C 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 8C 1D 00 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 80 1C 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 44 92 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 6C 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:24.825987+0500	Runner	handleKeyboardChange: set currentKeyboard:N (wasKeyboard:N)
default	11:16:24.826004+0500	Runner	isWritingToolsHandlingKeyboardTracking:Y (WT ready:Y, Arbiter ready:Y)
fault	11:16:24.826175+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 68 9E 08 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 20 9B 08 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B0 B7 8D 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B0 C7 8D 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 20 2D 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 0C 2C 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 8C 1D 00 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 80 1C 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 44 92 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 6C 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:25.093892+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 7C FA 0A 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 90 98 78 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 F0 A9 78 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 84 2F 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 B0 1D 00 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 80 1C 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 44 92 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 6C 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:25.099670+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 7C FA 0A 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 90 98 78 00 8E 5B B5 37 16 25 36 E7 91 D5 0B 9B 14 03 1F 62 F0 A9 78 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 84 2F 03 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 B0 1D 00 00 0C FE 4A C9 D4 DD 3D 2F 99 CD A7 CD F2 57 38 27 80 1C 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 44 92 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 6C 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 8B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 66 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 70 65 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 7B 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7D 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6B 01 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 6D 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 D8 CD 86 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 34 71 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E4 74 41 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E8 A8 EC 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 94 E3 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 4C E8 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 AC E1 01 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 38 CB 08 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 A4 8D 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 08 A7 04 00 97 BB B5 BC AF 24 32 31 BF 5E 3E 28 DB 22 D4 A6 0C BF 02 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 98 89 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D D4 91 00 00 B6 35 14 F9 37 1F 33 F0 83 CC 23 FB 45 7A DF 2D 54 90 00 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 24 8F 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 98 8E 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 30 6B 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 D8 D6 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:25.104038+0500	Runner	App is being debugged, do not track this hang
default	11:16:25.104094+0500	Runner	Hang detected: 0.43s (debugger attached, not reporting)
default	11:16:26.930951+0500	Runner	App is being debugged, do not track this hang
default	11:16:26.930958+0500	Runner	Hang detected: 0.38s (debugger attached, not reporting)
default	11:16:26.931018+0500	Runner	[SentryFlutterPlugin] Async native init scheduled in 0.00 s
default	11:16:26.931030+0500	Runner	[SentryFlutterPlugin] Async native init started
default	11:16:26.932665+0500	Runner	[0x11e2a4500] activating connection: mach=true listener=false peer=false name=com.apple.lsd.advertisingidentifiers
default	11:16:26.933410+0500	Runner	-[NWConcrete_nw_resolver initWithEndpoint:parameters:path:log_str:] [R1] created for sentry.io:0 using: generic, attribution: developer
default	11:16:26.933422+0500	Runner	nw_resolver_set_update_handler_block_invoke [R1] started
default	11:16:26.933434+0500	Runner	nw_path_evaluator_start [AD7DDBB1-DD8B-4001-962E-E8046BC9ACA9 sentry.io:0 generic, attribution: developer]
	path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:26.933465+0500	Runner	[0x11e2a6080] activating connection: mach=true listener=false peer=false name=com.apple.dnssd.service
fault	11:16:26.933895+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 74 1E 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 50 45 17 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 4C 30 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D4 4C 30 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F8 C3 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:26.934036+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F8 22 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 E6 17 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 E5 17 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:26.934118+0500	Runner	System Keychain Always Supported set via feature flag to disabled
default	11:16:26.934128+0500	Runner	[0x11e2a5400] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:26.934166+0500	Runner	[0x11e2a5680] activating connection: mach=true listener=false peer=false name=com.apple.trustd
fault	11:16:26.934376+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 74 1E 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 23 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 E6 17 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 E5 17 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 38 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:26.934540+0500	Runner	[0x11e2a5680] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
fault	11:16:26.935113+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F0 43 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 5C C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:26.935187+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager moveItemAtPath:toPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager moveItemAtPath:toPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F0 43 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 5C C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:26.935518+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D0 47 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:26.935592+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager moveItemAtPath:toPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager moveItemAtPath:toPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D0 47 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:26.935610+0500	Runner	<nw_activity 50:1 [B78ACF73-CEC7-435A-A9B6-1F8AAA3F1B6E] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 27206ms
default	11:16:26.935635+0500	Runner	<nw_activity 50:2 [F91A3C7D-F4C8-435A-A116-68925B7A3FFF] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 27205ms
default	11:16:26.935653+0500	Runner	Unsetting the global parent activity <nw_activity 50:1 [B78ACF73-CEC7-435A-A9B6-1F8AAA3F1B6E] (global parent) (reporting strategy default) complete (reason success)>
default	11:16:26.935659+0500	Runner	Unset the global parent activity
default	11:16:26.936754+0500	Runner	Task <CA83AAB0-9955-441F-B3A4-C6C41AC035D5>.<1> finished with error [-999] Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLStringKey=, NSErrorFailingURLKey=, _NSURLErrorRelatedURLSessionTaskErrorKey=(
    "LocalDataTask <CA83AAB0-9955-441F-B3A4-C6C41AC035D5>.<1>"
), _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <CA83AAB0-9955-441F-B3A4-C6C41AC035D5>.<1>, NSLocalizedDescription=cancelled}
fault	11:16:26.936814+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F8 22 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A4 4B 1C 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C FC 62 1C 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.461894+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 74 1E 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 23 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A4 4B 1C 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C FC 62 1C 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.462171+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 40 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A8 29 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C 2A 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D4 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.462255+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager moveItemAtPath:toPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager moveItemAtPath:toPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 77 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 40 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A8 29 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C 2A 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D4 C5 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 D0 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C0 19 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 34 2D 3F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 83 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 04 8B 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 7C 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.462635+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 51 00 00 B8 E9 0B 10 96 18 3E 8F 86 60 74 23 D5 5C 5D FE 14 57 01 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 10 61 07 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 CC B6 1C 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 AC B6 1C 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 68 A9 FB 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 98 32 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 24 92 16 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 14 0F 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 30 96 32 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F0 99 32 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C DC C8 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 1C 93 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.462694+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Repeated invocation of callbacks when images are added or removed on the main thread can cause slow launches.","antipattern trigger":"_dyld_register_func_for_remove_image","message type":"suppressable","issue type":4,"category type":17,"subcategory type":13,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 44 E2 18 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 98 81 27 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D0 81 27 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 C9 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 1C 93 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.462802+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B8 ED 90 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 74 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 38 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 18 A0 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 94 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 98 16 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 17 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 18 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 91 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 8F 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C E8 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 18 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 1C 93 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.463044+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfFile:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 B8 ED 90 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 74 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 38 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 18 A0 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 94 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 00 98 16 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 17 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 18 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 91 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C8 8F 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C E8 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 18 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 1C 93 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:27.463109+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 50 B4 18 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 04 98 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 80 3A 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F0 95 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 8F 19 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 8C E8 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 18 CA 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 0D 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 1C 93 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:29.996630+0500	Runner	[0x11e2a5680] activating connection: mach=true listener=false peer=false name=com.apple.distributed_notifications@1v3
fault	11:16:30.652425+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:32.565079+0500	Runner	flutter: currentUserProvider: auth session = true, user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:32.566400+0500	Runner	flutter: UserRepository.fetchProfile: querying users table for 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:32.571639+0500	Runner	flutter: supabase.auth: INFO: Refresh session
fault	11:16:32.870980+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:33.520566+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B0 5D 71 7F DF 40 31 24 96 79 FD C0 B9 F2 7F 27 80 0F 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 B0 5D 71 7F DF 40 31 24 96 79 FD C0 B9 F2 7F 27 40 0F 00 00 B0 5D 71 7F DF 40 31 24 96 79 FD C0 B9 F2 7F 27 20 0C 00 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B BC 46 04 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B 38 42 04 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B F4 3B 04 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B BC 3A 04 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B 88 39 04 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B 64 35 01 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B F8 D9 01 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B 5C D3 01 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B BC C2 01 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B A8 92 01 00 27 39 84 E6 EC C4 37 AE AA 59 A9 04 05 BD 40 6B 54 BB 01 00 00 B3 D5 0F 53 33 3E 58 8B 86 44 74 A4 46 27 F8 D0 45 08 00 00 B3 D5 0F 53 33 3E 58 8B 86 44 74 A4 46 27 F8 94 7E 01 00 00 B3 D5 0F 53 33 3E 58 8B 86 44 74 A4 46 27 F8 C4 3E 08 00 00 B3 D5 0F 53 33 3E 58 8B 86 44 74 A4 46 27 F8 EC A4 0C 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A BC 7A 1B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 79 1B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 68 5B 23 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 7C DD 18 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 08 56 23 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A A4 C0 19 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 AA 15 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 2C 62 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC 0F 36 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 51 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 30 83 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 59 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 08 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 BF 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A DC BB 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 30 1E 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:33.972693+0500	Runner	App is being debugged, do not track this hang
default	11:16:33.972716+0500	Runner	Hang detected: 7.05s (debugger attached, not reporting)
default	11:16:34.286195+0500	Runner	Requesting container lookup; class = 13, identifier = (null), group_identifier = systemgroup.com.apple.configurationprofiles, create = 1, temp = 0, euid = 501, uid = 501
default	11:16:34.290637+0500	Runner	_container_query_get_result_at_index: success
default	11:16:34.290750+0500	Runner	container_system_group_path_for_identifier: success
default	11:16:34.290792+0500	Runner	Got system group container path from MCM for systemgroup.com.apple.configurationprofiles: /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles
fault	11:16:34.293878+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B3 8D 2B 15 45 24 3D FF 93 AD 80 F2 95 22 C3 F8 C8 32 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 90 77 00 00 B3 8D 2B 15 45 24 3D FF 93 AD 80 F2 95 22 C3 F8 20 32 00 00 B3 8D 2B 15 45 24 3D FF 93 AD 80 F2 95 22 C3 F8 08 59 00 00 B3 8D 2B 15 45 24 3D FF 93 AD 80 F2 95 22 C3 F8 C4 1B 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 94 2A 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 2A 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 14 2D 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 84 66 7A 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 A3 78 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:34.303877+0500	Runner	[0x11e2a7840] activating connection: mach=true listener=false peer=false name=com.apple.pasteboard.pasted
default	11:16:34.304224+0500	Runner	Retrieving pasteboard named com.apple.UIKit.pboard.general, create if needed: NO
fault	11:16:34.314728+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 68 4B 00 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 14 0A 90 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 24 35 00 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 DC 34 00 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 14 1C 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC CC 53 01 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 68 1A 00 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 F4 1A 00 00 AE 14 25 0B B5 4E 30 C5 9F AD 29 C7 D6 72 88 D4 5C 76 07 00 CF 7C 23 22 85 60 34 EE A8 F3 DA D6 48 4A 3C EA DC 1E 00 00 B3 8D 2B 15 45 24 3D FF 93 AD 80 F2 95 22 C3 F8 C4 1B 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 94 2A 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 E0 2A 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 14 2D 82 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 84 66 7A 01 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 A3 78 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C0 F4 03 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 78 47 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC B4 46 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C8 A2 06 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 3C DB 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:34.316400+0500	Runner	...retrieving pasteboard named com.apple.UIKit.pboard.general completed successfully.
default	11:16:34.318568+0500	Runner	App is being debugged, do not track this hang
default	11:16:34.318593+0500	Runner	Hang detected: 0.35s (debugger attached, not reporting)
default	11:16:35.067464+0500	Runner	flutter: INFO: Firebase.initializeApp() completed (post_frame_bootstrap)
default	11:16:35.077785+0500	Runner	App is being debugged, do not track this hang
default	11:16:35.077833+0500	Runner	Hang detected: 0.76s (debugger attached, not reporting)
default	11:16:35.479448+0500	Runner	nw_path_libinfo_path_check [C06E2A64-79C7-4DFB-AB92-E45E6405F7A7 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:35.480623+0500	Runner	App is being debugged, do not track this hang
default	11:16:35.480658+0500	Runner	Hang detected: 0.39s (debugger attached, not reporting)
default	11:16:35.512733+0500	Runner	flutter: currentUserProvider: auth session = true, user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:35.512866+0500	Runner	flutter: UserRepository.fetchProfile: querying users table for 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:35.514307+0500	Runner	nw_path_libinfo_path_check [2F929599-83D7-4AF6-B4BC-70AD47041D65 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:35.515012+0500	Runner	nw_path_libinfo_path_check [8E3BE024-EB7C-4FBE-927E-FC7708C8FB5E acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:35.871594+0500	Runner	App is being debugged, do not track this hang
default	11:16:35.871819+0500	Runner	Hang detected: 0.36s (debugger attached, not reporting)
default	11:16:35.873403+0500	Runner	nw_path_libinfo_path_check [AB7E80EA-F89E-46BC-8C5C-B67DFBAD8105 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:35.905291+0500	Runner	[bizlevel.kz] Requesting authorization with options 7
default	11:16:35.905478+0500	Runner	[0x11e2a6a80] activating connection: mach=true listener=false peer=false name=com.apple.usernotifications.listener
default	11:16:35.912085+0500	Runner	[0x11e2a7980] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:35.918723+0500	Runner	[0x11e2a7980] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:35.922374+0500	Runner	[bizlevel.kz] Requested authorization [ didGrant: 1 hasError: 0 hasCompletionHandler: 1 ]
default	11:16:35.922885+0500	Runner	[bizlevel.kz] Requesting authorization with options 7
default	11:16:35.930423+0500	Runner	[bizlevel.kz] Requested authorization [ didGrant: 1 hasError: 0 hasCompletionHandler: 1 ]
default	11:16:35.931405+0500	Runner	flutter: REMINDER_PREFS[cloud_fetch_start] {source: prefetch}
default	11:16:35.932722+0500	Runner	nw_path_libinfo_path_check [D41EEF7F-358E-4911-9252-77349FC491E3 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
fault	11:16:36.292912+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 38 5A 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:36.303818+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 38 5A 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:36.354893+0500	Runner	App is being debugged, do not track this hang
default	11:16:36.354907+0500	Runner	Hang detected: 0.42s (debugger attached, not reporting)
default	11:16:36.366775+0500	Runner	[bizlevel.kz] Requesting authorization with options 7
default	11:16:36.371872+0500	Runner	nw_path_libinfo_path_check [75DE2384-A181-4404-82E0-657E897CF608 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:36.373538+0500	Runner	[bizlevel.kz] Requested authorization [ didGrant: 1 hasError: 0 hasCompletionHandler: 1 ]
default	11:16:36.373567+0500	Runner	[bizlevel.kz] Getting notification settings (async)
default	11:16:36.375001+0500	Runner	[bizlevel.kz] Got notification settings [ hasResult: 1 hasCompletionHandler: 1 ]
default	11:16:36.375020+0500	Runner	[0x11e2a7980] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:36.377675+0500	Runner	[0x11e2a7980] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:36.383264+0500	Runner	flutter: UserRepository.fetchProfile: raw response: {id: 4e46bca3-e742-4bb4-bc97-1e5832d753a3, name: Ерлан А, email: deus2111@gmail.com, about: Булочки пеку., goal: Круасаны по рецепту бабушки научиться делать., business_area: Пекарни, experience_level: 10 лет, onboarding_completed: true, current_level: 11, avatar_id: 5, business_size: 5-50 сотрудников, key_challenges: [Команда, Масштабирование], learning_style: Практические примеры, business_region: Казахстан}
default	11:16:36.383289+0500	Runner	flutter: UserRepository.fetchProfile: loaded user 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:36.383331+0500	Runner	flutter: UserRepository.fetchProfile: goal = "Круасаны по рецепту бабушки научиться делать."
default	11:16:36.383349+0500	Runner	flutter: UserRepository.fetchProfile: about = "Булочки пеку."
default	11:16:36.383362+0500	Runner	flutter: currentUserProvider: repository returned true
default	11:16:36.429780+0500	Runner	[0x11e2a7980] activating connection: mach=true listener=false peer=false name=com.apple.trustd
fault	11:16:36.431457+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 74 1E 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 90 5B 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 9C 2E 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 08 DB 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C AC 0B 28 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 91 16 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D4 D7 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:36.432367+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:36.432710+0500	Runner	[0x11e2a7980] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:36.432895+0500	Runner	-[SOConfigurationClient init]  on <SOConfigurationClient: 0x125514620>
default	11:16:36.432928+0500	Runner	[0x11e2a7ac0] activating connection: mach=true listener=false peer=false name=com.apple.AppSSO.service-xpc
default	11:16:36.432981+0500	Runner	<SOServiceConnection: 0x125514740>: new XPC connection
default	11:16:36.434747+0500	Runner	Requesting container lookup; class = 13, identifier = com.apple.nsurlsessiond, group_identifier = systemgroup.com.apple.nsurlstoragedresources, create = 1, temp = 0, euid = 501, uid = 501
default	11:16:36.435643+0500	Runner	_container_query_get_result_at_index: success
default	11:16:36.435715+0500	Runner	container_system_group_path_for_identifier: success
default	11:16:36.436984+0500	Runner	Connection 0: creating secure tcp or quic connection
default	11:16:36.437649+0500	Runner	Connection 1: enabling TLS
default	11:16:36.437660+0500	Runner	Connection 1: starting, TC(0x0)
default	11:16:36.437671+0500	Runner	[C1 BD1E7303-A084-4DB1-9F4D-BE11A1428137 o4509632462782464.ingest.de.sentry.io:443 quic-connection, url: https://o4509632462782464.ingest.de.sentry.io/api/4509648222617680/envelope/, definite, attribution: developer, context: com.apple.CFNetwork.NSURLSession.{C707F1B3-134E-488D-BAD9-55C8169E6C91}{(null)}{Y}{3}{0x0} (sensitive), proc: 4D21AE11-C4E1-33A6-8F11-63BA02CBD100, delegated upid: 0] start
default	11:16:36.437697+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 initial parent-flow ((null))] event: path:start @0.000s
default	11:16:36.437949+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 waiting parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.000s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:16:36.438014+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_connect @0.000s
default	11:16:36.438081+0500	Runner	nw_connection_report_state_with_handler_on_nw_queue [C1] reporting state preparing
default	11:16:36.438105+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_child @0.000s
default	11:16:36.438139+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 initial path ((null))] event: path:start @0.000s
default	11:16:36.438268+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.000s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:16:36.438306+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: transform:start @0.000s
default	11:16:36.438359+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 initial path ((null))] event: path:start @0.000s
default	11:16:36.438740+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.000s, uuid: A799E591-ED3E-4F84-82FE-0424F73E5E26
default	11:16:36.438927+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: resolver:start_dns @0.000s
default	11:16:36.438956+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> setting up Connection 1
default	11:16:36.981295+0500	Runner	App is being debugged, do not track this hang
default	11:16:36.984868+0500	Runner	Hang detected: 0.50s (debugger attached, not reporting)
default	11:16:36.986074+0500	Runner	nw_endpoint_resolver_update [C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Adding endpoint handler for 34.120.62.213:443
default	11:16:36.986182+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: resolver:receive_dns @0.542s
default	11:16:36.986382+0500	Runner	[C1.1.1.1 34.120.62.213:443 initial path ((null))] event: path:start @0.543s
default	11:16:36.986591+0500	Runner	[C1.1.1.1 34.120.62.213:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.545s, uuid: B9F34D72-972F-40B5-88C6-20D2F15AAE97
default	11:16:36.987421+0500	Runner	[C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_nexus @0.546s
default	11:16:36.990098+0500	Runner	[C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:receive_nexus @0.551s
default	11:16:36.990336+0500	Runner	user_tcp_init_all_block_invoke g_tcp_nw_assert_context is false value -1
default	11:16:36.993215+0500	Runner	[C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_connect @0.555s
default	11:16:36.994390+0500	Runner	tcp_output [C1.1.1.1:3] flags=[SEC] seq=3792034696, ack=0, win=65535 state=SYN_SENT rcv_nxt=0, snd_una=3792034696
default	11:16:37.014283+0500	Runner	flutter: REMINDER_PREFS[cloud_fetch_empty] {source: prefetch}
default	11:16:37.016930+0500	Runner	flutter: UserRepository.fetchProfile: raw response: {id: 4e46bca3-e742-4bb4-bc97-1e5832d753a3, name: Ерлан А, email: deus2111@gmail.com, about: Булочки пеку., goal: Круасаны по рецепту бабушки научиться делать., business_area: Пекарни, experience_level: 10 лет, onboarding_completed: true, current_level: 11, avatar_id: 5, business_size: 5-50 сотрудников, key_challenges: [Команда, Масштабирование], learning_style: Практические примеры, business_region: Казахстан}
default	11:16:37.017009+0500	Runner	flutter: UserRepository.fetchProfile: loaded user 4e46bca3-e742-4bb4-bc97-1e5832d753a3
default	11:16:37.017112+0500	Runner	flutter: UserRepository.fetchProfile: goal = "Круасаны по рецепту бабушки научиться делать."
default	11:16:37.017122+0500	Runner	flutter: UserRepository.fetchProfile: about = "Булочки пеку."
default	11:16:37.017129+0500	Runner	flutter: currentUserProvider: repository returned true
default	11:16:37.449497+0500	Runner	tcp_input [C1.1.1.1:3] flags=[S.] seq=3396908916, ack=3792034697, win=65535 state=SYN_SENT rcv_nxt=0, snd_una=3792034696
default	11:16:37.449518+0500	Runner	tcp_input [C1.1.1.1:3] flags=[S.] seq=3396908916, ack=3792034697, win=65535 state=ESTABLISHED rcv_nxt=3396908917, snd_una=3792034697
default	11:16:37.449528+0500	Runner	nw_flow_connected [C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Transport protocol connected (tcp)
default	11:16:37.450167+0500	Runner	[C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:finish_transport @1.011s
default	11:16:37.450273+0500	Runner	boringssl_session_apply_protocol_options_for_transport_block_invoke_2(2280) [C1.1.1.1:2][0x125719460] TLS configured [min_version(0x0303) max_version(0x0304) name(o4509632462782464.ingest.de.sentry.io) tickets(false) false_start(false) enforce_ev(false) enforce_ats(false) ats_non_pfs_ciphersuite_allowed(false) ech(false) pqtls(true), pake(false)]
default	11:16:37.450318+0500	Runner	boringssl_context_info_handler(2377) [C1.1.1.1:2][0x125719460] Client handshake started
default	11:16:37.450753+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS client enter_early_data
default	11:16:37.450812+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS client read_server_hello
default	11:16:37.534923+0500	Runner	nw_path_libinfo_path_check [C585EAAD-F7F4-429F-A2AC-95BF5C15CF65 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:37.535161+0500	Runner	App is being debugged, do not track this hang
default	11:16:37.535188+0500	Runner	Hang detected: 0.51s (debugger attached, not reporting)
default	11:16:37.535348+0500	Runner	nw_path_libinfo_path_check [2FAA3D84-46C9-4241-86BE-29F6E5FF6668 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:37.535456+0500	Runner	nw_path_libinfo_path_check [BEC921A2-1A3D-4635-972C-899DC1CB11F9 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:37.535695+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_hello_retry_request
default	11:16:37.535738+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_server_hello
default	11:16:37.535809+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_encrypted_extensions
default	11:16:37.538105+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_certificate_request
default	11:16:37.538144+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_server_certificate
default	11:16:37.538156+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_server_certificate_verify
default	11:16:37.538347+0500	Runner	boringssl_context_evaluate_trust_async(1820) [C1.1.1.1:2][0x125719460] Performing external trust evaluation
default	11:16:37.538376+0500	Runner	boringssl_context_evaluate_trust_async_external(1805) [C1.1.1.1:2][0x125719460] Asyncing for external verify block
default	11:16:37.538506+0500	Runner	Connection 1: asked to evaluate TLS Trust
default	11:16:37.538743+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> auth completion disp=1 cred=0x0
default	11:16:37.538867+0500	Runner	(Trust 0x13149ccc0) No pending evals, starting
default	11:16:37.538997+0500	Runner	[0x105670c80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:37.539089+0500	Runner	(Trust 0x13149ccc0) Completed async eval kickoff
default	11:16:38.028719+0500	Runner	(Trust 0x13149ccc0) trustd returned 4
default	11:16:38.028784+0500	Runner	System Trust Evaluation yielded status(0)
default	11:16:38.028810+0500	Runner	(Trust 0x13149cb40) No pending evals, starting
default	11:16:38.032210+0500	Runner	[0x105670f00] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.032267+0500	Runner	(Trust 0x13149cb40) Completed async eval kickoff
default	11:16:38.032283+0500	Runner	[0x105670c80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.032941+0500	Runner	(Trust 0x13149cb40) trustd returned 4
default	11:16:38.033008+0500	Runner	Connection 1: TLS Trust result 0
default	11:16:38.033016+0500	Runner	boringssl_context_evaluate_trust_async_external_block_invoke_3(1760) [C1.1.1.1:2][0x125719460] Returning from external verify block with result: true
default	11:16:38.033082+0500	Runner	boringssl_context_certificate_verify_callback(2001) [C1.1.1.1:2][0x125719460] Certificate verification result: OK
default	11:16:38.033175+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client read_server_finished
default	11:16:38.033205+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client send_end_of_early_data
default	11:16:38.033250+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client send_client_encrypted_extensions
default	11:16:38.033263+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client send_client_certificate
default	11:16:38.033313+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client complete_second_flight
default	11:16:38.033356+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS 1.3 client done
default	11:16:38.033742+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS client finish_client_handshake
default	11:16:38.033751+0500	Runner	boringssl_context_info_handler(2394) [C1.1.1.1:2][0x125719460] Client handshake state: TLS client done
default	11:16:38.033937+0500	Runner	boringssl_context_info_handler(2383) [C1.1.1.1:2][0x125719460] Client handshake done
default	11:16:38.035777+0500	Runner	nw_protocol_boringssl_signal_connected(895) [C1.1.1.1:2][0x125719460] TLS connected [server(0) version(0x0304) ciphersuite(TLS_AES_256_GCM_SHA384) group(0x001d) signature_alg(0x0804) alpn(h2) resumed(0) offered_ticket(0) in_early_data(0) early_data_accepted(0) false_started(0) ocsp_received(0) sct_received(0) connect_time(584ms) flight_time(88ms) rtt(85ms) write_stalls(0) read_stalls(9) pake(0x0000)]
default	11:16:38.035818+0500	Runner	nw_flow_connected [C1.1.1.1 34.120.62.213:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Output protocol connected (CFNetworkConnection-3036834541)
default	11:16:38.035983+0500	Runner	[C1.1.1.1 34.120.62.213:443 ready channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @1.596s
default	11:16:38.036530+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 ready resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @1.596s
default	11:16:38.036550+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @1.597s
default	11:16:38.036586+0500	Runner	[C1.1.1.1 34.120.62.213:443 ready channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @1.597s
default	11:16:38.036806+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 ready resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @1.597s
default	11:16:38.037991+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @1.597s
default	11:16:38.038055+0500	Runner	nw_flow_connected [C1 34.120.62.213:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Output protocol connected (endpoint_flow)
default	11:16:38.038734+0500	Runner	[C1 34.120.62.213:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:finish_connect @1.597s
default	11:16:38.038853+0500	Runner	nw_connection_report_state_with_handler_on_nw_queue [C1] reporting state ready
default	11:16:38.038897+0500	Runner	[C1 34.120.62.213:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @1.597s
default	11:16:38.038908+0500	Runner	nw_connection_send_viability_changed_on_nw_queue [C1] viability_changed_handler(true)
default	11:16:38.038927+0500	Runner	[0x105670f00] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.038934+0500	Runner	Connection 1: connected successfully
default	11:16:38.038944+0500	Runner	Connection 1: TLS handshake complete
default	11:16:38.038957+0500	Runner	Connection 1: ready C(N) E(N)
default	11:16:38.039011+0500	Runner	[C1] event: client:connection_reused @1.598s
default	11:16:38.039041+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:38.039047+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.039263+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> now using Connection 1
default	11:16:38.039313+0500	Runner	Connection 1: received viability advisory(Y)
default	11:16:38.039329+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> sent request, body S 1912
default	11:16:38.049777+0500	Runner	App is being debugged, do not track this hang
default	11:16:38.049804+0500	Runner	Hang detected: 0.51s (debugger attached, not reporting)
default	11:16:38.080248+0500	Runner	nw_path_libinfo_path_check [9672C357-4F5A-447D-9160-850E638EA3EA acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.080344+0500	Runner	nw_path_libinfo_path_check [FC51C36D-921F-4CE2-BC78-D4A3456A32D1 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.080391+0500	Runner	nw_path_libinfo_path_check [7C5D2A4E-F642-48CD-B106-38037FBFD230 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.080499+0500	Runner	nw_path_libinfo_path_check [15347F94-41BD-4563-BDFE-8FDA20B7A4C2 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.080530+0500	Runner	nw_path_libinfo_path_check [1EF34CB3-4138-40CF-B1B0-52ABC64E2DDD acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.090409+0500	Runner	nw_path_libinfo_path_check [8F620B48-6801-451C-AC08-E3B89A6F2AF7 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.090817+0500	Runner	nw_path_libinfo_path_check [7A366F6E-2D50-4125-B7A0-FF3B529C6E56 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.093893+0500	Runner	nw_path_libinfo_path_check [02695147-6233-48B4-B862-1CFBEEF439C5 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.106054+0500	Runner	nw_path_libinfo_path_check [CB0E2FF7-DBE5-4CD2-A82C-45EBDD86162F acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:38.200772+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> received response, status 200 content K
default	11:16:38.200937+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> done using Connection 1
default	11:16:38.201376+0500	Runner	[C1] event: client:connection_idle @1.763s
default	11:16:38.201639+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:38.201652+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.202055+0500	Runner	[0x105670c80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.203782+0500	Runner	[0x105670c80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.203910+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> response ended
default	11:16:38.204008+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> summary for task success {transaction_duration_ms=1769, response_status=200, connection=1, protocol="h2", domain_lookup_duration_ms=542, connect_duration_ms=1042, secure_connection_duration_ms=584, private_relay=false, request_start_ms=1602, request_duration_ms=0, response_start_ms=1766, response_duration_ms=3, request_bytes=2166, request_throughput_kbps=28312, response_bytes=337, response_throughput_kbps=813, cache_hit=false}
default	11:16:38.204152+0500	Runner	Task <E4DBE80E-0FBE-4E0E-B7B3-566E6DE1C678>.<1> finished successfully
default	11:16:38.204351+0500	Runner	Garbage collection for alternative services
fault	11:16:38.210886+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 20 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B4 5D 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C A0 F2 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F8 F8 1D 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 24 E1 20 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 94 12 21 00 76 7C 6A D7 13 57 3B C6 82 C7 80 D7 10 C4 C8 15 00 7B 0D 00 76 7C 6A D7 13 57 3B C6 82 C7 80 D7 10 C4 C8 15 54 C9 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 08 D8 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:38.237226+0500	Runner	[0x105670c80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.239082+0500	Runner	[0x105670c80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.263653+0500	Runner	[0x105670c80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.263686+0500	Runner	[0x105671400] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.263704+0500	Runner	[0x105671540] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.265088+0500	Runner	[0x105670c80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.269304+0500	Runner	[0x105671400] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.269732+0500	Runner	[0x105671540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.294192+0500	Runner	[0x105671540] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.296720+0500	Runner	[0x105671540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.311356+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:38.312244+0500	Runner	[C1] event: client:connection_reused @1.874s
default	11:16:38.312268+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:38.312274+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.312313+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> now using Connection 1
default	11:16:38.312416+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> sent request, body S 1902
default	11:16:38.477490+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> received response, status 200 content K
default	11:16:38.477660+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> done using Connection 1
default	11:16:38.477771+0500	Runner	[C1] event: client:connection_idle @2.039s
default	11:16:38.477806+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:38.477813+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.478068+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> response ended
default	11:16:38.478364+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> summary for task success {transaction_duration_ms=166, response_status=200, connection=1, reused=1, reused_after_ms=110, request_start_ms=0, request_duration_ms=0, response_start_ms=165, response_duration_ms=0, request_bytes=1961, request_throughput_kbps=170466, response_bytes=95, response_throughput_kbps=1017, cache_hit=false}
default	11:16:38.478516+0500	Runner	Task <147874D4-786C-42C6-98B3-5735FDD792EB>.<2> finished successfully
default	11:16:38.498579+0500	Runner	[0x105671540] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:38.502326+0500	Runner	[0x105671540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:38.531307+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:38.531843+0500	Runner	[C1] event: client:connection_reused @2.094s
default	11:16:38.531883+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:38.531893+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.532016+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> now using Connection 1
default	11:16:38.532377+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> sent request, body S 1931
default	11:16:38.711399+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> received response, status 200 content K
default	11:16:38.711457+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> done using Connection 1
default	11:16:38.711509+0500	Runner	[C1] event: client:connection_idle @2.273s
default	11:16:38.711651+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:38.711708+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.712011+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> response ended
default	11:16:38.712333+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> summary for task success {transaction_duration_ms=180, response_status=200, connection=1, reused=1, reused_after_ms=54, request_start_ms=0, request_duration_ms=0, response_start_ms=179, response_duration_ms=0, request_bytes=1990, request_throughput_kbps=45750, response_bytes=95, response_throughput_kbps=907, cache_hit=false}
default	11:16:38.712512+0500	Runner	Task <04929C5B-4037-40F1-AE8A-8EED39F40E92>.<3> finished successfully
default	11:16:38.819681+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:38.820275+0500	Runner	[C1] event: client:connection_reused @2.382s
default	11:16:38.820305+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:38.820319+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.820416+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> now using Connection 1
default	11:16:38.820550+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> sent request, body S 2000
default	11:16:38.941229+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> received response, status 200 content K
default	11:16:38.941353+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> done using Connection 1
default	11:16:38.941442+0500	Runner	[C1] event: client:connection_idle @2.503s
default	11:16:38.941490+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:38.941498+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:38.941664+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> response ended
default	11:16:38.942292+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> summary for task success {transaction_duration_ms=121, response_status=200, connection=1, reused=1, reused_after_ms=108, request_start_ms=0, request_duration_ms=0, response_start_ms=121, response_duration_ms=0, request_bytes=2059, request_throughput_kbps=124708, response_bytes=95, response_throughput_kbps=1727, cache_hit=false}
default	11:16:38.942364+0500	Runner	Task <9933834B-BF45-46AB-9DFF-D4B07BF9F5EF>.<4> finished successfully
default	11:16:46.676211+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:46.676234+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:46.680180+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:46.680226+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:46.680398+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:46.711503+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:46.711582+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:46.711612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:46.711720+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:46.711771+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:46.711796+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:46.711822+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.018445+0500	Runner	App is being debugged, do not track this hang
default	11:16:47.018454+0500	Runner	Hang detected: 0.30s (debugger attached, not reporting)
default	11:16:47.018659+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.018675+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.018682+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.018692+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.018698+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.021722+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.021748+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.021869+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.021903+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.807625+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:47.809859+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.809917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.810010+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.810065+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.825983+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.825997+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.826011+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.838454+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.838466+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.838618+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.842655+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.842788+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.842828+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.842993+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:47.843112+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.843172+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.843215+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.852035+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.853693+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.853713+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.859302+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.859323+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.859863+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.867518+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.867655+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.867880+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.876061+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.876141+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.876344+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.890091+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.891619+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.891637+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.892779+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.892827+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.892848+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.900867+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.900960+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.900980+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.909185+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.909214+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.909235+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:47.909368+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:47.909399+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:47.909420+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:48.777839+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:48.779464+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:48.779494+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:48.779525+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:48.779553+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:48.827212+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:48.827311+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:48.827347+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:48.859354+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:49.307986+0500	Runner	App is being debugged, do not track this hang
default	11:16:49.308003+0500	Runner	Hang detected: 0.45s (debugger attached, not reporting)
default	11:16:51.127036+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:51.127064+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.127093+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.127124+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.127269+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.134505+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.134639+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.134649+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.135236+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.135251+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.135258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.138263+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.138271+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.138282+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.138313+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:51.138325+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.138334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.138360+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.139106+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.139132+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.139161+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.140192+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.140199+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.140207+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.140906+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.140917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.140925+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.141932+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.141938+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.141946+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.142277+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.142285+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.142291+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.143681+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.143691+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.143698+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.383426+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.383435+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.383443+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.390042+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.390158+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.390600+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.391799+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.391807+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.391813+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.392412+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.392431+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.392443+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.394237+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.394244+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.394252+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.396378+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.396450+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.396512+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.399818+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.399825+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.399837+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.560551+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.563170+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.563308+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.563426+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.563448+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.563472+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.566746+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.566756+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.566768+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.570858+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.570869+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.570878+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.572839+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.572849+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.572865+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.574084+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.574091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.574100+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.574668+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.576148+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.576157+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.576173+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.577240+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.577248+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.577255+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.577919+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.578881+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.578890+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.578898+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:51.579277+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:51.579349+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:51.579370+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:52.013078+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:52.013089+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:52.013099+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:52.013115+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:52.013894+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:52.014919+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x131552100>
default	11:16:52.014939+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:16:52.014959+0500	Runner	Creating new background assertion
default	11:16:52.014992+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.015078+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.015104+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x12543af80>: taskID = 8, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0).
default	11:16:52.017091+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 8
default	11:16:52.017182+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x131550e00>
default	11:16:52.017194+0500	Runner	Ending task with identifier 8 and description: <_UIBackgroundTaskInfo: 0x12543af80>: taskID = 8, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x131551d00>
default	11:16:52.017204+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.017234+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.017247+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534af0> (used by background task with identifier 8: <_UIBackgroundTaskInfo: 0x12543af80>: taskID = 8, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0))
default	11:16:52.017306+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x12543b880>: taskID = 9, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0).
default	11:16:52.018846+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 9
default	11:16:52.018862+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x131550640>
fault	11:16:52.018877+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C BC DF 12 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F0 B1 12 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D4 D7 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:52.018948+0500	Runner	Ending task with identifier 9 and description: <_UIBackgroundTaskInfo: 0x12543b880>: taskID = 9, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x131550e00>
default	11:16:52.018959+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.018966+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.019051+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534af0> (used by background task with identifier 9: <_UIBackgroundTaskInfo: 0x12543b880>: taskID = 9, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0))
default	11:16:52.019090+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x12543b940>: taskID = 10, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0).
default	11:16:52.020576+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 10
default	11:16:52.020663+0500	Runner	Will add backgroundTask with taskName: GDTCCTUploader-upload, expirationHandler: <__NSMallocBlock__: 0x131551e80>
default	11:16:52.020673+0500	Runner	Ending task with identifier 10 and description: <_UIBackgroundTaskInfo: 0x12543b940>: taskID = 10, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x131550540>
default	11:16:52.020684+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.020690+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534af0>
default	11:16:52.020703+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534af0> (used by background task with identifier 10: <_UIBackgroundTaskInfo: 0x12543b940>: taskID = 10, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0))
default	11:16:52.020733+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x12543ad80>: taskID = 11, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0).
fault	11:16:52.020853+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 98 DC 12 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C BC C1 12 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D4 D7 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:52.022598+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 11
default	11:16:52.022628+0500	Runner	Ending task with identifier 11 and description: <_UIBackgroundTaskInfo: 0x12543ad80>: taskID = 11, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x131551e80>
default	11:16:52.022694+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534af0> (used by background task with identifier 11: <_UIBackgroundTaskInfo: 0x12543ad80>: taskID = 11, taskName = GDTCCTUploader-upload, creationTime = 923319 (elapsed = 0))
default	11:16:52.022746+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534af0> for task identifier: 11
default	11:16:52.087275+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:52.088720+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:52.089179+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
fault	11:16:52.560801+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 45 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D8 16 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:52.561352+0500	Runner	App is being debugged, do not track this hang
default	11:16:52.561363+0500	Runner	Hang detected: 0.38s (debugger attached, not reporting)
fault	11:16:52.561912+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 45 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D8 16 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:52.562210+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:52.562313+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:52.562735+0500	Runner	[C1] event: client:connection_reused @16.048s
default	11:16:52.562791+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:52.562814+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:52.562849+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> now using Connection 1
default	11:16:52.562973+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> sent request, body S 2042
default	11:16:52.928965+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> received response, status 200 content K
default	11:16:52.930783+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> done using Connection 1
default	11:16:52.932291+0500	Runner	[C1] event: client:connection_idle @16.492s
default	11:16:52.932365+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:52.932378+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:52.932399+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> response ended
default	11:16:52.932418+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> summary for task success {transaction_duration_ms=445, response_status=200, connection=1, reused=1, reused_after_ms=13544, request_start_ms=0, request_duration_ms=0, response_start_ms=442, response_duration_ms=1, request_bytes=2101, request_throughput_kbps=89863, response_bytes=95, response_throughput_kbps=396, cache_hit=false}
default	11:16:52.932585+0500	Runner	Task <321B7920-4517-4DA8-A515-BFDAD3300537>.<5> finished successfully
default	11:16:53.493015+0500	Runner	App is being debugged, do not track this hang
default	11:16:53.493067+0500	Runner	Hang detected: 1.02s (debugger attached, not reporting)
default	11:16:53.720741+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:53.721657+0500	Runner	[C1] event: client:connection_reused @17.284s
default	11:16:53.721683+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:53.721738+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:53.721792+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> now using Connection 1
default	11:16:53.721960+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> sent request, body S 14478
default	11:16:53.896749+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> received response, status 200 content K
default	11:16:53.896900+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> done using Connection 1
default	11:16:53.896966+0500	Runner	[C1] event: client:connection_idle @17.459s
default	11:16:53.897032+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:53.897049+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:53.897241+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> response ended
default	11:16:53.897356+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> summary for task success {transaction_duration_ms=175, response_status=200, connection=1, reused=1, reused_after_ms=791, request_start_ms=0, request_duration_ms=0, response_start_ms=175, response_duration_ms=0, request_bytes=14538, request_throughput_kbps=1129199, response_bytes=95, response_throughput_kbps=1439, cache_hit=false}
default	11:16:53.897480+0500	Runner	Task <0A31F09B-82A5-4B75-B7A3-69297190989D>.<6> finished successfully
default	11:16:54.018775+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:54.019562+0500	Runner	[C1] event: client:connection_reused @17.578s
default	11:16:54.019638+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:54.019804+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.019835+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> now using Connection 1
default	11:16:54.019881+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> sent request, body S 5094
default	11:16:54.138375+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> received response, status 200 content K
default	11:16:54.138505+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> done using Connection 1
default	11:16:54.139585+0500	Runner	[C1] event: client:connection_idle @17.700s
default	11:16:54.139658+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:54.139679+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.139834+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> response ended
default	11:16:54.139868+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=119, request_start_ms=0, request_duration_ms=0, response_start_ms=121, response_duration_ms=2, request_bytes=5153, request_throughput_kbps=249683, response_bytes=95, response_throughput_kbps=360, cache_hit=false}
default	11:16:54.139952+0500	Runner	Task <DC752458-C4C3-427C-98EC-75B727900F16>.<7> finished successfully
default	11:16:54.250138+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:54.253066+0500	Runner	[C1] event: client:connection_reused @17.815s
default	11:16:54.259474+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:54.259577+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.259624+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> now using Connection 1
default	11:16:54.259861+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> sent request, body S 5004
default	11:16:54.376995+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> received response, status 200 content K
default	11:16:54.377052+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> done using Connection 1
default	11:16:54.377118+0500	Runner	[C1] event: client:connection_idle @17.939s
default	11:16:54.377299+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:54.377465+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.380528+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> response ended
default	11:16:54.380553+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> summary for task success {transaction_duration_ms=125, response_status=200, connection=1, reused=1, reused_after_ms=114, request_start_ms=2, request_duration_ms=3, response_start_ms=125, response_duration_ms=0, request_bytes=5063, request_throughput_kbps=10882, response_bytes=95, response_throughput_kbps=1264, cache_hit=false}
default	11:16:54.380714+0500	Runner	Task <0300E68C-E2BB-4387-9CC2-64CAC5B5ADCE>.<8> finished successfully
default	11:16:54.489614+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:54.490566+0500	Runner	[C1] event: client:connection_reused @18.053s
default	11:16:54.490664+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:54.490679+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.490849+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> now using Connection 1
default	11:16:54.491539+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> sent request, body S 5070
default	11:16:54.611831+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> received response, status 200 content K
default	11:16:54.612287+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> done using Connection 1
default	11:16:54.612644+0500	Runner	[C1] event: client:connection_idle @18.174s
default	11:16:54.615005+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:54.615227+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.616931+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> response ended
default	11:16:54.616961+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> summary for task success {transaction_duration_ms=124, response_status=200, connection=1, reused=1, reused_after_ms=113, request_start_ms=0, request_duration_ms=0, response_start_ms=121, response_duration_ms=2, request_bytes=5129, request_throughput_kbps=99826, response_bytes=95, response_throughput_kbps=300, cache_hit=false}
default	11:16:54.617063+0500	Runner	Task <D13C9C56-9E23-4B86-BD5C-F337A7BA6A51>.<9> finished successfully
default	11:16:54.728894+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:54.730489+0500	Runner	[C1] event: client:connection_reused @18.293s
default	11:16:54.730627+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:54.730643+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.730874+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> now using Connection 1
default	11:16:54.731450+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> sent request, body S 5010
default	11:16:54.851807+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> received response, status 200 content K
default	11:16:54.851959+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> done using Connection 1
default	11:16:54.852127+0500	Runner	[C1] event: client:connection_idle @18.414s
default	11:16:54.852210+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:54.852322+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.852754+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> response ended
default	11:16:54.861357+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=118, request_start_ms=1, request_duration_ms=0, response_start_ms=121, response_duration_ms=1, request_bytes=5069, request_throughput_kbps=85557, response_bytes=95, response_throughput_kbps=625, cache_hit=false}
default	11:16:54.871660+0500	Runner	Task <35E3DA83-4606-47E1-AF56-44700D703635>.<10> finished successfully
default	11:16:54.977924+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:54.979504+0500	Runner	[C1] event: client:connection_reused @18.542s
default	11:16:54.979631+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:54.979649+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:54.979887+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> now using Connection 1
default	11:16:54.980395+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> sent request, body S 5040
default	11:16:55.127734+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> received response, status 200 content K
default	11:16:55.127768+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> done using Connection 1
default	11:16:55.127849+0500	Runner	[C1] event: client:connection_idle @18.690s
default	11:16:55.127939+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:55.128846+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:55.130585+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> response ended
default	11:16:55.130641+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> summary for task success {transaction_duration_ms=151, response_status=200, connection=1, reused=1, reused_after_ms=127, request_start_ms=1, request_duration_ms=0, response_start_ms=148, response_duration_ms=3, request_bytes=5099, request_throughput_kbps=100230, response_bytes=95, response_throughput_kbps=242, cache_hit=false}
default	11:16:55.130799+0500	Runner	Task <CDEDD8B2-E376-42DF-A7CC-5FF900402D99>.<11> finished successfully
default	11:16:55.250427+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:55.251729+0500	Runner	[C1] event: client:connection_reused @18.814s
default	11:16:55.252183+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:55.252218+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:55.252585+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> now using Connection 1
default	11:16:55.253138+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> sent request, body S 4836
default	11:16:55.371607+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> received response, status 200 content K
default	11:16:55.371685+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> done using Connection 1
default	11:16:55.371705+0500	Runner	[C1] event: client:connection_idle @18.934s
default	11:16:55.372098+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:55.372109+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:55.372246+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> response ended
default	11:16:55.372325+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> summary for task success {transaction_duration_ms=121, response_status=200, connection=1, reused=1, reused_after_ms=123, request_start_ms=1, request_duration_ms=0, response_start_ms=120, response_duration_ms=0, request_bytes=4895, request_throughput_kbps=88999, response_bytes=95, response_throughput_kbps=1106, cache_hit=false}
default	11:16:55.372487+0500	Runner	Task <FD5CE851-D992-4EDA-A5DF-DAAB361CCAFB>.<12> finished successfully
default	11:16:55.483618+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:55.485601+0500	Runner	[C1] event: client:connection_reused @19.048s
default	11:16:55.485728+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:55.485817+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:55.486011+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> now using Connection 1
default	11:16:55.487806+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> sent request, body S 4807
default	11:16:55.545413+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:55.545427+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:55.545434+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:55.545444+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:55.545579+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.020561+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> received response, status 200 content K
default	11:16:56.020940+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> done using Connection 1
default	11:16:56.020960+0500	Runner	[C1] event: client:connection_idle @19.581s
default	11:16:56.020988+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:56.021028+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.021136+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> response ended
default	11:16:56.021152+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> summary for task success {transaction_duration_ms=534, response_status=200, connection=1, reused=1, reused_after_ms=113, request_start_ms=1, request_duration_ms=0, response_start_ms=532, response_duration_ms=1, request_bytes=4866, request_throughput_kbps=91164, response_bytes=95, response_throughput_kbps=390, cache_hit=false}
default	11:16:56.021333+0500	Runner	Task <E7F3E3A8-265B-42CE-B8A6-E9D43D1B2937>.<13> finished successfully
default	11:16:56.045418+0500	Runner	App is being debugged, do not track this hang
default	11:16:56.045460+0500	Runner	Hang detected: 0.51s (debugger attached, not reporting)
default	11:16:56.045686+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.045722+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.045748+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.045814+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:56.045967+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.045991+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.046020+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.046129+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.046154+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.046180+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.046432+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:56.046519+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.046575+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.046583+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.046705+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.046736+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:56.046782+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.046817+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.046830+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.055891+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:56.056406+0500	Runner	[C1] event: client:connection_reused @19.619s
default	11:16:56.056476+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:56.056499+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.056524+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> now using Connection 1
default	11:16:56.056710+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> sent request, body S 5172
default	11:16:56.178529+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> received response, status 200 content K
default	11:16:56.178884+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> done using Connection 1
default	11:16:56.179132+0500	Runner	[C1] event: client:connection_idle @19.741s
default	11:16:56.179219+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:56.179244+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.179738+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> response ended
default	11:16:56.180232+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=37, request_start_ms=0, request_duration_ms=0, response_start_ms=122, response_duration_ms=1, request_bytes=5231, request_throughput_kbps=258312, response_bytes=95, response_throughput_kbps=496, cache_hit=false}
default	11:16:56.180455+0500	Runner	Task <66799902-B367-43E3-A492-67ACB2AF1475>.<14> finished successfully
default	11:16:56.300241+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:56.302120+0500	Runner	[C1] event: client:connection_reused @19.864s
default	11:16:56.303602+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:56.304805+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.304975+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> now using Connection 1
default	11:16:56.306689+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> sent request, body S 4949
default	11:16:56.425926+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> received response, status 200 content K
default	11:16:56.425991+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> done using Connection 1
default	11:16:56.426045+0500	Runner	[C1] event: client:connection_idle @19.988s
default	11:16:56.426105+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:56.426168+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.426445+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> response ended
default	11:16:56.426593+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> summary for task success {transaction_duration_ms=125, response_status=200, connection=1, reused=1, reused_after_ms=122, request_start_ms=1, request_duration_ms=0, response_start_ms=124, response_duration_ms=0, request_bytes=5008, request_throughput_kbps=90636, response_bytes=95, response_throughput_kbps=1268, cache_hit=false}
default	11:16:56.426733+0500	Runner	Task <2AB15D52-3BDD-4597-9E5C-563D46ACFC7B>.<15> finished successfully
default	11:16:56.618367+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:56.657357+0500	Runner	[C1] event: client:connection_reused @20.179s
default	11:16:56.657493+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:56.657605+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.657727+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> now using Connection 1
default	11:16:56.657887+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> sent request, body S 4820
default	11:16:56.759239+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> received response, status 200 content K
default	11:16:56.759391+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> done using Connection 1
default	11:16:56.759480+0500	Runner	[C1] event: client:connection_idle @20.322s
default	11:16:56.759582+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:56.759593+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.759905+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> response ended
default	11:16:56.760066+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> summary for task success {transaction_duration_ms=161, response_status=200, connection=1, reused=1, reused_after_ms=202, request_start_ms=29, request_duration_ms=0, response_start_ms=160, response_duration_ms=0, request_bytes=4879, request_throughput_kbps=76680, response_bytes=95, response_throughput_kbps=951, cache_hit=false}
default	11:16:56.760364+0500	Runner	Task <8C0FC46E-9B02-4403-A652-4EFDD73E0965>.<16> finished successfully
default	11:16:56.882025+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:56.882035+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.882044+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.882051+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:56.882061+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.888304+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.888909+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:56.891216+0500	Runner	[C1] event: client:connection_reused @20.452s
default	11:16:56.892134+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:56.892178+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:56.892185+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> now using Connection 1
default	11:16:56.892214+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> sent request, body S 5027
default	11:16:56.893099+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.960783+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:56.960802+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:56.960827+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
fault	11:16:56.974752+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:56.981432+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:56.986094+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:56.986119+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:57.011085+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> received response, status 200 content K
default	11:16:57.011171+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> done using Connection 1
default	11:16:57.011229+0500	Runner	[C1] event: client:connection_idle @20.573s
default	11:16:57.011293+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:57.011301+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.011444+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> response ended
default	11:16:57.011478+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> summary for task success {transaction_duration_ms=121, response_status=200, connection=1, reused=1, reused_after_ms=131, request_start_ms=1, request_duration_ms=0, response_start_ms=121, response_duration_ms=0, request_bytes=5086, request_throughput_kbps=136090, response_bytes=95, response_throughput_kbps=2177, cache_hit=false}
default	11:16:57.011703+0500	Runner	Task <FC3FC9B7-EA4A-4190-9005-866F8E2A49CB>.<17> finished successfully
default	11:16:57.118942+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:57.119570+0500	Runner	[C1] event: client:connection_reused @20.682s
default	11:16:57.119592+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:57.119632+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.119733+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> now using Connection 1
default	11:16:57.119967+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> sent request, body S 4486
default	11:16:57.241482+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> received response, status 200 content K
default	11:16:57.241580+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> done using Connection 1
default	11:16:57.241647+0500	Runner	[C1] event: client:connection_idle @20.804s
default	11:16:57.241705+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:57.241714+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.241799+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> response ended
default	11:16:57.241869+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> summary for task success {transaction_duration_ms=122, response_status=200, connection=1, reused=1, reused_after_ms=108, request_start_ms=0, request_duration_ms=0, response_start_ms=122, response_duration_ms=0, request_bytes=4545, request_throughput_kbps=259582, response_bytes=95, response_throughput_kbps=2122, cache_hit=false}
default	11:16:57.241961+0500	Runner	Task <BC7E1291-6577-43A8-8939-31EEE80103BF>.<18> finished successfully
default	11:16:57.366957+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:57.376667+0500	Runner	[C1] event: client:connection_reused @20.928s
default	11:16:57.377068+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:57.377556+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.377727+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> now using Connection 1
default	11:16:57.378240+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> sent request, body S 4861
default	11:16:57.485315+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> received response, status 200 content K
default	11:16:57.486685+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> done using Connection 1
default	11:16:57.486742+0500	Runner	[C1] event: client:connection_idle @21.049s
default	11:16:57.486783+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:57.486793+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.487008+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> response ended
default	11:16:57.487226+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> summary for task success {transaction_duration_ms=121, response_status=200, connection=1, reused=1, reused_after_ms=124, request_start_ms=0, request_duration_ms=0, response_start_ms=119, response_duration_ms=1, request_bytes=4920, request_throughput_kbps=192859, response_bytes=95, response_throughput_kbps=409, cache_hit=false}
default	11:16:57.487339+0500	Runner	Task <1C5E0617-F894-4313-8FAB-0A9C3DA14A6C>.<19> finished successfully
default	11:16:57.602885+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:57.604706+0500	Runner	[C1] event: client:connection_reused @21.167s
default	11:16:57.604814+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:57.604881+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.605062+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> now using Connection 1
default	11:16:57.605575+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> sent request, body S 4796
default	11:16:57.725975+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> received response, status 200 content K
default	11:16:57.726038+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> done using Connection 1
default	11:16:57.726279+0500	Runner	[C1] event: client:connection_idle @21.288s
default	11:16:57.726356+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:57.726383+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.726511+0500	Runner	nw_connection_add_timestamp_locked_on_nw_queue [C1] Hit maximum timestamp count, will start dropping events
default	11:16:57.726923+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> response ended
default	11:16:57.727334+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=117, request_start_ms=1, request_duration_ms=0, response_start_ms=122, response_duration_ms=1, request_bytes=4855, request_throughput_kbps=94961, response_bytes=95, response_throughput_kbps=618, cache_hit=false}
default	11:16:57.727591+0500	Runner	Task <DFC09950-D884-48EF-AF06-29C2FA6FCE22>.<20> finished successfully
default	11:16:57.836575+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:57.837871+0500	Runner	[C1] event: client:connection_reused @21.400s
default	11:16:57.838095+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:57.838104+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.838170+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> now using Connection 1
default	11:16:57.838598+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> sent request, body S 5059
default	11:16:57.960303+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> received response, status 200 content K
default	11:16:57.961534+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> done using Connection 1
default	11:16:57.961898+0500	Runner	[C1] event: client:connection_idle @21.523s
default	11:16:57.963298+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:57.963412+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:57.965650+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> response ended
default	11:16:57.965681+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> summary for task success {transaction_duration_ms=126, response_status=200, connection=1, reused=1, reused_after_ms=111, request_start_ms=1, request_duration_ms=0, response_start_ms=122, response_duration_ms=3, request_bytes=5118, request_throughput_kbps=131645, response_bytes=95, response_throughput_kbps=239, cache_hit=false}
default	11:16:57.965928+0500	Runner	Task <DF78BF00-5F94-43B7-99A2-4FC81CCBB87D>.<21> finished successfully
default	11:16:58.074408+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:58.076054+0500	Runner	[C1] event: client:connection_reused @21.638s
default	11:16:58.076129+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:58.076214+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.076396+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> now using Connection 1
default	11:16:58.077013+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> sent request, body S 4890
default	11:16:58.199115+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> received response, status 200 content K
default	11:16:58.199548+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> done using Connection 1
default	11:16:58.199939+0500	Runner	[C1] event: client:connection_idle @21.762s
default	11:16:58.200011+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:58.200069+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.200390+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> response ended
default	11:16:58.200825+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> summary for task success {transaction_duration_ms=125, response_status=200, connection=1, reused=1, reused_after_ms=114, request_start_ms=1, request_duration_ms=0, response_start_ms=123, response_duration_ms=1, request_bytes=4949, request_throughput_kbps=83363, response_bytes=95, response_throughput_kbps=491, cache_hit=false}
default	11:16:58.201024+0500	Runner	Task <34084E50-BEE9-4910-A0BB-52CFAA771978>.<22> finished successfully
default	11:16:58.307549+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:58.309590+0500	Runner	[C1] event: client:connection_reused @21.871s
default	11:16:58.310950+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:58.310970+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.311060+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> now using Connection 1
default	11:16:58.311197+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> sent request, body S 4696
default	11:16:58.438952+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> received response, status 200 content K
default	11:16:58.439198+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> done using Connection 1
default	11:16:58.440094+0500	Runner	[C1] event: client:connection_idle @22.001s
default	11:16:58.440131+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:58.440213+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.440639+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> response ended
default	11:16:58.440653+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> summary for task success {transaction_duration_ms=131, response_status=200, connection=1, reused=1, reused_after_ms=109, request_start_ms=2, request_duration_ms=0, response_start_ms=130, response_duration_ms=0, request_bytes=4755, request_throughput_kbps=136310, response_bytes=95, response_throughput_kbps=800, cache_hit=false}
default	11:16:58.440947+0500	Runner	Task <C412CB9E-EDED-4A85-804D-B60033584E0A>.<23> finished successfully
default	11:16:58.511961+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:16:58.518134+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:58.518163+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:58.518599+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:58.518611+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:58.529335+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:58.536546+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:58.558305+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:16:58.558311+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:16:58.558320+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:16:58.559500+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:58.560720+0500	Runner	[C1] event: client:connection_reused @22.123s
default	11:16:58.560789+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:58.560796+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.561214+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> now using Connection 1
default	11:16:58.561953+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> sent request, body S 14290
fault	11:16:58.572820+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:16:58.581983+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:16:58.604043+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:16:58.628920+0500	Runner	nw_path_libinfo_path_check [873CE7B5-9CF3-43A1-ACFE-DF658CC0F8FB acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:58.644946+0500	Runner	nw_path_libinfo_path_check [28432591-9ECE-44DA-A424-D08C0658C2D6 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:58.679155+0500	Runner	flutter: ProfileScreen: authState session = true
default	11:16:58.679259+0500	Runner	flutter: ProfileScreen: user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3, onboardingCompleted = true
default	11:16:58.683681+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> received response, status 200 content K
default	11:16:58.683757+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> done using Connection 1
default	11:16:58.683814+0500	Runner	[C1] event: client:connection_idle @22.246s
default	11:16:58.683841+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:58.683900+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:58.684067+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> response ended
default	11:16:58.684226+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=121, request_start_ms=1, request_duration_ms=0, response_start_ms=123, response_duration_ms=0, request_bytes=14350, request_throughput_kbps=404287, response_bytes=95, response_throughput_kbps=1953, cache_hit=false}
default	11:16:58.684344+0500	Runner	Task <CD946367-FA3C-4246-B5F8-E8F511A5E8AC>.<24> finished successfully
default	11:16:58.724014+0500	Runner	nw_path_libinfo_path_check [7DAD83AA-514A-4CB9-85A0-83CEAC2D05B3 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:58.724308+0500	Runner	flutter: ProfileScreen: authState session = true
default	11:16:58.724314+0500	Runner	flutter: ProfileScreen: user = 4e46bca3-e742-4bb4-bc97-1e5832d753a3, onboardingCompleted = true
default	11:16:59.206883+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:16:59.207873+0500	Runner	[C1] event: client:connection_reused @22.770s
default	11:16:59.207959+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:16:59.207971+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:59.208116+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> now using Connection 1
default	11:16:59.208873+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> sent request, body S 4856
default	11:16:59.224849+0500	Runner	App is being debugged, do not track this hang
default	11:16:59.224898+0500	Runner	Hang detected: 0.50s (debugger attached, not reporting)
default	11:16:59.227904+0500	Runner	nw_path_libinfo_path_check [3D4CF2E0-B61D-4F58-B01E-53CD0A596F45 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	11:16:59.315623+0500	Runner	[0x1056717c0] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:59.319756+0500	Runner	[0x1056717c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:16:59.342214+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> received response, status 200 content K
default	11:16:59.342319+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> done using Connection 1
default	11:16:59.342355+0500	Runner	[C1] event: client:connection_idle @22.890s
default	11:16:59.342526+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:16:59.344753+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:16:59.349736+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> response ended
default	11:16:59.349792+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> summary for task success {transaction_duration_ms=136, response_status=200, connection=1, reused=1, reused_after_ms=524, request_start_ms=0, request_duration_ms=0, response_start_ms=120, response_duration_ms=16, request_bytes=4915, request_throughput_kbps=85851, response_bytes=95, response_throughput_kbps=46, cache_hit=false}
default	11:16:59.350666+0500	Runner	Task <A7586358-7826-4812-8FAE-B2B01609AEDB>.<25> finished successfully
default	11:16:59.424932+0500	Runner	[0x105671540] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	11:16:59.426956+0500	Runner	[0x105671540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:17:00.979753+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:00.980034+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:00.980143+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:01.046299+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:01.046325+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:01.046353+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:01.058235+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:01.058295+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:01.058332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:01.077147+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:01.077230+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:01.077584+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:01.077634+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:01.090972+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
fault	11:17:01.131638+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:17:01.145231+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 00 F0 8E 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 E0 09 8F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C D8 6E 1F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C F4 C8 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 48 C4 1B 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 40 56 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 54 37 1E 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 88 E0 21 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 78 F1 2F 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C C4 F1 2F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 00 DC 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 C0 D8 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 34 D4 04 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 BC DA 01 00 B4 A0 23 3B F3 7D 3E F6 A9 77 E4 F3 61 99 C5 A4 6C CA 01 00 36 88 15 0F 0F FF 38 A4 91 49 10 B3 C4 7B 53 B1 98 14 00 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 A4 DB 09 00 A0 E1 CE FB FD 01 36 F9 B8 23 51 B0 92 E4 DB C6 78 6A 04 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 28 44 00 00 EF 27 E3 86 3C FF 37 52 B1 52 D9 6A 0A A9 EF FD 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:17:01.947875+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:01.947906+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:01.947920+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:01.947940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:01.949242+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:02.010392+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:02.010463+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:02.010761+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:02.522502+0500	Runner	App is being debugged, do not track this hang
default	11:17:02.522551+0500	Runner	Hang detected: 0.51s (debugger attached, not reporting)
default	11:17:02.522733+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:17:02.532099+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:02.532880+0500	Runner	[C1] event: client:connection_reused @26.095s
default	11:17:02.532969+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:02.532977+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:02.533047+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> now using Connection 1
default	11:17:02.533435+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> sent request, body S 5080
default	11:17:02.710848+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> received response, status 200 content K
default	11:17:02.712021+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> done using Connection 1
default	11:17:02.712806+0500	Runner	[C1] event: client:connection_idle @26.265s
default	11:17:02.712991+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:02.713038+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:02.713268+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> response ended
default	11:17:02.713289+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> summary for task success {transaction_duration_ms=177, response_status=200, connection=1, reused=1, reused_after_ms=3196, request_start_ms=0, request_duration_ms=0, response_start_ms=170, response_duration_ms=7, request_bytes=5139, request_throughput_kbps=125362, response_bytes=95, response_throughput_kbps=104, cache_hit=false}
default	11:17:02.713335+0500	Runner	Task <39B3046B-8011-49A2-82B0-3EDF8315EE3C>.<26> finished successfully
default	11:17:02.816745+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:02.817807+0500	Runner	[C1] event: client:connection_reused @26.380s
default	11:17:02.818011+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:02.818027+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:02.818034+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> now using Connection 1
default	11:17:02.818299+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> sent request, body S 5056
default	11:17:02.939230+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> received response, status 200 content K
default	11:17:02.939812+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> done using Connection 1
default	11:17:02.940088+0500	Runner	[C1] event: client:connection_idle @26.502s
default	11:17:02.940488+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:02.940536+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:02.941677+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> response ended
default	11:17:02.941956+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> summary for task success {transaction_duration_ms=124, response_status=200, connection=1, reused=1, reused_after_ms=110, request_start_ms=0, request_duration_ms=0, response_start_ms=121, response_duration_ms=2, request_bytes=5115, request_throughput_kbps=151550, response_bytes=95, response_throughput_kbps=343, cache_hit=false}
default	11:17:02.942136+0500	Runner	Task <E6DC5B60-671B-4CE6-B5FC-6FCC918388BE>.<27> finished successfully
default	11:17:03.055941+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:03.057949+0500	Runner	[C1] event: client:connection_reused @26.620s
default	11:17:03.058053+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:03.058163+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.058311+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> now using Connection 1
default	11:17:03.058918+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> sent request, body S 5056
default	11:17:03.181451+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> received response, status 200 content K
default	11:17:03.181685+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> done using Connection 1
default	11:17:03.181750+0500	Runner	[C1] event: client:connection_idle @26.744s
default	11:17:03.181870+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:03.181885+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.182332+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> response ended
default	11:17:03.182740+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> summary for task success {transaction_duration_ms=125, response_status=200, connection=1, reused=1, reused_after_ms=117, request_start_ms=1, request_duration_ms=0, response_start_ms=124, response_duration_ms=1, request_bytes=5115, request_throughput_kbps=85601, response_bytes=95, response_throughput_kbps=634, cache_hit=false}
default	11:17:03.183034+0500	Runner	Task <423A8803-1515-4E42-BF2F-F4380C51D9E8>.<28> finished successfully
default	11:17:03.311661+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:03.312232+0500	Runner	[C1] event: client:connection_reused @26.869s
default	11:17:03.312417+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:03.312442+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.313116+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> now using Connection 1
default	11:17:03.314047+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> sent request, body S 5033
default	11:17:03.434977+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> received response, status 200 content K
default	11:17:03.435061+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> done using Connection 1
default	11:17:03.435120+0500	Runner	[C1] event: client:connection_idle @26.997s
default	11:17:03.435163+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:03.435183+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.435586+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> response ended
default	11:17:03.435823+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> summary for task success {transaction_duration_ms=129, response_status=200, connection=1, reused=1, reused_after_ms=125, request_start_ms=4, request_duration_ms=0, response_start_ms=128, response_duration_ms=0, request_bytes=5092, request_throughput_kbps=108344, response_bytes=95, response_throughput_kbps=1106, cache_hit=false}
default	11:17:03.435883+0500	Runner	Task <FC414140-A43B-4404-9442-7393AAC4FFBA>.<29> finished successfully
default	11:17:03.555324+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:03.555931+0500	Runner	[C1] event: client:connection_reused @27.118s
default	11:17:03.556112+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:03.556129+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.556407+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> now using Connection 1
default	11:17:03.557142+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> sent request, body S 4998
default	11:17:03.679353+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> received response, status 200 content K
default	11:17:03.680629+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> done using Connection 1
default	11:17:03.680697+0500	Runner	[C1] event: client:connection_idle @27.243s
default	11:17:03.680843+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:03.680862+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.681368+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> response ended
default	11:17:03.681976+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> summary for task success {transaction_duration_ms=126, response_status=200, connection=1, reused=1, reused_after_ms=120, request_start_ms=1, request_duration_ms=0, response_start_ms=124, response_duration_ms=2, request_bytes=5057, request_throughput_kbps=64311, response_bytes=95, response_throughput_kbps=305, cache_hit=false}
default	11:17:03.682261+0500	Runner	Task <D4BF022F-470F-4216-8B06-DF79B03A4450>.<30> finished successfully
default	11:17:03.799268+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:03.801541+0500	Runner	[C1] event: client:connection_reused @27.363s
default	11:17:03.801819+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:03.801867+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.801902+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> now using Connection 1
default	11:17:03.802329+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> sent request, body S 5000
default	11:17:03.921087+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> received response, status 200 content K
default	11:17:03.934375+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> done using Connection 1
default	11:17:03.934503+0500	Runner	[C1] event: client:connection_idle @27.497s
default	11:17:03.934663+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:03.934684+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:03.935703+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> response ended
default	11:17:03.936211+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> summary for task success {transaction_duration_ms=135, response_status=200, connection=1, reused=1, reused_after_ms=120, request_start_ms=1, request_duration_ms=0, response_start_ms=120, response_duration_ms=14, request_bytes=5059, request_throughput_kbps=74534, response_bytes=95, response_throughput_kbps=51, cache_hit=false}
default	11:17:03.936342+0500	Runner	Task <774A0B05-0438-4DE7-9580-D9D8E891284B>.<31> finished successfully
default	11:17:04.051353+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:04.051656+0500	Runner	[C1] event: client:connection_reused @27.612s
default	11:17:04.051681+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:04.051688+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.051693+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> now using Connection 1
default	11:17:04.051722+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> sent request, body S 5003
default	11:17:04.171256+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> received response, status 200 content K
default	11:17:04.171644+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> done using Connection 1
default	11:17:04.172327+0500	Runner	[C1] event: client:connection_idle @27.734s
default	11:17:04.172770+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:04.172849+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.174299+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> response ended
default	11:17:04.174406+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> summary for task success {transaction_duration_ms=124, response_status=200, connection=1, reused=1, reused_after_ms=114, request_start_ms=0, request_duration_ms=0, response_start_ms=122, response_duration_ms=2, request_bytes=5062, request_throughput_kbps=126566, response_bytes=95, response_throughput_kbps=332, cache_hit=false}
default	11:17:04.179469+0500	Runner	Task <49194F0E-52B9-47D4-9AE9-77541D5BA2D1>.<32> finished successfully
default	11:17:04.283881+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:04.285856+0500	Runner	[C1] event: client:connection_reused @27.848s
default	11:17:04.285933+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:04.285988+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.286775+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> now using Connection 1
default	11:17:04.287190+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> sent request, body S 4919
default	11:17:04.549823+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> received response, status 200 content K
default	11:17:04.551398+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> done using Connection 1
default	11:17:04.551570+0500	Runner	[C1] event: client:connection_idle @28.113s
default	11:17:04.551698+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:04.551894+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.552130+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> response ended
default	11:17:04.552432+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> summary for task success {transaction_duration_ms=267, response_status=200, connection=1, reused=1, reused_after_ms=113, request_start_ms=1, request_duration_ms=0, response_start_ms=264, response_duration_ms=2, request_bytes=4978, request_throughput_kbps=68414, response_bytes=95, response_throughput_kbps=340, cache_hit=false}
default	11:17:04.559765+0500	Runner	Task <9D39FFD4-9866-48C7-98F5-76E914E4AE72>.<33> finished successfully
default	11:17:04.687874+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:04.689647+0500	Runner	[C1] event: client:connection_reused @28.246s
default	11:17:04.689712+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:04.689738+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.689759+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> now using Connection 1
default	11:17:04.689908+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> sent request, body S 4887
default	11:17:04.926248+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> received response, status 200 content K
default	11:17:04.926947+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> done using Connection 1
default	11:17:04.927069+0500	Runner	[C1] event: client:connection_idle @28.489s
default	11:17:04.927195+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:04.927439+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:04.927474+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> response ended
default	11:17:04.927566+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> summary for task success {transaction_duration_ms=244, response_status=200, connection=1, reused=1, reused_after_ms=134, request_start_ms=3, request_duration_ms=0, response_start_ms=243, response_duration_ms=1, request_bytes=4946, request_throughput_kbps=198754, response_bytes=95, response_throughput_kbps=612, cache_hit=false}
default	11:17:04.927711+0500	Runner	Task <7CE57371-673C-4ECD-8146-31C8092869F5>.<34> finished successfully
default	11:17:05.040700+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:05.041929+0500	Runner	[C1] event: client:connection_reused @28.604s
default	11:17:05.042015+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:05.042037+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.042253+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> now using Connection 1
default	11:17:05.042689+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> sent request, body S 4849
default	11:17:05.166043+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> received response, status 200 content K
default	11:17:05.166140+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> done using Connection 1
default	11:17:05.166692+0500	Runner	[C1] event: client:connection_idle @28.727s
default	11:17:05.166775+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:05.166816+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.166973+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> response ended
default	11:17:05.166996+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> summary for task success {transaction_duration_ms=125, response_status=200, connection=1, reused=1, reused_after_ms=115, request_start_ms=1, request_duration_ms=0, response_start_ms=123, response_duration_ms=1, request_bytes=4908, request_throughput_kbps=111575, response_bytes=95, response_throughput_kbps=405, cache_hit=false}
default	11:17:05.167078+0500	Runner	Task <5E058A9D-BBDF-4801-858B-89DD9531FB62>.<35> finished successfully
default	11:17:05.278904+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:05.280431+0500	Runner	[C1] event: client:connection_reused @28.843s
default	11:17:05.280520+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:05.280570+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.280754+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> now using Connection 1
default	11:17:05.281313+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> sent request, body S 4819
default	11:17:05.441150+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> received response, status 200 content K
default	11:17:05.448834+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> done using Connection 1
default	11:17:05.451973+0500	Runner	[C1] event: client:connection_idle @28.968s
default	11:17:05.452090+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:05.452135+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.454010+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> response ended
default	11:17:05.454027+0500	Runner	Task <5CE55833-96C9-4888-A934-F3F6A3D4C420>.<36> summary for task success {transaction_duration_ms=136, response_status=200, connection=1, reused=1, reused_after_ms=115, request_start_ms=1, request_duration_ms=0, response_start_ms=125, response_duration_ms=11, request_bytes=4878, request_throughput_kbps=87904, response_bytes=95, response_throughput_kbps=69, cache_hit=false}
default	11:17:05.526823+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:05.527698+0500	Runner	[C1] event: client:connection_reused @29.090s
default	11:17:05.527767+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:05.527780+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.527915+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> now using Connection 1
default	11:17:05.528220+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> sent request, body S 4783
default	11:17:05.660969+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> received response, status 200 content K
default	11:17:05.661256+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> done using Connection 1
default	11:17:05.661353+0500	Runner	[C1] event: client:connection_idle @29.224s
default	11:17:05.661398+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:05.661437+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.661778+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> response ended
default	11:17:05.661978+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> summary for task success {transaction_duration_ms=134, response_status=200, connection=1, reused=1, reused_after_ms=112, request_start_ms=0, request_duration_ms=0, response_start_ms=133, response_duration_ms=0, request_bytes=4842, request_throughput_kbps=156824, response_bytes=95, response_throughput_kbps=800, cache_hit=false}
default	11:17:05.662096+0500	Runner	Task <68E12113-A628-4DE3-9F0B-AC0866FA7B34>.<37> finished successfully
default	11:17:05.776894+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:05.780314+0500	Runner	[C1] event: client:connection_reused @29.341s
default	11:17:05.780889+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:05.780903+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.780936+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> now using Connection 1
default	11:17:05.780987+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> sent request, body S 4794
default	11:17:05.922164+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> received response, status 200 content K
default	11:17:05.930912+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> done using Connection 1
default	11:17:05.931011+0500	Runner	[C1] event: client:connection_idle @29.483s
default	11:17:05.933170+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:05.936857+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:05.937122+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> response ended
default	11:17:05.937192+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> summary for task success {transaction_duration_ms=153, response_status=200, connection=1, reused=1, reused_after_ms=118, request_start_ms=2, request_duration_ms=0, response_start_ms=142, response_duration_ms=9, request_bytes=4853, request_throughput_kbps=83679, response_bytes=95, response_throughput_kbps=76, cache_hit=false}
default	11:17:05.937298+0500	Runner	Task <FEB79892-365C-457C-BEB2-15D8D9D97AF1>.<38> finished successfully
default	11:17:06.017129+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied_change @29.577s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:17:06.017162+0500	Runner	[C1 34.120.62.213:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied_change @29.577s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:17:06.022216+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 ready resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied_change @29.582s, uuid: A799E591-ED3E-4F84-82FE-0424F73E5E26
default	11:17:06.022411+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied_change @29.582s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:17:06.022438+0500	Runner	[C1 34.120.62.213:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied_change @29.582s, uuid: 09052443-D0BD-4479-98F8-57A16EAFAB94
default	11:17:06.022785+0500	Runner	-[NWConcrete_nw_resolver initWithEndpoint:parameters:path:log_str:] [R2] created for sentry.io:0 using: generic, attribution: developer
default	11:17:06.025875+0500	Runner	nw_resolver_set_update_handler_block_invoke [R2] started
default	11:17:06.030894+0500	Runner	nw_endpoint_resolver_update [C2.1 dry-run o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Adding endpoint handler for 34.120.62.213:443
default	11:17:06.046813+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:06.048989+0500	Runner	[C1] event: client:connection_reused @29.610s
default	11:17:06.049058+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:06.049088+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.049118+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> now using Connection 1
default	11:17:06.049662+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> sent request, body S 4771
default	11:17:06.180979+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> received response, status 200 content K
default	11:17:06.181155+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> done using Connection 1
default	11:17:06.181278+0500	Runner	[C1] event: client:connection_idle @29.743s
default	11:17:06.181360+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:06.181401+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.181575+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> response ended
default	11:17:06.181926+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> summary for task success {transaction_duration_ms=134, response_status=200, connection=1, reused=1, reused_after_ms=126, request_start_ms=1, request_duration_ms=0, response_start_ms=133, response_duration_ms=0, request_bytes=4830, request_throughput_kbps=126270, response_bytes=95, response_throughput_kbps=849, cache_hit=false}
default	11:17:06.182128+0500	Runner	Task <58545573-FB1E-4E00-B080-FE845D0FC375>.<39> finished successfully
default	11:17:06.288981+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:06.290019+0500	Runner	[C1] event: client:connection_reused @29.852s
default	11:17:06.290137+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:06.290165+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.290322+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> now using Connection 1
default	11:17:06.290643+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> sent request, body S 5065
default	11:17:06.412585+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> received response, status 200 content K
default	11:17:06.412720+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> done using Connection 1
default	11:17:06.412866+0500	Runner	[C1] event: client:connection_idle @29.975s
default	11:17:06.412894+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:06.412913+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.413237+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> response ended
default	11:17:06.413496+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> summary for task success {transaction_duration_ms=123, response_status=200, connection=1, reused=1, reused_after_ms=108, request_start_ms=0, request_duration_ms=0, response_start_ms=122, response_duration_ms=0, request_bytes=5124, request_throughput_kbps=162661, response_bytes=95, response_throughput_kbps=875, cache_hit=false}
default	11:17:06.413779+0500	Runner	Task <CD218C50-8C34-407D-9A9C-FD6EE8135D85>.<40> finished successfully
default	11:17:06.530622+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:06.531621+0500	Runner	[C1] event: client:connection_reused @30.094s
default	11:17:06.531805+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:06.531819+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.531992+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> now using Connection 1
default	11:17:06.532370+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> sent request, body S 19108
default	11:17:06.655051+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> received response, status 200 content K
default	11:17:06.655255+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> done using Connection 1
default	11:17:06.655318+0500	Runner	[C1] event: client:connection_idle @30.218s
default	11:17:06.655416+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:06.655428+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.655777+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> response ended
default	11:17:06.656135+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> summary for task success {transaction_duration_ms=124, response_status=200, connection=1, reused=1, reused_after_ms=118, request_start_ms=0, request_duration_ms=0, response_start_ms=123, response_duration_ms=1, request_bytes=19177, request_throughput_kbps=501342, response_bytes=95, response_throughput_kbps=739, cache_hit=false}
default	11:17:06.656296+0500	Runner	Task <ECDD9DB7-6522-4207-9542-E951C0D8A02A>.<41> finished successfully
default	11:17:06.766463+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:06.768522+0500	Runner	[C1] event: client:connection_reused @30.330s
default	11:17:06.768608+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:06.768629+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.768893+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> now using Connection 1
default	11:17:06.769768+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> sent request, body S 4605
default	11:17:06.898889+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> received response, status 200 content K
default	11:17:06.899194+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> done using Connection 1
default	11:17:06.899312+0500	Runner	[C1] event: client:connection_idle @30.462s
default	11:17:06.900187+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:06.900275+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:06.900728+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> response ended
default	11:17:06.901556+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> summary for task success {transaction_duration_ms=133, response_status=200, connection=1, reused=1, reused_after_ms=113, request_start_ms=1, request_duration_ms=0, response_start_ms=131, response_duration_ms=1, request_bytes=4664, request_throughput_kbps=82367, response_bytes=95, response_throughput_kbps=380, cache_hit=false}
default	11:17:06.901803+0500	Runner	Task <247F6A38-8173-43F5-9A54-4D79A22FD502>.<42> finished successfully
default	11:17:07.016892+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:07.018464+0500	Runner	[C1] event: client:connection_reused @30.581s
default	11:17:07.018531+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:07.018606+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:07.018892+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> now using Connection 1
default	11:17:07.019390+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> sent request, body S 4784
default	11:17:07.205111+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> received response, status 200 content K
default	11:17:07.206033+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> done using Connection 1
default	11:17:07.206095+0500	Runner	[C1] event: client:connection_idle @30.768s
default	11:17:07.206249+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:07.206273+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:07.206451+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> response ended
default	11:17:07.207022+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> summary for task success {transaction_duration_ms=189, response_status=200, connection=1, reused=1, reused_after_ms=119, request_start_ms=1, request_duration_ms=0, response_start_ms=187, response_duration_ms=1, request_bytes=4843, request_throughput_kbps=95675, response_bytes=95, response_throughput_kbps=481, cache_hit=false}
default	11:17:07.207163+0500	Runner	Task <B92C6210-37CC-40F3-93CC-03C1543B5163>.<43> finished successfully
default	11:17:10.553320+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:10.554593+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:10.554610+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:10.554624+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:10.601067+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:10.601238+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:10.609373+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:10.610080+0500	Runner	[C1] event: client:connection_reused @34.172s
default	11:17:10.610145+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:10.610166+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:10.610362+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> now using Connection 1
default	11:17:10.610666+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> sent request, body S 17212
default	11:17:10.659359+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:10.659899+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:10.660074+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:10.667584+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:17:10.765419+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> received response, status 200 content K
default	11:17:10.765441+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> done using Connection 1
default	11:17:10.765551+0500	Runner	[C1] event: client:connection_idle @34.328s
default	11:17:10.766071+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:10.766093+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:10.766921+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> response ended
default	11:17:10.767057+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> summary for task success {transaction_duration_ms=157, response_status=200, connection=1, reused=1, reused_after_ms=3403, request_start_ms=0, request_duration_ms=0, response_start_ms=154, response_duration_ms=1, request_bytes=17281, request_throughput_kbps=763971, response_bytes=95, response_throughput_kbps=394, cache_hit=false}
default	11:17:10.767332+0500	Runner	Task <D562C33D-8717-44AA-BBCF-03E35D2BDEB6>.<44> finished successfully
default	11:17:11.583340+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:11.583368+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:11.583460+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:11.583486+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:11.590198+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:11.605274+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:11.606381+0500	Runner	[C1] event: client:connection_reused @35.169s
default	11:17:11.606684+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:11.606697+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:11.606704+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> now using Connection 1
default	11:17:11.607223+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> sent request, body S 4714
default	11:17:11.694799+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:11.694957+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:11.695817+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:11.701325+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:17:11.819076+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> received response, status 200 content K
default	11:17:11.819395+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> done using Connection 1
default	11:17:11.819643+0500	Runner	[C1] event: client:connection_idle @35.382s
default	11:17:11.819906+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:11.819967+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:11.820600+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> response ended
default	11:17:11.821209+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> summary for task success {transaction_duration_ms=215, response_status=200, connection=1, reused=1, reused_after_ms=840, request_start_ms=1, request_duration_ms=0, response_start_ms=212, response_duration_ms=2, request_bytes=4773, request_throughput_kbps=90279, response_bytes=95, response_throughput_kbps=357, cache_hit=false}
default	11:17:11.821588+0500	Runner	Task <DA98653D-67DF-4B73-AB1A-EA6BE2D36406>.<45> finished successfully
default	11:17:14.579510+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:14.579914+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:14.579936+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:14.579967+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:14.580307+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:14.626703+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:14.637027+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	11:17:14.637600+0500	Runner	[C1] event: client:connection_reused @38.200s
default	11:17:14.637644+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	11:17:14.637653+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:14.637779+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> now using Connection 1
default	11:17:14.638011+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> sent request, body S 17212
default	11:17:14.683146+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:14.683195+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:14.683265+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:14.684916+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	11:17:14.766532+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> received response, status 200 content K
default	11:17:14.766976+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> done using Connection 1
default	11:17:14.767256+0500	Runner	[C1] event: client:connection_idle @38.329s
default	11:17:14.767389+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	11:17:14.767472+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	11:17:14.768888+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> response ended
default	11:17:14.768943+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> summary for task success {transaction_duration_ms=130, response_status=200, connection=1, reused=1, reused_after_ms=2817, request_start_ms=0, request_duration_ms=0, response_start_ms=128, response_duration_ms=1, request_bytes=17281, request_throughput_kbps=625516, response_bytes=95, response_throughput_kbps=476, cache_hit=false}
default	11:17:14.769222+0500	Runner	Task <834280A4-B801-4B3E-A458-1A649F02606A>.<46> finished successfully
default	11:17:15.483844+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:15.485492+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.486391+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.487255+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.500478+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.500504+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.500591+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.512885+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.512902+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.512923+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.533052+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.533083+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.533148+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.549402+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.549462+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.549501+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.570436+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.582463+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:15.582472+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:15.582480+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:15.585187+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:17:15.586270+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120ff0>
default	11:17:15.586302+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:15.586323+0500	Runner	Deactivation reason added: 0; deactivation reasons: 0 -> 1; animating application lifecycle event: 1
default	11:17:15.586333+0500	Runner	App transitioned to background, suspending HangTracing.
default	11:17:15.586359+0500	Runner	App with bundleID:bizlevel.kz is no longer foreground at time=22160224784913, attempting to emit telemetry with emission type: HTFGUpdateAppBackgrounded
default	11:17:15.593069+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:15.593152+0500	Runner	Creating new background assertion
default	11:17:15.593174+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131535450>
default	11:17:15.593199+0500	Runner	Deactivation reason added: 12; deactivation reasons: 1 -> 4097; animating application lifecycle event: 1
default	11:17:15.593234+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535450>
default	11:17:15.593300+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c440>: taskID = 12, taskName = GDTStorage, creationTime = 923342 (elapsed = 0).
default	11:17:15.597630+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 12
default	11:17:15.597665+0500	Runner	Ending task with identifier 12 and description: <_UIBackgroundTaskInfo: 0x13f11c440>: taskID = 12, taskName = GDTStorage, creationTime = 923342 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120cc0>
default	11:17:15.597676+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535450> (used by background task with identifier 12: <_UIBackgroundTaskInfo: 0x13f11c440>: taskID = 12, taskName = GDTStorage, creationTime = 923342 (elapsed = 0))
default	11:17:15.597685+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131535450> for task identifier: 12
default	11:17:15.597692+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120b70>
default	11:17:15.597700+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:15.598067+0500	Runner	Creating new background assertion
default	11:17:15.598084+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534780>
default	11:17:15.598172+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534780>
default	11:17:15.598189+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c4c0>: taskID = 13, taskName = GDTStorage, creationTime = 923342 (elapsed = 0).
default	11:17:15.598201+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 13
default	11:17:15.598227+0500	Runner	Ending task with identifier 13 and description: <_UIBackgroundTaskInfo: 0x13f11c4c0>: taskID = 13, taskName = GDTStorage, creationTime = 923342 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120960>
default	11:17:15.598546+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534780> (used by background task with identifier 13: <_UIBackgroundTaskInfo: 0x13f11c4c0>: taskID = 13, taskName = GDTStorage, creationTime = 923342 (elapsed = 0))
default	11:17:15.598557+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534780> for task identifier: 13
default	11:17:15.598896+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120780>
default	11:17:15.599661+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:15.599700+0500	Runner	Creating new background assertion
default	11:17:15.599706+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131535400>
default	11:17:15.599746+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535400>
default	11:17:15.599776+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c240>: taskID = 14, taskName = GDTStorage, creationTime = 923342 (elapsed = 0).
default	11:17:15.599878+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 14
default	11:17:15.599910+0500	Runner	Ending task with identifier 14 and description: <_UIBackgroundTaskInfo: 0x13f11c240>: taskID = 14, taskName = GDTStorage, creationTime = 923342 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120a20>
default	11:17:15.599919+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535400> (used by background task with identifier 14: <_UIBackgroundTaskInfo: 0x13f11c240>: taskID = 14, taskName = GDTStorage, creationTime = 923342 (elapsed = 0))
default	11:17:15.599946+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131535400> for task identifier: 14
default	11:17:15.599983+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120c30>
default	11:17:15.600241+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:15.600260+0500	Runner	Creating new background assertion
default	11:17:15.600275+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534690>
default	11:17:15.600464+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534690>
default	11:17:15.600470+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 15, taskName = GDTStorage, creationTime = 923342 (elapsed = 0).
default	11:17:15.600532+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 15
default	11:17:15.600549+0500	Runner	Ending task with identifier 15 and description: <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 15, taskName = GDTStorage, creationTime = 923342 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120960>
default	11:17:15.600585+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534690> (used by background task with identifier 15: <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 15, taskName = GDTStorage, creationTime = 923342 (elapsed = 0))
default	11:17:15.600770+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534690> for task identifier: 15
default	11:17:15.600857+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f1207e0>
default	11:17:15.600872+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:15.600883+0500	Runner	Creating new background assertion
default	11:17:15.600930+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534ff0>
default	11:17:15.601372+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534ff0>
default	11:17:15.601398+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c500>: taskID = 16, taskName = GDTStorage, creationTime = 923342 (elapsed = 0).
default	11:17:15.601434+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 16
default	11:17:15.601457+0500	Runner	Ending task with identifier 16 and description: <_UIBackgroundTaskInfo: 0x13f11c500>: taskID = 16, taskName = GDTStorage, creationTime = 923342 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120a20>
default	11:17:15.601468+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534ff0> (used by background task with identifier 16: <_UIBackgroundTaskInfo: 0x13f11c500>: taskID = 16, taskName = GDTStorage, creationTime = 923342 (elapsed = 0))
default	11:17:15.601475+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534ff0> for task identifier: 16
default	11:17:15.818768+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:17:15.819025+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:15.819080+0500	Runner	Deactivation reason removed: 12; deactivation reasons: 4097 -> 1; animating application lifecycle event: 1
default	11:17:15.819139+0500	Runner	Send setDeactivating: N (-DeactivationReason:SuspendedEventsOnly)
default	11:17:15.819506+0500	Runner	Deactivation reason removed: 0; deactivation reasons: 1 -> 0; animating application lifecycle event: 0
default	11:17:15.819576+0500	Runner	App transitioned to foreground, resuming HangTracing.
default	11:17:15.819645+0500	Runner	Updating event->rollingFGTimestamp from INVALID_FOREGROUND_TIMESTAMP to 22160230412231
fault	11:17:15.826379+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtURL:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtURL:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 60 7B 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 76 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7E 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 2A 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 3C 30 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D4 D7 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	11:17:15.836360+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 4F 00 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 28 4C 09 00 21 8D A4 DC 72 7A 33 41 B5 9E 8F DB 39 A2 D7 C4 04 72 09 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 60 7B 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C B0 76 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 64 7E 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 10 2A 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 3C 30 08 00 D8 6F B3 0B 65 6F 30 B1 9F DC 2D 4D 71 C7 D3 5C 2C 31 08 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 3C 46 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D0 E2 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 4C CB 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC D4 D7 00 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC 20 9B 01 00 69 ED 11 6D 4E 87 38 79 8D B8 DE BF 0A 1A A2 CC C4 91 01 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 B8 13 00 00 6E 1B E8 6B 58 1A 30 67 90 65 34 12 10 3E 1D F4 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	11:17:15.838246+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:15.891323+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:17.887762+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	11:17:17.888602+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:17.888632+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:17.888676+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:17.900500+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:17.900540+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:17.900976+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:17.915508+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:17.915544+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:17.915781+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:17.932280+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:17:17.932415+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120f90>
default	11:17:17.932609+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:17.932702+0500	Runner	Creating new background assertion
default	11:17:17.932712+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:17.932729+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534d70>
default	11:17:17.932739+0500	Runner	Deactivation reason added: 0; deactivation reasons: 0 -> 1; animating application lifecycle event: 1
default	11:17:17.932920+0500	Runner	App transitioned to background, suspending HangTracing.
default	11:17:17.932960+0500	Runner	App with bundleID:bizlevel.kz is no longer foreground at time=22160281074811, attempting to emit telemetry with emission type: HTFGUpdateAppBackgrounded
default	11:17:17.933002+0500	Runner	Deactivation reason added: 12; deactivation reasons: 1 -> 4097; animating application lifecycle event: 1
default	11:17:17.933258+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534d70>
default	11:17:17.933315+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c540>: taskID = 17, taskName = GDTStorage, creationTime = 923345 (elapsed = 0).
default	11:17:17.933702+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 17
default	11:17:17.934820+0500	Runner	Ending task with identifier 17 and description: <_UIBackgroundTaskInfo: 0x13f11c540>: taskID = 17, taskName = GDTStorage, creationTime = 923345 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:17.934946+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534d70> (used by background task with identifier 17: <_UIBackgroundTaskInfo: 0x13f11c540>: taskID = 17, taskName = GDTStorage, creationTime = 923345 (elapsed = 0))
default	11:17:17.934962+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534d70> for task identifier: 17
default	11:17:17.936068+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120b70>
default	11:17:17.936146+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:17.939893+0500	Runner	Creating new background assertion
default	11:17:17.942909+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x1315354a0>
default	11:17:17.943192+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x1315354a0>
default	11:17:17.943207+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c580>: taskID = 18, taskName = GDTStorage, creationTime = 923345 (elapsed = 0).
default	11:17:17.943276+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 18
default	11:17:17.943306+0500	Runner	Ending task with identifier 18 and description: <_UIBackgroundTaskInfo: 0x13f11c580>: taskID = 18, taskName = GDTStorage, creationTime = 923345 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121140>
default	11:17:17.943315+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x1315354a0> (used by background task with identifier 18: <_UIBackgroundTaskInfo: 0x13f11c580>: taskID = 18, taskName = GDTStorage, creationTime = 923345 (elapsed = 0))
default	11:17:17.943687+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x1315354a0> for task identifier: 18
default	11:17:17.943907+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f1212f0>
default	11:17:17.944226+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:17.945624+0500	Runner	Creating new background assertion
default	11:17:17.945632+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534ff0>
default	11:17:17.945900+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534ff0>
default	11:17:17.946348+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c300>: taskID = 19, taskName = GDTStorage, creationTime = 923345 (elapsed = 0).
default	11:17:17.946407+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 19
default	11:17:17.946439+0500	Runner	Ending task with identifier 19 and description: <_UIBackgroundTaskInfo: 0x13f11c300>: taskID = 19, taskName = GDTStorage, creationTime = 923345 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:17.946641+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534ff0> (used by background task with identifier 19: <_UIBackgroundTaskInfo: 0x13f11c300>: taskID = 19, taskName = GDTStorage, creationTime = 923345 (elapsed = 0))
default	11:17:17.946670+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534ff0> for task identifier: 19
default	11:17:17.946680+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f121470>
default	11:17:17.946688+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:17.946851+0500	Runner	Creating new background assertion
default	11:17:17.946857+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131534780>
default	11:17:17.946882+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:17.946903+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:17.946923+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:17.946949+0500	Runner	Evaluating dispatch of UIEvent: 0x1055f6300; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	11:17:17.946978+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	11:17:17.946985+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131534780>
default	11:17:17.946994+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105648000>; contextId: 0x3C6DE330
default	11:17:17.947011+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c480>: taskID = 20, taskName = GDTStorage, creationTime = 923345 (elapsed = 0).
default	11:17:17.947057+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 20
default	11:17:17.947065+0500	Runner	Ending task with identifier 20 and description: <_UIBackgroundTaskInfo: 0x13f11c480>: taskID = 20, taskName = GDTStorage, creationTime = 923345 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121140>
default	11:17:17.947216+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131534780> (used by background task with identifier 20: <_UIBackgroundTaskInfo: 0x13f11c480>: taskID = 20, taskName = GDTStorage, creationTime = 923345 (elapsed = 0))
default	11:17:17.947223+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131534780> for task identifier: 20
default	11:17:17.947231+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f1209c0>
default	11:17:17.947355+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:17.947364+0500	Runner	Creating new background assertion
default	11:17:17.947462+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131535450>
default	11:17:17.947529+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535450>
default	11:17:17.947596+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 21, taskName = GDTStorage, creationTime = 923345 (elapsed = 0).
default	11:17:17.947638+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 21
default	11:17:17.947751+0500	Runner	Ending task with identifier 21 and description: <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 21, taskName = GDTStorage, creationTime = 923345 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121470>
default	11:17:17.947788+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535450> (used by background task with identifier 21: <_UIBackgroundTaskInfo: 0x13f11c2c0>: taskID = 21, taskName = GDTStorage, creationTime = 923345 (elapsed = 0))
default	11:17:17.947846+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x131535450> for task identifier: 21
default	11:17:18.207298+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.207340+0500	Runner	Deactivation reason added: 5; deactivation reasons: 4097 -> 4129; animating application lifecycle event: 1
default	11:17:18.208034+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.208086+0500	Runner	Deactivation reason removed: 0; deactivation reasons: 4129 -> 4128; animating application lifecycle event: 1
default	11:17:18.285298+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x105470b40; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: none> was:ancestor
default	11:17:18.285687+0500	Runner	Scene target of keyboard event deferring environment did change: 0; scene: UIWindowScene: 0x105774200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	11:17:18.286916+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.292870+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.593197+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.593240+0500	Runner	Deactivation reason added: 3; deactivation reasons: 4128 -> 4136; animating application lifecycle event: 1
default	11:17:18.595325+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.595343+0500	Runner	Deactivation reason removed: 5; deactivation reasons: 4136 -> 4104; animating application lifecycle event: 0
default	11:17:18.652133+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.945543+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.945566+0500	Runner	Deactivation reason added: 5; deactivation reasons: 4104 -> 4136; animating application lifecycle event: 1
default	11:17:18.960733+0500	Runner	Received state update for 51431 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	11:17:18.973082+0500	Runner	[(FBSceneManager):sceneID:bizlevel.kz-default] Received action(s) in scene-update: FBSceneSnapshotAction
default	11:17:18.980678+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: 830327B3-0D56-4869-9F05-48C82BF30B34
default	11:17:18.980694+0500	Runner	[0x11e2a4280] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:17:18.980784+0500	Runner	[0x110095cc0] Session canceled.
default	11:17:18.980928+0500	Runner	Deactivation reason added: 11; deactivation reasons: 4136 -> 6184; animating application lifecycle event: 0
default	11:17:18.982212+0500	Runner	Will add backgroundTask with taskName: _UIRemoteKeyboard XPC disconnection, expirationHandler: (null)
default	11:17:18.982268+0500	Runner	Creating new assertion because there is no existing background assertion.
default	11:17:18.982287+0500	Runner	Creating new background assertion
default	11:17:18.982397+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.983270+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f121d70>
default	11:17:18.996084+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996108+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11cf40>: taskID = 22, taskName = _UIRemoteKeyboard XPC disconnection, creationTime = 923346 (elapsed = 0).
default	11:17:18.996151+0500	Runner	bizlevel.kz(51431) invalidateConnection (appDidSuspend)
default	11:17:18.996164+0500	Runner	[0x11e2a4640] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	11:17:18.996222+0500	Runner	Will add backgroundTask with taskName: Flutter debug task, expirationHandler: <__NSMallocBlock__: 0x13f121d10>
default	11:17:18.996233+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996244+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996249+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996264+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996352+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11c300>: taskID = 23, taskName = Flutter debug task, creationTime = 923346 (elapsed = 0).
default	11:17:18.996594+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 24, taskName = GDTStorage, creationTime = 923346 (elapsed = 0).
default	11:17:18.996634+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 24
default	11:17:18.996640+0500	Runner	Ending task with identifier 24 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 24, taskName = GDTStorage, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121d70>
default	11:17:18.996792+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 24: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 24, taskName = GDTStorage, creationTime = 923346 (elapsed = 0))
default	11:17:18.996803+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f121f20>
default	11:17:18.996814+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996825+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.996840+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 25, taskName = GDTStorage, creationTime = 923346 (elapsed = 0).
default	11:17:18.996880+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 25
default	11:17:18.997102+0500	Runner	Ending task with identifier 25 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 25, taskName = GDTStorage, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121f20>
default	11:17:18.997237+0500	Runner	agent connection cancelled (details: Session manually canceled)
default	11:17:18.997284+0500	Runner	[0x110095cc0] Disposing of session
default	11:17:18.997308+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 25: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 25, taskName = GDTStorage, creationTime = 923346 (elapsed = 0))
default	11:17:18.997337+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f121f50>
default	11:17:18.997354+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.997365+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.997371+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 26, taskName = GDTStorage, creationTime = 923346 (elapsed = 0).
default	11:17:18.997545+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 26
default	11:17:18.997558+0500	Runner	Ending task with identifier 26 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 26, taskName = GDTStorage, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121f50>
default	11:17:18.997569+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 26: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 26, taskName = GDTStorage, creationTime = 923346 (elapsed = 0))
default	11:17:18.997575+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f121f80>
default	11:17:18.997586+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.997625+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.997769+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 27, taskName = GDTStorage, creationTime = 923346 (elapsed = 0).
default	11:17:18.997824+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 27
default	11:17:18.997836+0500	Runner	Ending task with identifier 27 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 27, taskName = GDTStorage, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121f80>
default	11:17:18.997843+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 27: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 27, taskName = GDTStorage, creationTime = 923346 (elapsed = 0))
default	11:17:18.997848+0500	Runner	Will add backgroundTask with taskName: GDTStorage, expirationHandler: <__NSMallocBlock__: 0x13f120f90>
default	11:17:18.998447+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.998477+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.998483+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 28, taskName = GDTStorage, creationTime = 923346 (elapsed = 0).
default	11:17:18.998490+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 28
default	11:17:18.998498+0500	Runner	Ending task with identifier 28 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 28, taskName = GDTStorage, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120f90>
default	11:17:18.998512+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 28: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 28, taskName = GDTStorage, creationTime = 923346 (elapsed = 0))
default	11:17:18.998691+0500	Runner	Will add backgroundTask with taskName: com.apple.asset_manager.cache_resource_cleanup, expirationHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:18.998727+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.998744+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.998769+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 29, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0).
default	11:17:18.998789+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 29
default	11:17:18.998817+0500	Runner	Ending task with identifier 29 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 29, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:18.998836+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 29: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 29, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0))
default	11:17:18.999449+0500	Runner	Will add backgroundTask with taskName: com.apple.asset_manager.cache_resource_cleanup, expirationHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:18.999455+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.999466+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:18.999475+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 30, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0).
default	11:17:18.999494+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 30
default	11:17:19.999505+0500	Runner	Ending task with identifier 30 and description: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 30, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f120d50>
default	11:17:19.999524+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 30: <_UIBackgroundTaskInfo: 0x13f11ce40>: taskID = 30, taskName = com.apple.asset_manager.cache_resource_cleanup, creationTime = 923346 (elapsed = 0))
default	11:17:19.001981+0500	Runner	MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/0A091418-1DCE-444F-899B-9AF383F4E47F/Library/Saved Application State/bizlevel.kz.savedState)
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
default	11:17:19.003664+0500	Runner	Deactivation reason removed: 3; deactivation reasons: 6184 -> 6176; animating application lifecycle event: 0
default	11:17:19.003705+0500	Runner	Deactivation reason removed: 5; deactivation reasons: 6176 -> 6144; animating application lifecycle event: 0
default	11:17:19.003953+0500	Runner	Will add backgroundTask with taskName: com.apple.uikit.applicationSnapshot, expirationHandler: <__NSMallocBlock__: 0x13f121f80>
default	11:17:19.003957+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.003959+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.003962+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 31, taskName = com.apple.uikit.applicationSnapshot, creationTime = 923346 (elapsed = 0).
default	11:17:19.004101+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 31
default	11:17:19.004110+0500	Runner	Ending task with identifier 31 and description: <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 31, taskName = com.apple.uikit.applicationSnapshot, creationTime = 923346 (elapsed = 0), _expireHandler: <__NSMallocBlock__: 0x13f121f80>
default	11:17:19.004113+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 31: <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 31, taskName = com.apple.uikit.applicationSnapshot, creationTime = 923346 (elapsed = 0))
default	11:17:19.004257+0500	Runner	Push traits update to screen for new style 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:17:19.004477+0500	Runner	Should not send trait collection or coordinate space update, interface style 1 -> 1, <UIWindowScene: 0x105774200> (830327B3-0D56-4869-9F05-48C82BF30B34)
default	11:17:19.004636+0500	Runner	[0x105738a80] [keyboardFocus] Disabling event deferring records requested: adding recreation reason: detachedContext; for reason: _UIEventDeferringManager: 0x105738a80: disabling keyboardFocus: context detached for window: 0x105648000; contextID: 0x3C6DE330
default	11:17:19.004858+0500	Runner	Will add backgroundTask with taskName: com.apple.UIKit.CABackingStoreCollect, expirationHandler: (null)
default	11:17:19.004873+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.004879+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.004884+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 32, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0).
default	11:17:19.005038+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 32
default	11:17:19.005223+0500	Runner	Ending task with identifier 32 and description: <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 32, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0), _expireHandler: (null)
default	11:17:19.005243+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 32: <_UIBackgroundTaskInfo: 0x13f11cdc0>: taskID = 32, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0))
default	11:17:19.005284+0500	Runner	[0x105738a80] End local event deferring requested for token: 0x105472fa0; environments: 1; reason: UIWindowScene: 0x105774200: end event deferring for scene invalidation
default	11:17:19.005304+0500	Runner	Scene will invalidate: UIWindowScene: 0x105774200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	11:17:19.005372+0500	Runner	Stack[KeyWindow] 0x105712130: Migrate scenes from SystemShellManaged -> LastOneWins
default	11:17:19.005624+0500	Runner	Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
default	11:17:19.011897+0500	Runner	Key window needs update: 1; currentKeyWindowScene: 0x105774200; evaluatedKeyWindowScene: 0x0; currentApplicationKeyWindow: 0x105648000; evaluatedApplicationKeyWindow: 0x0; reason: UIWindowScene: 0x105774200: Window scene was invalidated
default	11:17:19.011925+0500	Runner	Window did become application key: (nil): 0x0; contextId: 0x0; scene identity: (nil)
default	11:17:19.011960+0500	Runner	Resetting home affordance notifier: <_UIHomeAffordanceSceneNotifier: 0x105738a10; observers.count: 1>; for invalidating scene: <UIWindowScene: 0x105774200>
default	11:17:19.012049+0500	Runner	[0x105738a80] Removing all event deferring rules for reason: _UIEventDeferringManager: 0x105738a80: removing all deferring rules due to scene invalidation: 0x105774200
default	11:17:19.012868+0500	Runner	Enqueuing clear events of window: <UIWindow: 0x105648000>; contextId: 0x0
default	11:17:19.012913+0500	Runner	Performing clear events of window: <UIWindow: 0x105648000>; contextId: 0x0
default	11:17:19.013008+0500	Runner	Will add backgroundTask with taskName: com.apple.UIKit.CABackingStoreCollect, expirationHandler: (null)
default	11:17:19.013025+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.013052+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.013087+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11d080>: taskID = 33, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0).
default	11:17:19.013204+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 33
default	11:17:19.013355+0500	Runner	Ending task with identifier 33 and description: <_UIBackgroundTaskInfo: 0x13f11d080>: taskID = 33, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0), _expireHandler: (null)
default	11:17:19.013494+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x131535900> (used by background task with identifier 33: <_UIBackgroundTaskInfo: 0x13f11d080>: taskID = 33, taskName = com.apple.UIKit.CABackingStoreCollect, creationTime = 923346 (elapsed = 0))
default	11:17:19.013662+0500	Runner	sceneOfRecord: sceneID: (null)  persistentID: (null)
default	11:17:19.013679+0500	Runner	[0x1056e4e00] Initialized with scene: <UIWindowScene: 0x105774200>; behavior: <_UIEventDeferringBehavior_iOS: 0x11029ea80>; availableForProcess: 1, systemShellManagesKeyboardFocus: 1
default	11:17:19.014595+0500	Runner	Will add backgroundTask with taskName: Persistent SceneSession Map Update, expirationHandler: <__NSGlobalBlock__: 0x1f2ad6308>
default	11:17:19.014666+0500	Runner	Reusing background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.014687+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x131535900>
default	11:17:19.016771+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x13f11d080>: taskID = 34, taskName = Persistent SceneSession Map Update, creationTime = 923346 (elapsed = 0).
default	11:17:19.016885+0500	Runner	Target list changed:
default	11:17:19.019433+0500	Runner	Received state update for 51431 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	11:17:19.022028+0500	Runner	Received state update for 51431 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
