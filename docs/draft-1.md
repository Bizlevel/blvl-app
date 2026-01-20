default	15:36:28.823757+0500	Runner	[ {"framework": "Photos", "swizzle":[ {"class":"PHAsset", "methods": { "prefixes":["fetch","enumerate"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread"], "performance issue type":["hang"] }, {"class":"PHFetchResult", "methods": { "prefixes":["fetch","enumerate"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread"], "performance issue type":["hang"] } ] }, {"framework": "CoreLocation", "swizzle":[ {"class":"CLLocationManager", "instance methods": { "names":["authorizationStatus", "monitoredRegions", "accuracyAuthorization"] }, "class methods": { "names":["locationServicesEnabled"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreImage", "swizzle":[ {"class":"CIContext", "instance methods": { "names":["createCGImage:fromRect:", "initWithOptions:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"HealthKit", "swizzle":[ {"class":"HKHealthStore", "instance methods": { "names":["authorizationStatusForType:"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreData", "swizzle":[ {"class":"NSManagedObjectContext", "instance methods": { "names":["performBlockAndWait:", "executeFetchRequest:error:", "mergeChangesFromContextDidSaveNotification:","save:", "countForFetchRequest:error:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["Database access on main thread", "Database access on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreML", "swizzle":[ {"class":"MLModel", "class methods": { "names":["modelWithContentsOfURL:error:"] }, "duplicate detection type":"AllFrames", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"Foundation", "swizzle":[ {"class":"NSOperation", "instance methods": { "names":["waitUntilFinished", "waitUntilFinishedOrTimeout:"] }, "duplicate detection type":"AllFrames", "antipattern type":["waiting for operation completion on main thread", "waiting for operation completion on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSThread", "class methods": { "names":["sleepForTimeInterval:"] }, "duplicate detection type":"AllFrames", "antipattern type":["Sleep", "Sleep"], "performance issue type":["hang", "launch"] }, {"class":"NSBundle", "instance methods": { "names":["bundlePath", "bundleIdentifier", "loadAndReturnError:"] }, "class methods": { "names":["bundleWithIdentifier:", "allFrameworks", "allBundles", "pathForResource:ofType:inDirectory:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSKeyedArchiver", "class methods": { "names":["archivedDataWithRootObject:", "archivedDataWithRootObject:requiringSecureCoding:error:", "archiveRootObject:toFile:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSKeyedUnarchiver", "class methods": { "names":["unarchiveTopLevelObjectWithData:error:", "decodeObjectForKey:", "unarchiveObjectWithData:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSFileManager", "methods": { "prefixes":["remove", "create", "move", "copy"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "Excessive IO on any thread", "IO on main thread"], "performance issue type":["hang", "disk write", "launch"] }, {"class":"NSFileManager", "instance methods": { "names":["synchronouslyGetFileProviderServicesForItemAtURL:completionHandler:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"NSData", "methods": { "prefixes":["initWithContents", "dataWithContents"] }, "instance methods": { "names":["enumerateByteRangesUsingBlock:"] }, "duplicate detection type":"NonSystemFramesOnlyFrameworkSupplemented", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"AVFCore", "swizzle":[ {"class":"AVAsset", "class methods": { "names":["assetWithURL:"] }, "duplicate detection type":"NonSystemFramesOnly", "antipattern type":["IO on main thread", "IO on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVAsset", "instance methods": { "names":["mediaSelectionGroupForMediaCharacteristic:"] }, "duplicate detection type":"AllFrames", "antipattern type":["Conditional waiting on main thread", "Conditional waiting on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVAsset", "instance methods": { "names":["tracksWithMediaType:"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] }, {"class":"AVURLAsset", "instance methods": { "names":["tracks"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"AVFAudio", "swizzle":[ {"class":"AVAudioSession", "instance methods": { "names":["setActive:withOptions:error:", "category", "setCategory:mode:options:error:", "setCategory:mode:routeSharingPolicy:options:error:", "setCategory:withOptions:error:", "setCategory:error:", "currentRoute", "outputVolume", "setAllowHapticsAndSystemSoundsDuringRecording:error:", "isPiPAvailable"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"StoreKit", "swizzle":[ {"class":"SKPaymentQueue", "class methods": { "names":["canMakePayments"] }, "duplicate detection type":"AllFrames", "antipattern type":["Semaphore on main thread", "Semaphore on main thread"], "performance issue type":["hang", "launch"] }, {"class":"SKPaymentQueue", "instance methods": { "names":["storefront"] }, "duplicate detection type":"AllFrames", "antipattern type":["XPC on main thread", "XPC on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"CoreTelephony", "swizzle":[ {"class":"CTCellularPlanProvisioning", "instance methods": { "names":["supportsCellularPlan"] }, "duplicate detection type":"AllFrames", "antipattern type":["Semaphore on main thread", "Semaphore on main thread"], "performance issue type":["hang", "launch"] } ] }, {"framework":"Vision", "swizzle":[ {"class":"VNImageRequestHandler", "methods": { "prefixes":["performRequest"] }, "duplicate detection type":"AllFrames", "antipattern type":["Computer vision tasks on main thread", "Computer vision tasks on main thread"], "performance issue type":["hang", "launch"] } ] } ]
default	15:36:28.830749+0500	Runner	[0x104928990] activating connection: mach=true listener=false peer=false name=com.apple.cfprefsd.daemon.system
default	15:36:28.830831+0500	Runner	[0x105618000] activating connection: mach=true listener=false peer=false name=com.apple.cfprefsd.daemon
default	15:36:28.918737+0500	Runner	[bizlevel.kz] Creating a user notification center
default	15:36:28.999409+0500	Runner	Creating new assertion because there is no existing background assertion.
default	15:36:28.999427+0500	Runner	Creating new background assertion
default	15:36:28.999438+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x105638410>
default	15:36:28.999450+0500	Runner	Initializing connection
default	15:36:28.999459+0500	Runner	Removing all cached process handles
default	15:36:28.999471+0500	Runner	Sending handshake request attempt #1 to server
default	15:36:28.999497+0500	Runner	Creating connection to com.apple.runningboard
default	15:36:29.999720+0500	Runner	[0x105618140] activating connection: mach=true listener=false peer=false name=com.apple.runningboard
default	15:36:29.999730+0500	Runner	[C:1] Alloc com.apple.frontboard.systemappservices
default	15:36:29.999737+0500	Runner	[0x105618280] activating connection: mach=false listener=false peer=false name=(anonymous)
default	15:36:29.000226+0500	Runner	Handshake succeeded
default	15:36:29.000231+0500	Runner	Identity resolved as app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>
default	15:36:29.000787+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105638410>
default	15:36:29.000792+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x1055e91c0>: taskID = 1, taskName = Launch Background Task for Coalescing, creationTime = 170200 (elapsed = 0).
default	15:36:29.000803+0500	Runner	Realizing settings extension _UIApplicationSceneKeyboardSettings on FBSSceneSettings
default	15:36:32.041369+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 1
default	15:36:32.041405+0500	Runner	Ending task with identifier 1 and description: <_UIBackgroundTaskInfo: 0x1055e91c0>: taskID = 1, taskName = Launch Background Task for Coalescing, creationTime = 170200 (elapsed = 3), _expireHandler: (null)
default	15:36:32.041435+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105638410> (used by background task with identifier 1: <_UIBackgroundTaskInfo: 0x1055e91c0>: taskID = 1, taskName = Launch Background Task for Coalescing, creationTime = 170200 (elapsed = 3))
default	15:36:32.041448+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x105638410> for task identifier: 1
default	15:36:32.041479+0500	Runner	Cache loaded with 6237 pre-cached in CacheData and 80 items in CacheExtra.
default	15:36:32.041749+0500	Runner	Realizing settings extension <_UISceneOcclusionSettings> on FBSSceneSettings
default	15:36:32.041860+0500	Runner	Realizing settings extension <_UISceneInterfaceProtectionSettings> on FBSSceneSettings
default	15:36:32.041922+0500	Runner	Realizing settings extension _UISceneLayoutPreferencesHostSettingsExtension on FBSSceneSettings
default	15:36:32.041953+0500	Runner	Realizing settings extension _UISceneSafeAreaSettingsExtension on FBSSceneSettings
default	15:36:32.042156+0500	Runner	Realizing settings extension _UISceneLayoutPreferenceClientSettingsExtension on FBSSceneClientSettings
default	15:36:32.042257+0500	Runner	Realizing settings extension <_UIHomeAffordanceHostSceneSettings> on FBSSceneSettings
default	15:36:32.042426+0500	Runner	Realizing settings extension _UISystemShellSceneHostingEnvironmentSettings on FBSSceneSettings
default	15:36:32.042757+0500	Runner	Realizing settings extension _UISceneRenderingEnvironmentSettings on FBSSceneSettings
default	15:36:32.043387+0500	Runner	Realizing settings extension <_UISceneRenderingEnvironmentClientSettings> on FBSSceneClientSettings
default	15:36:32.043445+0500	Runner	Realizing settings extension <_UISceneTransitioningHostSettings> on FBSSceneSettings
default	15:36:32.043462+0500	Runner	Realizing settings extension <_UISceneFocusSystemSettings> on FBSSceneSettings
default	15:36:32.043550+0500	Runner	Realizing settings extension _UISceneOrientationSettingsExtension on FBSSceneSettings
default	15:36:32.043695+0500	Runner	Realizing settings extension _UISceneOrientationClientSettingsExtension on FBSSceneClientSettings
default	15:36:32.043770+0500	Runner	Deactivation reason added: 10; deactivation reasons: 0 -> 1024; animating application lifecycle event: 0
default	15:36:32.043814+0500	Runner	Realizing settings extension _UISceneWindowingControlClientSettings on FBSSceneClientSettings
default	15:36:32.043848+0500	Runner	Realizing settings extension <_UISceneHostingContentSizePreferenceClientSettings> on FBSSceneClientSettings
default	15:36:32.043881+0500	Runner	Realizing settings extension _UISceneHostingTraitCollectionPropagationSettings on FBSSceneSettings
default	15:36:32.043899+0500	Runner	activating monitor for service com.apple.frontboard.open
default	15:36:32.044565+0500	Runner	Realizing settings extension <_UISceneHostingSheetPresentationSettings> on FBSSceneSettings
default	15:36:32.044595+0500	Runner	activating monitor for service com.apple.frontboard.workspace-service
default	15:36:32.044606+0500	Runner	Realizing settings extension <_UISceneHostingSheetPresentationClientSettings> on FBSSceneClientSettings
default	15:36:32.044715+0500	Runner	Realizing settings extension <_UISceneHostingEventDeferringSettings> on FBSSceneSettings
default	15:36:32.044722+0500	Runner	FBSWorkspace registering source: com.apple.frontboard.systemappservices
default	15:36:32.044759+0500	Runner	Realizing settings extension <UIKit__UITypedKeyValueSceneSettings> on FBSSceneSettings
default	15:36:32.044806+0500	Runner	Realizing settings extension <UIKit__UITypedKeyValueSceneSettings> on FBSSceneClientSettings
default	15:36:32.044814+0500	Runner	FBSWorkspace connected to endpoint : <BSServiceConnectionEndpoint: 0x1056e0d60; target: com.apple.frontboard.systemappservices; service: com.apple.frontboard.workspace-service>
default	15:36:32.044830+0500	Runner	<FBSWorkspaceScenesClient:0x1055ff340 com.apple.frontboard.systemappservices> attempting immediate handshake from activate
default	15:36:32.044850+0500	Runner	<FBSWorkspaceScenesClient:0x1055ff340 com.apple.frontboard.systemappservices> sent handshake
default	15:36:32.044897+0500	Runner	Realizing settings extension <_UISceneHostingViewControllerPreferencePropagationClientSettings> on FBSSceneClientSettings
default	15:36:32.044929+0500	Runner	Added observer for process assertions expiration warning: <_RBSExpirationWarningClient: 0x1056e1400>
default	15:36:32.044954+0500	Runner	Realizing settings extension <_UISceneZoomTransitionSettings> on FBSSceneSettings
default	15:36:32.045006+0500	Runner	Evaluated capturing state as 0 on <UIScreen: 0x1056188c0> for initial
default	15:36:32.045012+0500	Runner	Evaluated capturing state as 0 on <UIScreen: 0x1056188c0> for CADisplay KVO
default	15:36:32.045346+0500	Runner	Read CategoryName: per-app = 1, category name = (null)
default	15:36:32.045425+0500	Runner	Read CategoryName: per-app = 0, category name = (null)
default	15:36:32.046663+0500	Runner	Realizing settings extension FBSSceneSettingsCore on FBSSceneSettings
default	15:36:32.047883+0500	Runner	Realizing settings extension FBSSceneClientSettingsCore on FBSSceneClientSettings
fault	15:36:32.196660+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'76 08 19 73 53 69 38 36 9D 64 93 BF E4 4D 52 F3 1C 13 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 76 08 19 73 53 69 38 36 9D 64 93 BF E4 4D 52 F3 4C 12 00 00 E1 2F 98 C8 17 34 34 C0 B5 53 74 F5 63 6D 76 D9 70 9D 00 00 E1 2F 98 C8 17 34 34 C0 B5 53 74 F5 63 6D 76 D9 70 54 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 08 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.199839+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'76 08 19 73 53 69 38 36 9D 64 93 BF E4 4D 52 F3 1C 13 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 76 08 19 73 53 69 38 36 9D 64 93 BF E4 4D 52 F3 4C 12 00 00 E1 2F 98 C8 17 34 34 C0 B5 53 74 F5 63 6D 76 D9 70 9D 00 00 E1 2F 98 C8 17 34 34 C0 B5 53 74 F5 63 6D 76 D9 70 54 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 08 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.281672+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 24 D7 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 E4 D6 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.282005+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 24 D7 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 E4 D6 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.282265+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 68 BB 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 F0 D6 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.282540+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 68 BB 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 F0 D6 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.282799+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 C0 D8 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.283040+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 C0 D8 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 20 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.359210+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 68 0D 01 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 30 0D 01 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 2C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.359582+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 68 0D 01 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 30 0D 01 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 2C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.359847+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 DC 0F 01 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 2C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.360300+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 37 B3 2B 2B 23 34 39 C7 B4 1E 77 22 72 8C 9C D6 DC 0F 01 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 2C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.384120+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 A4 9C 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 6C 9C 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.385111+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 A4 9C 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 6C 9C 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.386122+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 04 9F 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 74 9C 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.386822+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 04 9F 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 74 9C 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.387701+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 F8 A0 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.388176+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundleIdentifier]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 8C D5 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 1C D6 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 AC C9 00 00 28 17 9F C5 61 39 3C 4A 8D 01 C4 77 12 04 86 06 48 C9 00 00 50 E4 16 E1 F2 5C 3D 04 AB FB 6E 8D FF 92 57 A7 F8 A0 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 6C 71 00 00 80 82 42 0D 94 79 30 35 82 62 70 8B A0 8C 6F 36 1C 60 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B8 DF 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 48 34 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 42 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 41 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 44 40 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 3C 3F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 E8 1F 02 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 5C 58 01 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 D8 4D 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:32.388434+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'60 51 91 A0 C5 42 32 7B B9 76 EE 2C B8 1C F1 E5 EC 51 00 00 60 51 91 A0 C5 42 32 7B B9 76 EE 2C B8 1C F1 E5 68 48 00 00 60 51 91 A0 C5 42 32 7B B9 76 EE 2C B8 1C F1 E5 5C 44 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:32.847049+0500	Runner	Registering for test daemon availability notify post.
default	15:36:32.847178+0500	Runner	notify_get_state check indicated test daemon not ready.
default	15:36:32.847280+0500	Runner	notify_get_state check indicated test daemon not ready.
default	15:36:32.847409+0500	Runner	notify_get_state check indicated test daemon not ready.
default	15:36:32.847573+0500	Runner	Deactivation reason added: 11; deactivation reasons: 1024 -> 3072; animating application lifecycle event: 0
default	15:36:32.855988+0500	Runner	UIMutableApplicationSceneSettings setting counterpart class: UIApplicationSceneSettings
default	15:36:32.856089+0500	Runner	UIMutableApplicationSceneClientSettings setting counterpart class: UIApplicationSceneClientSettings
default	15:36:32.856208+0500	Runner	Realizing settings extension FBSSceneTransitionContextCore on FBSSceneTransitionContext
default	15:36:32.869278+0500	Runner	Deactivation reason removed: 10; deactivation reasons: 3072 -> 2048; animating application lifecycle event: 0
default	15:36:32.871458+0500	Runner	Event Timing Profile for Touch: ok, path="/System/Library/EventTimingProfiles/D83.Touch.plist"
default	15:36:32.871469+0500	Runner	Event Timing Profile for Pencil: not found, path="/System/Library/EventTimingProfiles/D83.Pencil.plist"
default	15:36:32.871550+0500	Runner	Selected display: name=LCD (primary), id=1
default	15:36:32.875164+0500	Runner	Will add backgroundTask with taskName: Persistent SceneSession Map Update, expirationHandler: <__NSGlobalBlock__: 0x1f3f8ef90>
default	15:36:32.875196+0500	Runner	Creating new assertion because there is no existing background assertion.
default	15:36:32.875241+0500	Runner	Creating new background assertion
default	15:36:32.875273+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x10563ab70>
default	15:36:32.875474+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x10563ab70>
default	15:36:32.875503+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x1057283c0>: taskID = 2, taskName = Persistent SceneSession Map Update, creationTime = 170203 (elapsed = 0).
default	15:36:32.877439+0500	Runner	Deactivation reason added: 5; deactivation reasons: 2048 -> 2080; animating application lifecycle event: 1
default	15:36:32.877563+0500	Runner	Should send trait collection or coordinate space update, interface style 1 -> 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:32.880395+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:32.895359+0500	Runner	Initializing: <_UIHomeAffordanceSceneNotifier: 0x10573c2a0>; with scene: <UIWindowScene: 0x1057a0200>
default	15:36:32.895405+0500	Runner	0x10572dce0 setDelegate:<0x10572db90 _UIBacklightEnvironment> hasDelegate:YES for environment:sceneID:bizlevel.kz-default
default	15:36:32.895442+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:32.895457+0500	Runner	[0x10573c310] Initialized with scene: <UIWindowScene: 0x1057a0200>; behavior: <_UIEventDeferringBehavior_iOS: 0x1056e2d20>; availableForProcess: 1, systemShellManagesKeyboardFocus: 1
default	15:36:32.895562+0500	Runner	[C:2] Alloc com.apple.backboard.hid-services.xpc
default	15:36:32.895572+0500	Runner	[0x105619180] activating connection: mach=false listener=false peer=false name=(anonymous)
default	15:36:32.896163+0500	Runner	BKSHIDEventObserver - connection activation
default	15:36:32.896173+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; process scope; status: none> was:none
default	15:36:32.896188+0500	Runner	Setting default evaluation strategy for UIUserInterfaceIdiomPhone to LastOneWins
default	15:36:32.896470+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:32.896591+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:32.896755+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:34.404263+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 2
default	15:36:34.404544+0500	Runner	Ending task with identifier 2 and description: <_UIBackgroundTaskInfo: 0x1057283c0>: taskID = 2, taskName = Persistent SceneSession Map Update, creationTime = 170203 (elapsed = 2), _expireHandler: <__NSGlobalBlock__: 0x1f3f8ef90>
default	15:36:34.404570+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x10563ab70> (used by background task with identifier 2: <_UIBackgroundTaskInfo: 0x1057283c0>: taskID = 2, taskName = Persistent SceneSession Map Update, creationTime = 170203 (elapsed = 2))
default	15:36:34.404599+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x10563ab70> for task identifier: 2
fault	15:36:34.426800+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 E6 E7 3A 69 C3 76 36 82 BA E7 37 B4 86 DF 18 D0 14 57 01 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 4C 76 04 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 28 76 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 6F 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 20 78 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:34.429343+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 E6 E7 3A 69 C3 76 36 82 BA E7 37 B4 86 DF 18 D0 14 57 01 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 4C 76 04 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 28 76 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 6F 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 20 78 04 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:35.931135+0500	Runner	[0x10561abc0] activating connection: mach=true listener=false peer=false name=com.apple.analyticsd
default	15:36:36.780966+0500	Runner	Received configuration update from daemon (initial)
default	15:36:36.788038+0500	Runner	[0x10561ae40] activating connection: mach=true listener=false peer=false name=com.apple.fontservicesd
fault	15:36:37.610924+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 4B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C0 B3 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 2C 76 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 70 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 75 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 02 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 E3 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 F9 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C 39 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 CE A2 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 F8 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:37.616924+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 4B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C0 B3 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 2C 76 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 70 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 75 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 02 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 E3 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 F9 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C 39 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 CE A2 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 F8 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:37.623941+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfURL:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A CC 6C 92 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 00 6C 92 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 58 70 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 75 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 02 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 E3 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 F9 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C 39 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 CE A2 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 F8 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:37.626879+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfURL:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A CC 6C 92 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 00 6C 92 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 58 70 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 75 22 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 02 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 E3 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 F9 41 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C 39 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 CE A2 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 F8 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:37.628392+0500	Runner	flutter: The Dart VM service is listening on http://127.0.0.1:62521/Z5mqgJvWbfw=/
default	15:36:37.934149+0500	Runner	BizPluginRegistrant: registerEssentialPlugins
default	15:36:38.342561+0500	Runner	networkd_settings_read_from_file initialized networkd settings by reading plist directly
default	15:36:38.343375+0500	Runner	networkd_settings_read_from_file initialized networkd settings by reading plist directly
error	15:36:38.353436+0500	Runner	FlutterView implements focusItemsInRect: - caching for linear focus movement is limited as long as this view is on screen.
default	15:36:38.355127+0500	Runner	NativeBootstrapCoordinator: native bootstrap channel created
default	15:36:38.384687+0500	Runner	<UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A) Scene updated orientation preferences: none -> ( Pu Ll Lr )
default	15:36:38.388825+0500	Runner	Key window API is scene-level: YES
default	15:36:38.388910+0500	Runner	UIWindowScene: 0x1057a0200: Window became key in scene: UIWindow: 0x105628000; contextId: 0xDC63CA9F: reason: UIWindowScene: 0x1057a0200: Window requested to become key in scene: 0x105628000
default	15:36:38.388957+0500	Runner	Key window needs update: 1; currentKeyWindowScene: 0x0; evaluatedKeyWindowScene: 0x1057a0200; currentApplicationKeyWindow: 0x0; evaluatedApplicationKeyWindow: 0x105628000; reason: UIWindowScene: 0x1057a0200: Window requested to become key in scene: 0x105628000
default	15:36:38.388998+0500	Runner	Window did become application key: UIWindow: 0x105628000; contextId: 0xDC63CA9F; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:36:38.389022+0500	Runner	[0x10573c310] Begin local event deferring requested for token: 0x10546eee0; environments: 1; reason: UIWindowScene: 0x1057a0200: Begin event deferring in keyboardFocus for window: 0x105628000
default	15:36:38.389637+0500	Runner	BKSHIDEventDeliveryManager - connection activation
default	15:36:38.390311+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:38.390757+0500	Runner	[bizlevel.kz] Setting badge count to 0
default	15:36:38.390923+0500	Runner	[0x11e264c80] activating connection: mach=true listener=false peer=false name=com.apple.usernotifications.listener
default	15:36:38.391484+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:38.391565+0500	Runner	Ignoring already applied deactivation reason: 5; deactivation reasons: 2080
default	15:36:38.391778+0500	Runner	Deactivation reason added: 12; deactivation reasons: 2080 -> 6176; animating application lifecycle event: 1
default	15:36:38.393759+0500	Runner	Deactivation reason removed: 11; deactivation reasons: 6176 -> 4128; animating application lifecycle event: 1
default	15:36:38.393852+0500	Runner	Realizing settings extension <_UISceneIntelligenceSupportSettings> on FBSSceneSettings
default	15:36:38.394890+0500	Runner	establishing connection to agent
default	15:36:38.394905+0500	Runner	[0x105c85b80] Session created.
default	15:36:38.394927+0500	Runner	[0x105c85b80] Session created from connection [0x11e264dc0]
default	15:36:38.394937+0500	Runner	[0x11e264dc0] activating connection: mach=true listener=false peer=false name=com.apple.uiintelligencesupport.agent
default	15:36:38.394942+0500	Runner	[bizlevel.kz] Set badge count [ hasCompletionHandler: 1 hasError: 0 ]
default	15:36:38.394978+0500	Runner	[0x105c85b80] Session activated
default	15:36:38.394988+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:38.395489+0500	Runner	Will add backgroundTask with taskName: Persistent SceneSession Map Update, expirationHandler: <__NSGlobalBlock__: 0x1f3f8ef90>
default	15:36:38.395504+0500	Runner	Creating new assertion because there is no existing background assertion.
default	15:36:38.395514+0500	Runner	Creating new background assertion
default	15:36:38.395524+0500	Runner	Created new background assertion <BKSProcessAssertion: 0x105c85ef0>
default	15:36:38.396171+0500	Runner	Incrementing reference count for background assertion <BKSProcessAssertion: 0x105c85ef0>
default	15:36:38.396500+0500	Runner	Created background task <_UIBackgroundTaskInfo: 0x1055e9680>: taskID = 3, taskName = Persistent SceneSession Map Update, creationTime = 170209 (elapsed = 0).
default	15:36:38.402864+0500	Runner	Create activity from XPC object <nw_activity 50:1 [F3A596F5-BCD9-4BA5-A78C-2B96A6F7D1ED] (reporting strategy default)>
default	15:36:38.402904+0500	Runner	Create activity from XPC object <nw_activity 50:2 [B0F81ED2-F298-4724-994C-0E6C5BC3AA89] (reporting strategy default)>
default	15:36:38.402930+0500	Runner	Set activity <nw_activity 50:1 [F3A596F5-BCD9-4BA5-A78C-2B96A6F7D1ED] (reporting strategy default)> as the global parent
default	15:36:38.402976+0500	Runner	AggregateDictionary is deprecated and has been removed. Please migrate to Core Analytics.
default	15:36:38.403013+0500	Runner	Target list changed: <CADisplay:LCD primary>
default	15:36:38.403152+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:38.403318+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:38.404164+0500	Runner	Read Per-App on Init: Smart invert = (null)
default	15:36:38.404496+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:38.404515+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:38.404532+0500	Runner	Deactivation reason removed: 12; deactivation reasons: 4128 -> 32; animating application lifecycle event: 1
default	15:36:38.404741+0500	Runner	Send setDeactivating: N (-DeactivationReason:SuspendedEventsOnly)
default	15:36:38.404752+0500	Runner	Deactivation reason removed: 5; deactivation reasons: 32 -> 0; animating application lifecycle event: 0
default	15:36:38.413512+0500	Runner	Creating hang event with BundleID: bizlevel.kz
default	15:36:38.413616+0500	Runner	Updating event->rollingFGTimestamp from INVALID_FOREGROUND_TIMESTAMP to 4085026617386
default	15:36:38.413678+0500	Runner	Updating configuration of monitor M7483-1
default	15:36:38.413836+0500	Runner	Creating side-channel connection to com.apple.runningboard
default	15:36:38.413878+0500	Runner	[0x11e265540] activating connection: mach=true listener=false peer=false name=com.apple.hangtracermonitor
default	15:36:38.413921+0500	Runner	[0x11e265e00] activating connection: mach=true listener=false peer=false name=com.apple.runningboard
default	15:36:38.414072+0500	Runner	Skip setting user action callback for 3rd party apps
default	15:36:38.414747+0500	Runner	[0x11e265540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:38.414817+0500	Runner	startConnection
default	15:36:38.414848+0500	Runner	[0x11e265540] activating connection: mach=true listener=false peer=false name=com.apple.UIKit.KeyboardManagement.hosted
default	15:36:38.414864+0500	Runner	Hit the server for a process handle 1d7cd3c400001d3b that resolved to: [app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>:7483]
default	15:36:38.415786+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:36:38.416172+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:36:38.454407+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: ancestor> was:none
default	15:36:39.845294+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: none> was:ancestor
default	15:36:39.845438+0500	Runner	Ending background task with UIBackgroundTaskIdentifier: 3
default	15:36:39.845448+0500	Runner	Ending task with identifier 3 and description: <_UIBackgroundTaskInfo: 0x1055e9680>: taskID = 3, taskName = Persistent SceneSession Map Update, creationTime = 170209 (elapsed = 1), _expireHandler: <__NSGlobalBlock__: 0x1f3f8ef90>
default	15:36:39.845458+0500	Runner	Decrementing reference count for assertion <BKSProcessAssertion: 0x105c85ef0> (used by background task with identifier 3: <_UIBackgroundTaskInfo: 0x1055e9680>: taskID = 3, taskName = Persistent SceneSession Map Update, creationTime = 170209 (elapsed = 1))
default	15:36:39.845561+0500	Runner	Will invalidate assertion: <BKSProcessAssertion: 0x105c85ef0> for task identifier: 3
default	15:36:39.846420+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:36:39.879394+0500	Runner	flutter: STARTUP[main.ensure_initialized] {t_ms: 0}
default	15:36:39.879400+0500	Runner	flutter: STARTUP[main.run_app] {t_ms: 4}
fault	15:36:39.900692+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 1C 88 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 63 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF AC 70 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 30 5E 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D8 5D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 5D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 62 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 38 64 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 65 01 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 67 01 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 4E 87 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 10 25 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C0 28 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 DC 3A ED 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 88 E3 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 40 E8 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC A0 E1 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 34 CB 08 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 00 BF 02 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 98 8D 04 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC FC A6 04 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 00 BF 02 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 98 89 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A D4 91 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A 54 90 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 10 8F 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 84 8E 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 30 6B 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 D8 D6 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:39.905106+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 1C 88 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 63 02 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 DD 02 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF AC 70 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 30 5E 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D8 5D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 5D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 62 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 38 64 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 65 01 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 67 01 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 4E 87 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 10 25 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C0 28 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 DC 3A ED 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 88 E3 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 40 E8 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC A0 E1 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 34 CB 08 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 00 BF 02 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 98 8D 04 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC FC A6 04 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 00 BF 02 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 98 89 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A D4 91 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A 54 90 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 10 8F 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 84 8E 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 30 6B 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 D8 D6 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:43.280229+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: ancestor> was:none
default	15:36:45.103473+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
fault	15:36:47.668565+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'CD F3 B9 E6 2D 85 35 2D 9D B5 E7 BA F5 7C 27 6A 80 0F 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 CD F3 B9 E6 2D 85 35 2D 9D B5 E7 BA F5 7C 27 6A 40 0F 00 00 CD F3 B9 E6 2D 85 35 2D 9D B5 E7 BA F5 7C 27 6A 20 0C 00 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 BC 46 04 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 38 42 04 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 F4 3B 04 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 BC 3A 04 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 88 39 04 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 64 35 01 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 F8 D9 01 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 5C D3 01 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 BC C2 01 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 A8 92 01 00 39 A3 8A C1 72 2C 34 1E 82 1D AD C8 85 07 25 80 54 BB 01 00 0E E7 C5 67 C6 D1 35 34 9E 33 54 DD 71 85 C9 F2 E0 45 08 00 0E E7 C5 67 C6 D1 35 34 9E 33 54 DD 71 85 C9 F2 94 7E 01 00 0E E7 C5 67 C6 D1 35 34 9E 33 54 DD 71 85 C9 F2 D4 3E 08 00 0E E7 C5 67 C6 D1 35 34 9E 33 54 DD 71 85 C9 F2 14 A5 0C 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A BC 7A 1B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 79 1B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 68 5B 23 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 7C DD 18 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 08 56 23 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A A4 C0 19 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 AA 15 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 2C 62 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC 0F 36 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 51 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 30 83 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 59 39 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 08 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 BF 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A DC BB 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 30 1E 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:47.702550+0500	Runner	flutter: STARTUP[ui.bootstrap.first_frame] {t_ms: 7827}
default	15:36:47.704431+0500	Runner	App is being debugged, do not track this hang
default	15:36:47.704442+0500	Runner	Hang detected: 9.30s (debugger attached, not reporting)
default	15:36:47.704612+0500	Runner	Scene target of keyboard event deferring environment did change: 1; scene: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:36:47.704688+0500	Runner	[0x10573c310] Scene target of event deferring environments did update: scene: 0x1057a0200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 1; eligibleForRecordRemoval: 1;
default	15:36:47.704720+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:36:47.704737+0500	Runner	Stack[KeyWindow] 0x10572e040: Migrate scenes from LastOneWins -> SystemShellManaged
default	15:36:47.704770+0500	Runner	Setting default evaluation strategy for UIUserInterfaceIdiomPhone to SystemShellManaged
default	15:36:47.704798+0500	Runner	[0x11e265540] Re-initialization successful; calling out to event handler with XPC_ERROR_CONNECTION_INTERRUPTED
error	15:36:47.704826+0500	Runner	XPC connection interrupted
default	15:36:47.704876+0500	Runner	[0x10573c310] Scene target of event deferring environments did update: scene: 0x1057a0200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 1; eligibleForRecordRemoval: 1;
default	15:36:47.704906+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:36:47.704936+0500	Runner	[0x10573c310] Scene target of event deferring environments did update: scene: 0x1057a0200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 1; eligibleForRecordRemoval: 1;
default	15:36:47.704957+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:36:47.705971+0500	Runner	Realizing settings extension SBUISecureRenderingSettingsExtension on FBSSceneSettings
default	15:36:47.706361+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:36:47.706607+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:47.709805+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:47.709841+0500	Runner	canShowAlerts Updated: <FBSSceneSettingsDiff: 0x11e2ac4c0; UIApplicationSceneSettings> {
    subclassSettings = <BSSettingsDiff: 0x11e27c180> {
        canShowAlerts = NO;
    };
}
default	15:36:47.710511+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:36:47.710649+0500	Runner	canShowAlerts Updated: <FBSSceneSettingsDiff: 0x11e2ac4c0; UIApplicationSceneSettings> {
    subclassSettings = <BSSettingsDiff: 0x11e27f090> {
        canShowAlerts = YES;
    };
}
default	15:36:47.710665+0500	Runner	_showHiddenStackedAlertControllers : Showing top alert : (nil)
default	15:36:47.710676+0500	Runner	_willShowAlertController: (nil)
default	15:36:47.717959+0500	Runner	flutter: STARTUP[bootstrap.start] {t_ms: 7843}
default	15:36:47.718028+0500	Runner	flutter: STARTUP[bootstrap.dotenv.start] {t_ms: 7843}
default	15:36:48.540091+0500	Runner	App is being debugged, do not track this hang
default	15:36:48.540137+0500	Runner	Hang detected: 0.83s (debugger attached, not reporting)
default	15:36:48.540961+0500	Runner	handleKeyboardChange: set currentKeyboard:N (wasKeyboard:N)
default	15:36:48.541896+0500	Runner	isWritingToolsHandlingKeyboardTracking:Y (WT ready:Y, Arbiter ready:Y)
default	15:36:48.542068+0500	Runner	RX sceneBecameFocused:(null)
default	15:36:48.551563+0500	Runner	flutter: STARTUP[bootstrap.dotenv.ok] {t_ms: 8676}
default	15:36:48.551599+0500	Runner	flutter: STARTUP[bootstrap.supabase.start] {t_ms: 8676}
default	15:36:49.301713+0500	Runner	App is being debugged, do not track this hang
default	15:36:49.301728+0500	Runner	Hang detected: 0.76s (debugger attached, not reporting)
default	15:36:49.301749+0500	Runner	failedConnection
default	15:36:49.301764+0500	Runner	[0x11e265540] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:49.302526+0500	Runner	handleKeyboardChange: set currentKeyboard:N (wasKeyboard:N)
fault	15:36:49.310988+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E0 97 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C8 93 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 1C 8D 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 A0 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 78 52 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C4 89 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:36:49.314481+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E0 97 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C8 93 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 1C 8D 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 A0 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 78 52 34 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C4 89 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:36:49.353554+0500	Runner	flutter: supabase.supabase_flutter: INFO: ***** Supabase init completed *****
default	15:36:49.353699+0500	Runner	flutter: STARTUP[bootstrap.supabase.ok] {t_ms: 9478}
default	15:36:49.353775+0500	Runner	flutter: INFO: Supabase bootstrap completed
default	15:36:49.353795+0500	Runner	flutter: STARTUP[bootstrap.hive.start] {t_ms: 9478}
default	15:36:49.354160+0500	Runner	flutter: INFO: Hive.initFlutter() starting...
default	15:36:50.482281+0500	Runner	App is being debugged, do not track this hang
default	15:36:50.482321+0500	Runner	Hang detected: 1.17s (debugger attached, not reporting)
default	15:36:50.483278+0500	Runner	nw_path_libinfo_path_check [FCF62F7E-5BAA-4794-940A-16175DFB6A1E acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:50.502130+0500	Runner	flutter: INFO: Hive.initFlutter() completed successfully
default	15:36:50.502249+0500	Runner	flutter: STARTUP[bootstrap.hive.ok] {t_ms: 10627}
default	15:36:50.502269+0500	Runner	flutter: INFO: Hive bootstrap completed
default	15:36:50.502312+0500	Runner	flutter: STARTUP[bootstrap.done] {t_ms: 10627}
default	15:36:50.516088+0500	Runner	flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:50.516966+0500	Runner	flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:50.522510+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:53.808553+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:55.262346+0500	Runner	flutter: STARTUP[postframe.start] {t_ms: 15387}
default	15:36:55.262382+0500	Runner	flutter: STARTUP[postframe.local_services.start] {t_ms: 15387}
default	15:36:55.263278+0500	Runner	flutter: INFO: Hive already initialized, skipping
default	15:36:55.264041+0500	Runner	flutter: STARTUP[ui.router.first_frame] {t_ms: 15388, w: 393, h: 852, dpr: 3.0}
default	15:36:55.270186+0500	Runner	flutter: STARTUP[postframe.local_services.ok] {t_ms: 15395}
default	15:36:55.270234+0500	Runner	flutter: STARTUP[postframe.launch_route.start] {t_ms: 15395}
default	15:36:55.273307+0500	Runner	nw_path_libinfo_path_check [CEE4DBAE-9224-4F6C-8778-7213F08E85A1 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:55.277113+0500	Runner	App is being debugged, do not track this hang
default	15:36:55.277221+0500	Runner	Hang detected: 4.78s (debugger attached, not reporting)
default	15:36:56.796407+0500	Runner	flutter: STARTUP[postframe.launch_route.ok] {t_ms: 16920}
default	15:36:56.796447+0500	Runner	flutter: STARTUP[postframe.push_auth_gate.setup] {t_ms: 16921}
default	15:36:56.796463+0500	Runner	flutter: STARTUP[postframe.push_auth_gate.skip] {t_ms: 16921, reason: ENABLE_CLOUD_PUSH=false}
default	15:36:56.798748+0500	Runner	flutter: STARTUP[postframe.done] {t_ms: 16922}
default	15:36:56.798783+0500	Runner	App is being debugged, do not track this hang
default	15:36:56.798791+0500	Runner	Hang detected: 1.52s (debugger attached, not reporting)
default	15:36:56.801624+0500	Runner	flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:56.801732+0500	Runner	flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:56.802639+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:56.803428+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:56.847502+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:56.855823+0500	Runner	flutter: supabase.auth: INFO: Refresh session
default	15:36:56.910367+0500	Runner	<nw_activity 50:1 [F3A596F5-BCD9-4BA5-A78C-2B96A6F7D1ED] (global parent) (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 60356ms
default	15:36:56.910438+0500	Runner	<nw_activity 50:2 [B0F81ED2-F298-4724-994C-0E6C5BC3AA89] (reporting strategy default) complete (reason success)> complete with reason 2 (success), duration 60356ms
default	15:36:56.910476+0500	Runner	Unsetting the global parent activity <nw_activity 50:1 [F3A596F5-BCD9-4BA5-A78C-2B96A6F7D1ED] (global parent) (reporting strategy default) complete (reason success)>
default	15:36:56.910492+0500	Runner	Unset the global parent activity
default	15:36:56.962088+0500	Runner	System Keychain Always Supported set via feature flag to disabled
default	15:36:56.962104+0500	Runner	[0x11e264140] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:56.962260+0500	Runner	[0x11e2643c0] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:56.964982+0500	Runner	[0x11e2643c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:57.724807+0500	Runner	App is being debugged, do not track this hang
default	15:36:57.724822+0500	Runner	Hang detected: 0.76s (debugger attached, not reporting)
default	15:36:58.163269+0500	Runner	nw_path_libinfo_path_check [51989250-CE34-44F4-B244-1C530BB0A7A4 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.163311+0500	Runner	nw_path_libinfo_path_check [E21C6147-4FF5-4E98-AB8C-AD8BF1FAC2F6 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.163434+0500	Runner	nw_path_libinfo_path_check [12FAC951-176F-43F4-8364-FCEF6C6F869A acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.163562+0500	Runner	nw_path_libinfo_path_check [3FBCC3CF-D9B3-4E3D-9E26-BE8A2F31AC7C acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.163644+0500	Runner	nw_path_libinfo_path_check [66F0916D-D7F0-4CCB-9AFA-B28DA94849D4 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.164206+0500	Runner	nw_path_libinfo_path_check [A2AC20CD-F295-46D0-A822-823D1B947CBC acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.171269+0500	Runner	flutter: currentUserProvider: session = true, user = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:58.171315+0500	Runner	flutter: UserRepository.fetchProfile: querying users table for dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:58.173434+0500	Runner	nw_path_libinfo_path_check [230DD784-B8A1-45B4-9CF6-DC1585534B95 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.175208+0500	Runner	nw_path_libinfo_path_check [D843AC25-9F5E-4E0F-9FC0-539648F71DD8 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.175318+0500	Runner	nw_path_libinfo_path_check [FE455208-E160-433B-8CDC-D8910D5F2BFE acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.176672+0500	Runner	nw_path_libinfo_path_check [EBFCA626-53E7-48DC-AD84-96E950AE6F41 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.176779+0500	Runner	nw_path_libinfo_path_check [09DD0350-000F-4B69-BCBA-EFBC33C7E48E acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.176825+0500	Runner	nw_path_libinfo_path_check [9E4A96BF-08C4-4CB3-B788-700C84AF4AA9 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.182754+0500	Runner	nw_path_libinfo_path_check [C97846EB-B355-40A3-AAC0-DC7E0FC53BD5 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.184346+0500	Runner	nw_path_libinfo_path_check [04CA2649-612E-45B0-878A-CA9A48AB0F7A acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:36:58.342972+0500	Runner	[0x11e2643c0] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.344927+0500	Runner	[0x11e265040] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.345190+0500	Runner	[0x11e2643c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.348794+0500	Runner	[0x11e265040] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.375575+0500	Runner	[0x11e265040] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.379302+0500	Runner	[0x11e265040] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.384824+0500	Runner	[0x11e265040] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.384974+0500	Runner	[0x11e2643c0] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.387034+0500	Runner	[0x11e266080] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.388526+0500	Runner	[0x11e265040] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.391050+0500	Runner	[0x11e265040] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:36:58.391515+0500	Runner	[0x11e2643c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.395328+0500	Runner	[0x11e266080] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.398679+0500	Runner	[0x11e265040] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:36:58.606654+0500	Runner	flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
default	15:36:58.607661+0500	Runner	flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:58.607716+0500	Runner	flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
default	15:36:58.607778+0500	Runner	flutter: UserRepository.fetchProfile: about = "Самогоноварение"
default	15:36:58.607855+0500	Runner	flutter: currentUserProvider: repository returned true
default	15:36:58.615128+0500	Runner	flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
default	15:36:58.615220+0500	Runner	flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:36:58.615231+0500	Runner	flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
default	15:36:58.615236+0500	Runner	flutter: UserRepository.fetchProfile: about = "Самогоноварение"
default	15:36:58.615247+0500	Runner	flutter: currentUserProvider: repository returned true
default	15:36:59.509407+0500	Runner	App is being debugged, do not track this hang
default	15:36:59.509432+0500	Runner	Hang detected: 0.88s (debugger attached, not reporting)
default	15:36:59.509455+0500	Runner	startConnection
default	15:36:59.509562+0500	Runner	[0x11e265040] activating connection: mach=true listener=false peer=false name=com.apple.UIKit.KeyboardManagement.hosted
default	15:36:59.522481+0500	Runner	handleKeyboardChange: set currentKeyboard:N (wasKeyboard:N)
default	15:36:59.522559+0500	Runner	nw_path_libinfo_path_check [E8A608AB-A77F-4A71-8CA6-D0C5615D6633 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:00.445163+0500	Runner	nw_path_libinfo_path_check [54DAC6EB-A235-4091-8CAE-E20E73CA700E acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:00.446763+0500	Runner	App is being debugged, do not track this hang
default	15:37:00.446770+0500	Runner	Hang detected: 0.92s (debugger attached, not reporting)
default	15:37:00.447061+0500	Runner	nw_path_libinfo_path_check [3B2C1C22-B9A8-4E0C-ABDE-4FB5153F0051 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:00.453967+0500	Runner	flutter: UserRepository.fetchProfile: raw response: {id: dc7d094d-9fd1-4b78-b153-6c2185fd26ef, name: Вася, email: alimzhanov.e@gmail.com, about: Самогоноварение, goal: Крафтовое пиво делать, лучшее в городе., business_area: Производство и продажа пива, experience_level: 10 лет, onboarding_completed: true, current_level: 7, avatar_id: 10, business_size: до 5 сотрудников, key_challenges: [Масштабирование], learning_style: Практические примеры, business_region: Алматы}
default	15:37:00.454070+0500	Runner	flutter: UserRepository.fetchProfile: loaded user dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:37:00.454117+0500	Runner	flutter: UserRepository.fetchProfile: goal = "Крафтовое пиво делать, лучшее в городе."
default	15:37:00.454149+0500	Runner	flutter: UserRepository.fetchProfile: about = "Самогоноварение"
default	15:37:00.454185+0500	Runner	flutter: currentUserProvider: repository returned true
default	15:37:00.476159+0500	Runner	nw_path_libinfo_path_check [A9911569-FFB3-4618-B7C4-887AB542060A acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:00.639938+0500	Runner	[0x11e266080] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:00.643397+0500	Runner	[0x11e266080] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:00.664659+0500	Runner	[0x11e266080] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:00.667227+0500	Runner	[0x11e266080] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:01.613960+0500	Runner	App is being debugged, do not track this hang
default	15:37:01.614046+0500	Runner	Hang detected: 0.83s (debugger attached, not reporting)
default	15:37:02.493441+0500	Runner	flutter: STARTUP[postframe.sentry.deferred.start] {t_ms: 22618}
default	15:37:02.497167+0500	Runner	[0x11e266080] activating connection: mach=true listener=false peer=false name=com.apple.lsd.mapdb
fault	15:37:02.502583+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 4C 5A 2D 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 49 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:02.513343+0500	Runner	[SentryFlutterPlugin] Async native init disabled, starting immediately
default	15:37:02.513391+0500	Runner	[SentryFlutterPlugin] Async native init started
default	15:37:02.519937+0500	Runner	[0x11e265f40] activating connection: mach=true listener=false peer=false name=com.apple.lsd.advertisingidentifiers
default	15:37:02.523825+0500	Runner	MainThreadIOMonitor: -[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] (/var/mobile/Containers/Data/Application/5FADD295-292F-4E83-859E-9D9C852C45D0/Library/Caches)
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
default	15:37:02.528023+0500	Runner	-[NWConcrete_nw_resolver initWithEndpoint:parameters:path:log_str:] [R1] created for sentry.io:0 using: generic, attribution: developer
default	15:37:02.528075+0500	Runner	nw_resolver_set_update_handler_block_invoke [R1] started
default	15:37:02.528112+0500	Runner	nw_path_evaluator_start [2E355DE4-5B7B-409F-8120-1E66161713CE sentry.io:0 generic, attribution: developer]
	path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:02.528155+0500	Runner	[0x11e264780] activating connection: mach=true listener=false peer=false name=com.apple.dnssd.service
default	15:37:04.251599+0500	Runner	Task <618DD2A4-85BD-417D-A16B-926373575245>.<1> finished with error [-999] Error Domain=NSURLErrorDomain Code=-999 "cancelled" UserInfo={NSErrorFailingURLStringKey=, NSErrorFailingURLKey=, _NSURLErrorRelatedURLSessionTaskErrorKey=(
    "LocalDataTask <618DD2A4-85BD-417D-A16B-926373575245>.<1>"
), _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <618DD2A4-85BD-417D-A16B-926373575245>.<1>, NSLocalizedDescription=cancelled}
default	15:37:04.251612+0500	Runner	flutter: STARTUP[postframe.sentry.deferred.ok] {t_ms: 24373}
default	15:37:04.252604+0500	Runner	App is being debugged, do not track this hang
default	15:37:04.252633+0500	Runner	Hang detected: 1.71s (debugger attached, not reporting)
fault	15:37:04.262016+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 AD A5 FD 68 13 A1 3B 13 A3 FB FF 7A 52 0F A2 9E 14 C2 02 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 0C 5A 2D 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 49 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.263906+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 AD A5 FD 68 13 A1 3B 13 A3 FB FF 7A 52 0F A2 9E 14 C2 02 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 0C 5A 2D 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 49 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.281018+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF DC 53 32 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D8 4A 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.284286+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF DC 53 32 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D8 4A 32 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.319008+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF DC FE 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF F4 F9 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 F4 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF FC 1A 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 74 1B 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B8 EC 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 88 E8 13 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 00 3C 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 F4 2D 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B4 29 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 1C 6D 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 E4 34 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B8 5D 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 78 65 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 6E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 64 2B 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B4 24 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D0 16 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 1C 33 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.326519+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF DC FE 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF F4 F9 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 F4 11 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF FC 1A 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 74 1B 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B8 EC 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 88 E8 13 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 00 3C 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 F4 2D 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 B4 29 02 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 1C 6D 00 00 EE 4A 43 47 BD 73 3B ED A7 14 9C D0 B1 68 44 A2 E4 34 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B8 5D 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 78 65 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 10 6E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 64 2B 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B4 24 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D0 16 33 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 1C 33 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.335278+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 4B 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 C2 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B8 0B 15 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 0B 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 5C 12 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 1A 16 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 A6 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 88 28 06 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B0 37 0E 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 4C CB 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D4 D7 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 20 9B 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC C4 91 01 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 B8 13 00 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:04.336436+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF BC C3 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C 13 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 1A 16 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 A6 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 88 28 06 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B0 37 0E 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 4C CB 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D4 D7 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 20 9B 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC C4 91 01 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 B8 13 00 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:04.614758+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:04.614767+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:04.614769+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:04.624078+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:04.627921+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:04.655846+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:05.560676+0500	Runner	App is being debugged, do not track this hang
default	15:37:05.560688+0500	Runner	Hang detected: 0.89s (debugger attached, not reporting)
error	15:37:05.560719+0500	Runner	<0x105619a40> Gesture: System gesture gate timed out.
default	15:37:05.560888+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:05.560910+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:05.560930+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:05.560972+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:05.704114+0500	Runner	[0x11e266bc0] activating connection: mach=true listener=false peer=false name=com.apple.distributed_notifications@1v3
default	15:37:06.004865+0500	Runner	App is being debugged, do not track this hang
default	15:37:06.004897+0500	Runner	Hang detected: 0.45s (debugger attached, not reporting)
default	15:37:06.916284+0500	Runner	App is being debugged, do not track this hang
default	15:37:06.916699+0500	Runner	Hang detected: 0.90s (debugger attached, not reporting)
fault	15:37:06.926922+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 45 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D8 16 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:06.935038+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 45 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D8 16 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:06.942356+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:06.949740+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:08.513197+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:08.513209+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:08.513221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:08.515502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:08.515547+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:08.558032+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:08.558043+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:08.558051+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:08.573324+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:08.573402+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:10.079279+0500	Runner	App is being debugged, do not track this hang
default	15:37:10.079327+0500	Runner	Hang detected: 1.51s (debugger attached, not reporting)
default	15:37:10.444521+0500	Runner	Requesting container lookup; class = 13, identifier = (null), group_identifier = systemgroup.com.apple.configurationprofiles, create = 1, temp = 0, euid = 501, uid = 501
default	15:37:10.444822+0500	Runner	_container_query_get_result_at_index: success
default	15:37:10.444858+0500	Runner	container_system_group_path_for_identifier: success
default	15:37:10.444866+0500	Runner	Got system group container path from MCM for systemgroup.com.apple.configurationprofiles: /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles
default	15:37:10.449295+0500	Runner	[0x11e267d40] activating connection: mach=true listener=false peer=false name=com.apple.pasteboard.pasted
default	15:37:10.449583+0500	Runner	Retrieving pasteboard named com.apple.UIKit.pboard.general, create if needed: NO
fault	15:37:10.452869+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F8 32 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F 50 32 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F 60 59 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:10.458436+0500	Runner	...retrieving pasteboard named com.apple.UIKit.pboard.general completed successfully.
default	15:37:10.458832+0500	Runner	App is being debugged, do not track this hang
default	15:37:10.458861+0500	Runner	Hang detected: 0.38s (debugger attached, not reporting)
fault	15:37:10.475698+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 24 35 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 DC 34 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 14 1C 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC CC 53 01 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 68 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 F4 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 70 76 07 00 C5 61 44 BC 66 6D 38 65 87 BE 57 EB 2D 93 BC D6 DC 1E 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:11.087903+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 24 35 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 DC 34 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 14 1C 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC CC 53 01 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 68 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 F4 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 70 76 07 00 C5 61 44 BC 66 6D 38 65 87 BE 57 EB 2D 93 BC D6 DC 1E 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:11.101340+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData dataWithContentsOfFile:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 80 1C 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC CC 53 01 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 68 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 F4 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 70 76 07 00 C5 61 44 BC 66 6D 38 65 87 BE 57 EB 2D 93 BC D6 DC 1E 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:11.104445+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData dataWithContentsOfFile:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 80 1C 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC CC 53 01 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 68 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 F4 1A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 70 76 07 00 C5 61 44 BC 66 6D 38 65 87 BE 57 EB 2D 93 BC D6 DC 1E 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:11.124264+0500	Runner	App is being debugged, do not track this hang
default	15:37:11.124317+0500	Runner	Hang detected: 0.65s (debugger attached, not reporting)
default	15:37:11.130131+0500	Runner	nw_path_libinfo_path_check [6EE153A4-4C68-4256-BC2E-5B44135DDB66 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
fault	15:37:11.135488+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData dataWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF AC 4A 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 FC 2F 02 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 50 20 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 28 40 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC CC 53 01 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 A4 3F 00 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 E0 AC 0A 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 14 75 07 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 60 79 07 00 D4 A2 F6 57 CA 0E 31 B1 BA B1 63 E5 65 BF 7C 53 A8 76 07 00 C5 61 44 BC 66 6D 38 65 87 BE 57 EB 2D 93 BC D6 DC 1E 00 00 BD 0C F6 D5 80 48 3B 71 AE B7 0C 0A A4 0E 9C 4F F0 1B 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 DD 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B4 DF 82 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 19 7B 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 55 79 01 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 E0 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 00 C4 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 74 76 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:11.142601+0500	Runner	nw_path_libinfo_path_check [793CC601-455E-4DF4-A386-226B586549F1 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:11.328110+0500	Runner	[0x11e266f80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:11.333415+0500	Runner	[0x11e266f80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:13.592416+0500	Runner	flutter: CHIPS http_status=200
default	15:37:13.592557+0500	Runner	flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
default	15:37:13.592715+0500	Runner	flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:37:13.593354+0500	Runner	flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:37:15.744111+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:15.744661+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.744676+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.744684+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.744692+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.766541+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.766571+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.766594+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.774966+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.774987+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.774996+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.783098+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.783168+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.783188+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.783232+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:15.783277+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.783314+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.783344+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.791549+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.792107+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.792145+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.799786+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.799839+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.799850+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.808372+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.808686+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.808721+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.818852+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.818893+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.818916+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.824691+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.824824+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.824836+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.833089+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.833106+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.833122+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.841407+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.841449+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.841485+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.849699+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.849719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.849734+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.858059+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.858141+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.858160+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.866405+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.866440+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.866452+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.874763+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.874852+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.874950+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.884310+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.884332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.884434+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.891490+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.891555+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.891593+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.900867+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.900888+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.901732+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.908901+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.908910+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.908919+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.916409+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.916426+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.916440+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.924743+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.924792+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.924807+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.933474+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.933490+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.933531+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:15.933562+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:15.933582+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:15.933593+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:16.738339+0500	Runner	App is being debugged, do not track this hang
default	15:37:16.738370+0500	Runner	Hang detected: 0.80s (debugger attached, not reporting)
default	15:37:16.750498+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:16.750700+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:16.750731+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:16.750947+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:16.751631+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:16.833532+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:16.833559+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:16.833604+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:16.880810+0500	Runner	Reloading input views for key-window scene responder: <FlutterTextInputView: 0x105629400; frame = (0 0; 1 1); > force:N
default	15:37:16.880964+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 1 force: 0, fromBecomeFirstResponder: 1 (automaticKeyboard: 1, reloadIdentifier: E3B6ECFC-EC61-4B70-8068-7F6A6BEFE086)
default	15:37:16.881007+0500	Runner	_inputViewsForResponder: <FlutterTextInputView: 0x105629400; frame = (0 0; 1 1); >, automaticKeyboard: 1, force: 0
default	15:37:16.881030+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:37:16.881047+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:37:16.881072+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 1 (automaticKeyboardEnabled: 1, activeInstance: <(null): 0x0>, self.isOnScreen: 0, requiresKBWhenFirstResponder: 1)
default	15:37:16.881098+0500	Runner	_inputViewsForResponder, useKeyboard 1 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 1)
fault	15:37:17.275382+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 52 1F 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 11 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C BB 1F 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 B4 1F 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 18 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 EE 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 0D 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 07 07 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:17.281258+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 52 1F 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 11 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C BB 1F 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 B4 1F 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 18 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 EE 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 0D 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 07 07 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:17.318824+0500	Runner	_inputViewsForResponder, found assistantVC: <UISystemInputAssistantViewController: 0x105634a00; frame = {{0, 0}, {0, 0}}> (should suppress: 0, _dontNeed: 0)
default	15:37:17.318835+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:37:17.319998+0500	Runner	[0x11e23ee40] activating connection: mach=true listener=false peer=false name=com.apple.TextInput
default	15:37:17.656831+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: Updating mode. Haptics: supported. Haptics: disabled. Ringer: on. Sound: disabled. Mode: none
default	15:37:17.657144+0500	Runner	_inputViewsForResponder, useKeyboard ivs: <UIInputViewSet: 0x1056d2a00>
default	15:37:17.661130+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x1056d2a00>; view = <_UIKBCompatInputView: 0x105df79c0; frame = (0 0; 0 0); >; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); hidden = YES; >; usesKeyClicks = NO;  >
fault	15:37:17.669914+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 71 84 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E0 65 F8 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A8 F2 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 E0 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 F5 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 99 30 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 18 AD 32 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 24 EF 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 4E D6 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 6C 45 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 1B E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 EE 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 0D 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 07 07 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:17.675856+0500	Runner	Change from input view set: (null)
default	15:37:17.675884+0500	Runner	Change to input view set: (null)
default	15:37:17.676785+0500	Runner	_moveGuideOffscreenAtEdge: 4
default	15:37:17.676835+0500	Runner	changeOffsetConstants: offset is changing to {0, 0} [previous offset: {-1, -1}]
default	15:37:17.677177+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 0} [previous size: {1, 0}]
default	15:37:17.679126+0500	Runner	Activating connection to server: (null)
default	15:37:17.679275+0500	Runner	server remote target <BSXPCServiceConnectionProxy<BKSKeyboardServiceClientToServerIPC>: 0x105711f10>
default	15:37:17.679344+0500	Runner	currently observing: YES
default	15:37:17.679760+0500	Runner	currently observing: NO
fault	15:37:17.679958+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A4 71 84 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E0 65 F8 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A8 F2 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 E0 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 F5 71 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 99 30 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 18 AD 32 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 24 EF 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 78 4E D6 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 6C 45 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 1B E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 EE 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 0D 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 07 07 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:17.680020+0500	Runner	-_teardownExistingDelegate:(nil) forSetDelegate:<FlutterTextInputView: 0x105629400> force:NO delayEndInputSession:YES
default	15:37:17.680038+0500	Runner	endInputSession completion is disabled
default	15:37:17.680160+0500	Runner	[Interface Orientation] was:Interface Unknown now:UIInterfaceOrientationPortrait reason:Using key window scene
default	15:37:17.680675+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:37:17.703867+0500	Runner	<TUIKeyplaneView: 0x10562bc00> changed keyplane size to {393, 216}; docked
default	15:37:17.704145+0500	Runner	Setting dynamic keyplane: Dynamic-Russian-Small_Small-Letters-Small-Display
default	15:37:17.720587+0500	Runner	-[TUIKeyboardCandidateMultiplexer installGeneratorForSource:]_block_invoke: Multiplexer is installing generator for source: 1
default	15:37:17.720597+0500	Runner	-[TUIKeyboardCandidateMultiplexer installGeneratorForSource:]_block_invoke: Multiplexer is installing generator for source: 2
default	15:37:17.720652+0500	Runner	-[TUIKeyboardCandidateMultiplexer installGeneratorForSource:]_block_invoke: Multiplexer is installing generator for source: 4
default	15:37:17.720952+0500	Runner	Creating a new RTI client
default	15:37:17.720957+0500	Runner	-[TUIKeyboardCandidateMultiplexer installGeneratorForSource:]_block_invoke: Multiplexer is installing generator for source: 3
default	15:37:17.720971+0500	Runner	-[TUIKeyboardCandidateMultiplexer installGeneratorForSource:]_block_invoke: Multiplexer is installing generator for source: 5
default	15:37:17.721076+0500	Runner	[C:3] Alloc com.apple.inputservice.input-ui-host
default	15:37:17.721332+0500	Runner	[0x12ff652c0] activating connection: mach=false listener=false peer=false name=(anonymous)
default	15:37:17.721438+0500	Runner	creating new AutofillUI connection
default	15:37:17.721586+0500	Runner	-[RTIInputSystemClient beginAllowingRemoteTextInput:]  Begin allowing remote text input: 75EAEE6C-BDA5-4C50-9A84-B605D92BD544
default	15:37:17.721606+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = YES)
default	15:37:17.722161+0500	Runner	-[RTIInputSystemClient _beginSessionWithID:forServices:force:]  Begin text input session. sessionID = 75EAEE6C-BDA5-4C50-9A84-B605D92BD544, options = <RTISessionOptions: 0x12ff4a7c0; shouldResign = NO; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:37:17.724430+0500	Runner	channel:CandidateBar signal:Reset uniqueStringId:(null) creationTimestamp:790511837.713046 timestamp:790511837.713127 payload:(null)
default	15:37:17.736929+0500	Runner	App is being debugged, do not track this hang
default	15:37:17.736939+0500	Runner	Hang detected: 0.85s (debugger attached, not reporting)
error	15:37:17.739701+0500	Runner	<0x105619a40> Gesture: System gesture gate timed out.
default	15:37:17.741555+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:17.741575+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:17.742449+0500	Runner	TX setWindowContextID:0 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:17.742458+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x1056d2a00>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); hidden = YES; >; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.742556+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.742775+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 325}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:37:17.742877+0500	Runner	Should send trait collection or coordinate space update, interface style 1 -> 1, <_UIKeyboardWindowScene: 0x12ff54c80> (086A498B-5F38-4559-9E5E-93355A5D982D)
default	15:37:17.742892+0500	Runner	Should send trait collection or coordinate space update, interface style 1 -> 1, <_UIKeyboardWindowScene: 0x12ff54c80> (086A498B-5F38-4559-9E5E-93355A5D982D)
default	15:37:17.742898+0500	Runner	Initializing: <_UIHomeAffordanceSceneNotifierProxy: 0x12fe895c0>; with scene: <_UIKeyboardWindowScene: 0x12ff54c80>
default	15:37:17.742943+0500	Runner	Change from input view set: (null)
default	15:37:17.742949+0500	Runner	Change to input view set: (null)
default	15:37:17.742954+0500	Runner	Realizing settings extension <_UIApplicationSceneDisplaySettings> on FBSSceneSettings
default	15:37:17.743082+0500	Runner	Change from input view set: (null)
default	15:37:17.743088+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff903c0>; (empty)>
default	15:37:17.747488+0500	Runner	Not observing PTDefaults on customer install.
default	15:37:17.749732+0500	Runner	Requesting calls from host
default	15:37:17.749850+0500	Runner	[0x12fe7d7c0] activating connection: mach=true listener=false peer=false name=com.apple.callkit.callcontrollerhost
default	15:37:17.750163+0500	Runner	[0x12fe7da40] activating connection: mach=true listener=false peer=false name=com.apple.inputanalyticsd
default	15:37:17.750880+0500	Runner	channel:LegacyTextInputActions signal:DidSessionBegin sessionID:75EAEE6C-BDA5-4C50-9A84-B605D92BD544 timestamp:790511837.750345 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511837.7249759";
}
default	15:37:17.751328+0500	Runner	Received requested calls from host: (
)
default	15:37:17.752645+0500	Runner	[0x12fe7db80] activating connection: mach=true listener=false peer=false name=com.apple.SystemConfiguration.NetworkInformation
default	15:37:17.756838+0500	Runner	MainThreadIOMonitor: -[NSData initWithContentsOfFile:options:error:] (/AppleInternal/Library/Assistant/InternalConfig.plist)
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
default	15:37:17.758580+0500	Runner	updatePlacementWithPlacement: <UITrackingElementPlacementInitialPosition>
default	15:37:17.760421+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:37:17.761007+0500	Runner	TX signalKeyboardChanged
default	15:37:17.761145+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x12ce43a80>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x1056d7520 -> <CAFenceHandle:0x105678cb0 name=4 fence=4c00000fe9 usable=YES>>; position {{0, 527}, {393, 325}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x1056d7520 -> <CAFenceHandle:0x105678cb0 name=4 fence=4c00000fe9 usable=YES>>; position {{0, 527}, {393, 325}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:37:17.761198+0500	Runner	TX setWindowContextID:2226275843 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:17.761462+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:37:17.761490+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff90540>; keyboard = [uninitialized]; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); hidden = YES; >; usesKeyClicks = NO;  >
default	15:37:17.762264+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.778769+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.778894+0500	Runner	Moving from placement: <UITrackingElementPlacementInitialPosition> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UITrackingElementPlacementInitialPosition>)
default	15:37:17.779398+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff903c0>; (empty)>
default	15:37:17.779416+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  >
default	15:37:17.779489+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: -[_UIKBFeedbackGenerator activateWithCompletionBlock:]
default	15:37:17.779516+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: Nothing to activate. Keyboard feedback is disabled.
default	15:37:17.781812+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.781889+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.782056+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.782268+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.782438+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.782562+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.782634+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.782696+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.784660+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.784701+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.785063+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.785118+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.785177+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.785213+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.785321+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 0 0); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 0 0); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.785343+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.787802+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:17.789906+0500	Runner	moveFromPlacement, updated placements from: <UITrackingElementPlacementInitialPosition>, to: <UIInputViewSetPlacementOnScreen>
default	15:37:17.790045+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:17.790184+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:37:17.790646+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.790685+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.790755+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.790779+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.790925+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.790951+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.791002+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.791028+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.791496+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 335}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:37:17.791555+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:37:17.791707+0500	Runner	TX signalKeyboardChanged
default	15:37:17.791726+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x12ce43900>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x1056d7c00 -> <CAFenceHandle:0x105679b90 name=6 fence=4c00000fe9 usable=YES>>; position {{0, 517}, {393, 335}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x1056d7c00 -> <CAFenceHandle:0x105679b90 name=6 fence=4c00000fe9 usable=YES>>; position {{0, 517}, {393, 335}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:37:17.792145+0500	Runner	Tracking provider: moveFromPlacement: <UITrackingElementPlacementInitialPosition> toPlacement: <UIInputViewSetPlacementOnScreen> update to: {{0, 517}, {393, 335}}
default	15:37:17.792170+0500	Runner	KeyboardTrackingCoordinator: Creating tracking provider for <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.792292+0500	Runner	KeyboardTrackingCoordinator: Creating tracking coordinator for <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.792385+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x12fead960 State: onscreen with input view; is docked>; frame={{0, 517}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x130c7dbc0, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:37:17.793684+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 335} [previous size: {393, 0}]
default	15:37:17.796623+0500	Runner	[0x12ff12300] activating connection: mach=true listener=false peer=false name=com.apple.powerlog.plxpclogger.xpc
default	15:37:17.796842+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff90600>; keyboard = [uninitialized]; usesKeyClicks = NO;  >
default	15:37:17.797858+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90600>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.798026+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.798069+0500	Runner	Moving from placement: <UITrackingElementPlacementInitialPosition> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UITrackingElementPlacementInitialPosition>)
default	15:37:17.798140+0500	Runner	Change from input view set: (null)
default	15:37:17.798327+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff90600>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:37:17.798568+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 0}]
default	15:37:17.798687+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90600>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:17.798713+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:17.804385+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:37:17.804672+0500	Runner	Posted notification willShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:37:17.805516+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:37:17.805958+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:37:17.806334+0500	Runner	All generators are not complete.
default	15:37:17.806365+0500	Runner	All generators are not complete.
default	15:37:17.806453+0500	Runner	All generators are not complete.
default	15:37:17.811027+0500	Runner	All generators are not complete.
default	15:37:17.824405+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:17.852950+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:37:17.854969+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:37:17.855051+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - 94711EEA
default	15:37:17.855082+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x130cf8280> to candidate receiver, for request token: 94711EEA
default	15:37:17.855153+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. 94711EEA.
default	15:37:18.762525+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:18.837600+0500	Runner	App is being debugged, do not track this hang
default	15:37:18.837639+0500	Runner	Hang detected: 0.96s (debugger attached, not reporting)
default	15:37:18.839591+0500	Runner	TX setWindowContextID:2226275843 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:18.840194+0500	Runner	Remote touch surface type has been initialized to: Unknown
default	15:37:18.840214+0500	Runner	Remote microphone capability has been initialized to: NO
default	15:37:18.841358+0500	Runner	Posted notification didShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
fault	15:37:18.885118+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 2C 11 0A 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 CC 0A 0A 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A0 D0 2E 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 2C D3 2E 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C C6 01 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 68 C9 01 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E4 C0 01 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 8C FC A9 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 FF A9 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 7C 0A AA 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 24 27 A9 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 48 62 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 D6 30 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 56 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C 1C A9 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 80 F4 A8 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 21 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 EE 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 0D 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C4 07 07 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:18.905323+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6B 92 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F AC 3A 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 60 3A 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 1C 37 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 94 38 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 78 36 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 58 36 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F DC 35 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F A8 35 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F D0 5F 0B 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 9C 13 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D0 75 14 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 1F 31 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 DC 23 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 A5 36 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 78 4F 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 68 1C 18 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 48 B9 36 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 13 1D 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 31 54 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 6B 1C 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 37 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 10 4E 99 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 44 35 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC BD 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC 6E E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 5A E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 54 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F0 64 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 65 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 6C 39 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C8 9F 22 01 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D8 80 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 8C E1 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D4 CC 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 98 F3 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:18.937503+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6B 92 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F AC 3A 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 60 3A 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 1C 37 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 94 38 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 78 36 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F 58 36 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F DC 35 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F A8 35 00 00 53 C4 7C 6B 3C D4 3B FF BE CF E7 04 2A 29 64 3F D0 5F 0B 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 9C 13 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D0 75 14 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 1F 31 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 DC 23 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 A5 36 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 78 4F 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 68 1C 18 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 48 B9 36 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 13 1D 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B8 31 54 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 5C 6B 1C 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 37 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 10 4E 99 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 44 35 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC BD 25 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC 6E E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 5A E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 54 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F0 64 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 65 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 6C 39 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C8 9F 22 01 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D8 80 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 8C E1 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D4 CC 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 98 F3 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:19.017560+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:19.017608+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:19.017643+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:19.017766+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:19.848660+0500	Runner	Performing delayed generation for token=94711EEA
default	15:37:19.848974+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:37:19.849505+0500	Runner	Could not match any valid candidates of any source. `containerToPush` will be nil. 94711EEA
default	15:37:19.849666+0500	Runner	Preparing to push (null) to candidate receiver, for request token: 94711EEA
error	15:37:19.849694+0500	Runner	containerToPush is nil, will not push anything to candidate receiver for request token: 94711EEA
default	15:37:19.883599+0500	Runner	App is being debugged, do not track this hang
default	15:37:19.883640+0500	Runner	Hang detected: 0.87s (debugger attached, not reporting)
default	15:37:19.884046+0500	Runner	Reloading input views for key-window scene responder: <(null): 0x0; > force:N
default	15:37:19.884120+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 0 force: 0, fromBecomeFirstResponder: 0 (automaticKeyboard: 0, reloadIdentifier: FF5DB909-3001-4552-AC79-256DE7603E35)
default	15:37:19.884175+0500	Runner	_inputViewsForResponder: <(null): 0x0; >, automaticKeyboard: 0, force: 0
default	15:37:19.884203+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:37:19.884282+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:37:19.884299+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 0 (automaticKeyboardEnabled: 0, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 1, requiresKBWhenFirstResponder: 0)
default	15:37:19.884311+0500	Runner	_inputViewsForResponder, useKeyboard 0 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 0)
default	15:37:19.884334+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:37:19.884356+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff90b40>; (empty)>
default	15:37:19.884435+0500	Runner	currently observing: YES
default	15:37:19.884852+0500	Runner	currently observing: NO
default	15:37:19.884948+0500	Runner	-_teardownExistingDelegate:<FlutterTextInputView: 0x105629400> forSetDelegate:(nil) force:NO delayEndInputSession:NO
default	15:37:19.886949+0500	Runner	-[RTIInputSystemClient endRemoteTextInputSessionWithID:options:completion:]  Ending text input session. sessionID = 75EAEE6C-BDA5-4C50-9A84-B605D92BD544, options = <RTISessionOptions: 0x130cf84e0; shouldResign = YES; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:37:19.886990+0500	Runner	-[RTIInputSystemClient _endSessionWithID:forServices:options:completion:]  End input session: 75EAEE6C-BDA5-4C50-9A84-B605D92BD544
default	15:37:19.893901+0500	Runner	-[RTIInputSystemClient endAllowingRemoteTextInput:completion:]  End allowing remote text input: 75EAEE6C-BDA5-4C50-9A84-B605D92BD544
default	15:37:19.894129+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = NO)
default	15:37:19.894263+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:37:19.896593+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90b40>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.897104+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {0, 0}} visible: 0; notifyRemote: 1; isMinimized: NO
default	15:37:19.897146+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:N
default	15:37:19.897291+0500	Runner	TX signalKeyboardChanged
default	15:37:19.897300+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x12ce43a80>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfc620 -> <CAFenceHandle:0x1490e7250 name=8 fence=4c00000fea usable=YES>>; position {{0, 0}, {0, 0}}; animated YES; on screen NO; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfc620 -> <CAFenceHandle:0x1490e7250 name=8 fence=4c00000fea usable=YES>>; position {{0, 0}, {0, 0}} (with IAV same); floating 0; on screen NO;  intersectable YES; snapshot YES>
default	15:37:19.897444+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:37:19.897468+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff91080>; (empty)>
default	15:37:19.899620+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.899789+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.901784+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.901797+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.902192+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.902214+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.902302+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.902309+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.902339+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91080>; (empty)> windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.902359+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:37:19.903477+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:37:19.903527+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.903537+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.903738+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.903821+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.904145+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.904160+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.904252+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.904545+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:19.904686+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOnScreen> toPlacement: <UIInputViewSetPlacementOffScreenDown> update to: {{0, 852}, {393, 335}}
default	15:37:19.904745+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x130cf94e0 State: offscreen; is docked>; frame={{0, 852}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x130c7db00, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:37:19.904795+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 0} [previous size: {393, 335}]
default	15:37:19.905232+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff91140>; (empty)>
default	15:37:19.905297+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 0} [previous size={393, 335}]
default	15:37:19.905421+0500	Runner	Placeholder height changed from 335.0 to 0.0
default	15:37:19.905445+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91140>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:19.905555+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:37:19.905612+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:37:19.907205+0500	Runner	Posted notification willHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
error	15:37:19.907336+0500	Runner	<0x105619a40> Gesture: System gesture gate timed out.
default	15:37:19.908032+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:19.908051+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:19.908199+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:19.908224+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:19.908265+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:19.908318+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:19.908561+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:19.908591+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:19.908688+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:19.908720+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:19.916713+0500	Runner	[0x11e23ee40] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:19.930742+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:19.938766+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:75EAEE6C-BDA5-4C50-9A84-B605D92BD544 timestamp:790511839.938496 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511837.7249759";
}
default	15:37:19.939506+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:(null) timestamp:790511839.939328 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511839.890025";
}
default	15:37:19.940233+0500	Runner	channel:LegacyTextInputActions signal:DidSessionEnd sessionID:75EAEE6C-BDA5-4C50-9A84-B605D92BD544 timestamp:790511839.939885 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511839.890025";
}
fault	15:37:19.953124+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C 4C FB 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 05 FB 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC 26 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 4C 26 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC A9 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E8 65 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 54 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 5C EC 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:19.956983+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 0C 4C FB 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 05 FB 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC 26 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 4C 26 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 10 E0 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 AC A9 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E8 65 00 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 54 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 5C EC 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 CF 05 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 18 78 03 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 40 44 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:20.015197+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:20.287821+0500	Runner	TX setWindowContextID:2226275843 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:20.292572+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90600>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:37:20.292659+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91140>; (empty)>
default	15:37:20.292783+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91140>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:20.295021+0500	Runner	-[UIDictationController setIgnoreFinalizePhrases:] Setting ignoreFinalizePhrases flag 1
default	15:37:20.295051+0500	Runner	Posted notification didHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:37:20.295629+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90540>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:37:20.295695+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91080>; (empty)>
default	15:37:20.408879+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:20.926786+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:20.927521+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:20.927741+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:20.927793+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:20.930941+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:20.984453+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:20.984539+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:20.984565+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:20.996242+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:20.998358+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:20.998380+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:20.998398+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:20.998414+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:20.998449+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:21.001049+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:21.534707+0500	Runner	flutter: 🔧 DEBUG: sendMessageWithRAG начался
default	15:37:21.534753+0500	Runner	flutter: 🔧 DEBUG: session.user.id = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:37:21.534847+0500	Runner	flutter: 🔧 DEBUG: chatId = null
fault	15:37:21.542470+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B0 77 58 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 61 5B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 50 B5 96 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 F8 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 1F 4D 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:37:21.556173+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B0 77 58 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 54 61 5B 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 50 B5 96 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 28 F8 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 3C 1F 4D 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:21.557605+0500	Runner	nw_path_libinfo_path_check [2A5146E1-AFFC-4447-89D4-130EE1820B91 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:21.571214+0500	Runner	nw_path_libinfo_path_check [2E2E0A14-01CA-46F7-87EC-4C7E7FEBB8B5 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:37:21.769874+0500	Runner	[0x12ff2c780] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:21.772442+0500	Runner	[0x12ff2c780] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:23.109714+0500	Runner	App is being debugged, do not track this hang
default	15:37:23.109724+0500	Runner	Hang detected: 0.77s (debugger attached, not reporting)
default	15:37:23.956486+0500	Runner	App is being debugged, do not track this hang
default	15:37:23.956553+0500	Runner	Hang detected: 0.78s (debugger attached, not reporting)
default	15:37:24.999563+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	15:37:24.000086+0500	Runner	-[SOConfigurationClient init]  on <SOConfigurationClient: 0x130cf8ae0>
default	15:37:24.000210+0500	Runner	[0x12ff2ebc0] activating connection: mach=true listener=false peer=false name=com.apple.AppSSO.service-xpc
default	15:37:24.000308+0500	Runner	<SOServiceConnection: 0x130cf9380>: new XPC connection
default	15:37:24.003165+0500	Runner	Requesting container lookup; class = 13, identifier = com.apple.nsurlsessiond, group_identifier = systemgroup.com.apple.nsurlstoragedresources, create = 1, temp = 0, euid = 501, uid = 501
default	15:37:24.005151+0500	Runner	_container_query_get_result_at_index: success
default	15:37:24.005184+0500	Runner	container_system_group_path_for_identifier: success
default	15:37:24.006601+0500	Runner	Connection 0: creating secure tcp or quic connection
default	15:37:24.007004+0500	Runner	Connection 1: enabling TLS
default	15:37:24.007112+0500	Runner	Connection 1: starting, TC(0x0)
default	15:37:24.007178+0500	Runner	[C1 33A0C58F-84F2-4C0B-AD9E-88276FB33BC6 o4509632462782464.ingest.de.sentry.io:443 quic-connection, url: https://o4509632462782464.ingest.de.sentry.io/api/4509648222617680/envelope/, definite, attribution: developer, context: com.apple.CFNetwork.NSURLSession.{99847779-F6A4-4B4B-936A-861954E6BB52}{(null)}{Y}{3}{0x0} (sensitive), proc: 605191A0-C542-327B-B976-EE2CB81CF1E5, delegated upid: 0] start
default	15:37:24.007324+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 initial parent-flow ((null))] event: path:start @0.000s
default	15:37:24.007529+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 waiting parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.000s, uuid: 3A45FEAF-E014-4626-A456-05E51C15AA1B
default	15:37:24.007638+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_connect @0.000s
default	15:37:24.007646+0500	Runner	nw_connection_report_state_with_handler_on_nw_queue [C1] reporting state preparing
default	15:37:24.007667+0500	Runner	[C1 o4509632462782464.ingest.de.sentry.io:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_child @0.000s
default	15:37:24.007736+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 initial path ((null))] event: path:start @0.000s
default	15:37:24.008444+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.001s, uuid: 3A45FEAF-E014-4626-A456-05E51C15AA1B
default	15:37:24.008517+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: transform:start @0.001s
default	15:37:24.008614+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 initial path ((null))] event: path:start @0.001s
default	15:37:24.008755+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.001s, uuid: EC9B220E-8AFE-442E-BB02-12C82E38BDC6
default	15:37:24.009073+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: resolver:start_dns @0.001s
default	15:37:24.009092+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> setting up Connection 1
fault	15:37:24.010409+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 9C 4B 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 C2 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C FF 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 48 D2 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 58 7B 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 A6 1F 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 88 28 06 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF B0 37 0E 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 4C CB 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC D4 D7 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 20 9B 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC C4 91 01 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 B8 13 00 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:24.233438+0500	Runner	nw_endpoint_resolver_update [C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Adding endpoint handler for 34.160.81.0:443
default	15:37:24.233489+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 in_progress resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: resolver:receive_dns @0.226s
default	15:37:24.233545+0500	Runner	[C1.1.1.1 34.160.81.0:443 initial path ((null))] event: path:start @0.226s
default	15:37:24.233825+0500	Runner	[C1.1.1.1 34.160.81.0:443 waiting path (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: path:satisfied @0.226s, uuid: 37CE131D-AF42-4C62-824C-5FAEAE1B9A14
default	15:37:24.233870+0500	Runner	[C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_nexus @0.226s
default	15:37:24.234194+0500	Runner	[C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:receive_nexus @0.227s
default	15:37:24.234416+0500	Runner	user_tcp_init_all_block_invoke g_tcp_nw_assert_context is false value -1
default	15:37:24.235192+0500	Runner	[C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:start_connect @0.228s
default	15:37:24.235384+0500	Runner	tcp_output [C1.1.1.1:3] flags=[SEC] seq=2026361350, ack=0, win=65535 state=SYN_SENT rcv_nxt=0, snd_una=2026361350
default	15:37:24.315537+0500	Runner	tcp_input [C1.1.1.1:3] flags=[S.] seq=3821115298, ack=2026361351, win=65535 state=SYN_SENT rcv_nxt=0, snd_una=2026361350
default	15:37:24.315558+0500	Runner	nw_flow_connected [C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Transport protocol connected (tcp)
default	15:37:24.315632+0500	Runner	[C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:finish_transport @0.308s
default	15:37:24.315741+0500	Runner	boringssl_session_apply_protocol_options_for_transport_block_invoke_2(2323) [C1.1.1.1:2][0x130c374e0] TLS configured [min_version(0x0303) max_version(0x0304) name(o4509632462782464.ingest.de.sentry.io) tickets(false) false_start(false) enforce_ev(false) enforce_ats(false) ats_non_pfs_ciphersuite_allowed(false) ech(false) pqtls(true), pake(false)]
default	15:37:24.315856+0500	Runner	boringssl_context_info_handler(2390) [C1.1.1.1:2][0x130c374e0] Client handshake started
default	15:37:24.316015+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS client enter_early_data
default	15:37:24.316302+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS client read_server_hello
default	15:37:24.398891+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_hello_retry_request
default	15:37:24.398945+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_server_hello
default	15:37:24.399137+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_encrypted_extensions
default	15:37:24.399301+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_certificate_request
default	15:37:24.399315+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_server_certificate
default	15:37:24.399352+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_server_certificate_verify
default	15:37:24.399442+0500	Runner	boringssl_context_evaluate_trust_async(1833) [C1.1.1.1:2][0x130c374e0] Performing external trust evaluation
default	15:37:24.399483+0500	Runner	boringssl_context_evaluate_trust_async_external(1818) [C1.1.1.1:2][0x130c374e0] Asyncing for external verify block
default	15:37:24.399564+0500	Runner	Connection 1: asked to evaluate TLS Trust
default	15:37:24.399847+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> auth completion disp=1 cred=0x0
default	15:37:24.399996+0500	Runner	(Trust 0x130c43900) No pending evals, starting
default	15:37:24.400207+0500	Runner	[0x12ff2db80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:24.400307+0500	Runner	(Trust 0x130c43900) Completed async eval kickoff
default	15:37:24.413225+0500	Runner	(Trust 0x130c43900) trustd returned 4
default	15:37:24.413295+0500	Runner	System Trust Evaluation yielded status(0)
default	15:37:24.413307+0500	Runner	(Trust 0x130c43780) No pending evals, starting
default	15:37:24.413424+0500	Runner	[0x12ff2da40] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:24.413589+0500	Runner	(Trust 0x130c43780) Completed async eval kickoff
default	15:37:24.413635+0500	Runner	[0x12ff2db80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:24.415395+0500	Runner	(Trust 0x130c43780) trustd returned 4
default	15:37:24.415571+0500	Runner	Connection 1: TLS Trust result 0
default	15:37:24.415671+0500	Runner	boringssl_context_evaluate_trust_async_external_block_invoke_3(1773) [C1.1.1.1:2][0x130c374e0] Returning from external verify block with result: true
default	15:37:24.415874+0500	Runner	boringssl_context_certificate_verify_callback(2014) [C1.1.1.1:2][0x130c374e0] Certificate verification result: OK
default	15:37:24.415895+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client read_server_finished
default	15:37:24.416049+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client send_end_of_early_data
default	15:37:24.416095+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client send_client_encrypted_extensions
default	15:37:24.416244+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client send_client_certificate
default	15:37:24.416284+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client complete_second_flight
default	15:37:24.416337+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS 1.3 client done
default	15:37:24.416548+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS client finish_client_handshake
default	15:37:24.416598+0500	Runner	boringssl_context_info_handler(2407) [C1.1.1.1:2][0x130c374e0] Client handshake state: TLS client done
default	15:37:24.416649+0500	Runner	boringssl_context_info_handler(2396) [C1.1.1.1:2][0x130c374e0] Client handshake done
default	15:37:24.416827+0500	Runner	nw_protocol_boringssl_signal_connected(895) [C1.1.1.1:2][0x130c374e0] TLS connected [server(0) version(0x0304) ciphersuite(TLS_AES_256_GCM_SHA384) group(0x001d) signature_alg(0x0804) alpn(h2) resumed(0) offered_ticket(0) in_early_data(0) early_data_accepted(0) false_started(0) ocsp_received(0) sct_received(0) connect_time(101ms) flight_time(84ms) rtt(83ms) write_stalls(0) read_stalls(8) pake(0x0000)]
default	15:37:24.416888+0500	Runner	nw_flow_connected [C1.1.1.1 34.160.81.0:443 in_progress channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Output protocol connected (CFNetworkConnection-1920096393)
default	15:37:24.417078+0500	Runner	[C1.1.1.1 34.160.81.0:443 ready channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @0.410s
default	15:37:24.417141+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 ready resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @0.410s
default	15:37:24.417179+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:child_finish_connect @0.410s
default	15:37:24.417243+0500	Runner	[C1.1.1.1 34.160.81.0:443 ready channel-flow (satisfied (Path is satisfied), viable, interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @0.410s
default	15:37:24.417289+0500	Runner	[C1.1.1 o4509632462782464.ingest.de.sentry.io:443 ready resolver (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @0.410s
default	15:37:24.417330+0500	Runner	[C1.1 o4509632462782464.ingest.de.sentry.io:443 ready transform (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @0.410s
default	15:37:24.417377+0500	Runner	nw_flow_connected [C1 34.160.81.0:443 in_progress parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] Output protocol connected (endpoint_flow)
default	15:37:24.417423+0500	Runner	[C1 34.160.81.0:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:finish_connect @0.410s
default	15:37:24.417506+0500	Runner	nw_connection_report_state_with_handler_on_nw_queue [C1] reporting state ready
default	15:37:24.417541+0500	Runner	[C1 34.160.81.0:443 ready parent-flow (satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good)] event: flow:changed_viability @0.410s
default	15:37:24.417582+0500	Runner	nw_connection_send_viability_changed_on_nw_queue [C1] viability_changed_handler(true)
default	15:37:24.417643+0500	Runner	[0x12ff2da40] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:24.417695+0500	Runner	Connection 1: connected successfully
default	15:37:24.417735+0500	Runner	Connection 1: TLS handshake complete
default	15:37:24.417762+0500	Runner	Connection 1: ready C(N) E(N)
default	15:37:24.417860+0500	Runner	[C1] event: client:connection_reused @0.410s
default	15:37:24.417896+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	15:37:24.417922+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:24.418265+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> now using Connection 1
default	15:37:24.418349+0500	Runner	Connection 1: received viability advisory(Y)
default	15:37:24.418827+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> sent request, body S 24900
default	15:37:24.606333+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> received response, status 200 content K
default	15:37:24.606802+0500	Runner	[0x12ff2db80] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:37:24.610500+0500	Runner	[0x12ff2db80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:37:24.610810+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> done using Connection 1
default	15:37:24.610866+0500	Runner	[C1] event: client:connection_idle @0.603s
default	15:37:24.610948+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	15:37:24.610964+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:24.611040+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> response ended
default	15:37:24.611556+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> summary for task success {transaction_duration_ms=609, response_status=200, connection=1, protocol="h2", domain_lookup_duration_ms=225, connect_duration_ms=182, secure_connection_duration_ms=101, private_relay=false, request_start_ms=416, request_duration_ms=0, response_start_ms=603, response_duration_ms=5, request_bytes=25164, request_throughput_kbps=615649, response_bytes=337, response_throughput_kbps=533, cache_hit=false}
default	15:37:24.611984+0500	Runner	Task <FAEBEB08-32BF-4FDD-AE41-C95715EB4A2A>.<1> finished successfully
default	15:37:24.616115+0500	Runner	Garbage collection for alternative services
fault	15:37:24.743304+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"-[NSFileManager removeItemAtPath:error:] is performing excessive I/O which will reduce the health of storage devices.","antipattern trigger":"-[NSFileManager removeItemAtPath:error:]","message type":"suppressable","issue type":2,"category type":17,"subcategory type":8192,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF BC C3 14 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 01 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF F0 92 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 48 99 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D8 7B 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 48 AD 18 00 10 36 11 C7 B6 84 34 E7 B4 D8 DE 21 61 3D 60 A5 54 7B 0D 00 10 36 11 C7 B6 84 34 E7 B4 D8 DE 21 61 3D 60 A5 A0 C9 08 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 4C CB 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 08 D8 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 20 9B 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC C4 91 01 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 B8 13 00 00 74 1C 5A FB 3F 30 36 2E 93 13 AA B3 DE 24 97 C9 C0 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:24.765301+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	15:37:24.766823+0500	Runner	[C1] event: client:connection_reused @0.759s
default	15:37:24.766901+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	15:37:24.766911+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:24.767035+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> now using Connection 1
default	15:37:24.767218+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> sent request, body S 3969
default	15:37:24.881364+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> received response, status 200 content K
default	15:37:24.881839+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> done using Connection 1
default	15:37:24.881957+0500	Runner	[C1] event: client:connection_idle @0.874s
default	15:37:24.882170+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	15:37:24.882221+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:24.882251+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> response ended
default	15:37:24.882292+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> summary for task success {transaction_duration_ms=115, response_status=200, connection=1, reused=1, reused_after_ms=155, request_start_ms=0, request_duration_ms=0, response_start_ms=114, response_duration_ms=0, request_bytes=4028, request_throughput_kbps=166040, response_bytes=95, response_throughput_kbps=1002, cache_hit=false}
default	15:37:24.882363+0500	Runner	Task <59016A42-9B83-48F5-8716-556166821120>.<2> finished successfully
fault	15:37:25.786995+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 38 5A 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:25.790215+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	15:37:25.790914+0500	Runner	[C1] event: client:connection_reused @1.783s
default	15:37:25.791001+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	15:37:25.791008+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:25.791193+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> now using Connection 1
default	15:37:25.791500+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> sent request, body S 3980
fault	15:37:25.796497+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 38 5A 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:25.905240+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> received response, status 200 content K
default	15:37:25.905281+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> done using Connection 1
default	15:37:25.905390+0500	Runner	[C1] event: client:connection_idle @1.898s
default	15:37:25.905443+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	15:37:25.905452+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:25.905563+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> response ended
default	15:37:25.905591+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> summary for task success {transaction_duration_ms=114, response_status=200, connection=1, reused=1, reused_after_ms=909, request_start_ms=0, request_duration_ms=0, response_start_ms=114, response_duration_ms=0, request_bytes=4039, request_throughput_kbps=219831, response_bytes=95, response_throughput_kbps=2382, cache_hit=false}
default	15:37:25.905663+0500	Runner	Task <5BF628BC-1E49-4C38-AE1A-330BC4EBA156>.<3> finished successfully
default	15:37:27.256987+0500	Runner	flutter: CHIPS http_status=200
default	15:37:27.257061+0500	Runner	flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
default	15:37:27.257117+0500	Runner	flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:37:27.257141+0500	Runner	flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:37:30.353714+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.353737+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.353774+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.366502+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.368210+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.368279+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.369574+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.369615+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.369632+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.378268+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.378279+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.378290+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.386363+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.386497+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.386523+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.386600+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:30.386656+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.386673+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.386708+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.394510+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.394527+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.394536+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.402884+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.402934+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.402975+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.411191+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.411236+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.411276+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.419615+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.419636+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.419697+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.430157+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.430253+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.430316+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.436402+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.436496+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.436518+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.445851+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.446197+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.446228+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.453139+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.453258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.453334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.461646+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.461661+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.461736+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.469681+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.469782+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.469811+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.478319+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.478364+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.478409+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.486357+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.486438+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.486830+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.495016+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.495027+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.495037+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.503101+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.503160+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.503274+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.515474+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.515903+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.515917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.519596+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.519640+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.519681+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.528328+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.528454+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.528485+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.536338+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.536412+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.536432+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.553086+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.553129+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.553221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.588923+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.588937+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.588959+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:30.619576+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:30.619596+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:30.620783+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.203253+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.203305+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.203334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.211760+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.211775+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.211791+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.220010+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.220071+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.220211+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.230834+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.231420+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.231450+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.236633+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.236721+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.236752+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.245150+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.245157+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.245248+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.254038+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.254112+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.254133+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.262603+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.262612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.262623+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.269912+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.269983+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.270011+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.278520+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.278538+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.278568+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.286863+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.286906+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.286948+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.295137+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.295192+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.295243+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.303292+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.303324+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.303359+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.311506+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.312001+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.312027+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.319833+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.319910+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.319951+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.328461+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.328485+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.328541+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.336503+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.336570+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.336592+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.345134+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.345160+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.345244+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.353084+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.353131+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.353172+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.364331+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.364346+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.364357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:31.364367+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:31.364379+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:31.364387+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:33.804250+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:37:33.807641+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:33.807687+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:33.807895+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:33.807923+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:33.966455+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:33.966648+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:33.966662+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:33.999368+0500	Runner	Reloading input views for key-window scene responder: <FlutterTextInputView: 0x12ff14000; frame = (0 0; 1 1); > force:N
default	15:37:33.999402+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 1 force: 0, fromBecomeFirstResponder: 1 (automaticKeyboard: 1, reloadIdentifier: 9F995D71-5A0F-41DE-ABE2-F7A6D28306D3)
default	15:37:33.999434+0500	Runner	_inputViewsForResponder: <FlutterTextInputView: 0x12ff14000; frame = (0 0; 1 1); >, automaticKeyboard: 1, force: 0
default	15:37:34.999500+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:37:34.999514+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:37:34.999528+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 1 (automaticKeyboardEnabled: 1, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 0, requiresKBWhenFirstResponder: 1)
default	15:37:34.999548+0500	Runner	_inputViewsForResponder, useKeyboard 1 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 1)
default	15:37:34.002687+0500	Runner	_inputViewsForResponder, found assistantVC: <UISystemInputAssistantViewController: 0x105634a00; frame = {{0, 0}, {393, 44}}> (should suppress: 0, _dontNeed: 0)
default	15:37:34.002698+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:37:34.002707+0500	Runner	_inputViewsForResponder, useKeyboard ivs: <UIInputViewSet: 0x12ff90000>
default	15:37:34.002904+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff90000>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:37:34.002969+0500	Runner	currently observing: YES
default	15:37:34.003025+0500	Runner	currently observing: NO
default	15:37:34.003042+0500	Runner	-_teardownExistingDelegate:(nil) forSetDelegate:<FlutterTextInputView: 0x12ff14000> force:NO delayEndInputSession:YES
default	15:37:34.003968+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:37:34.011042+0500	Runner	[0x12fe7e080] activating connection: mach=true listener=false peer=false name=com.apple.TextInput
default	15:37:34.011780+0500	Runner	channel:CandidateBar signal:Reset uniqueStringId:(null) creationTimestamp:790511854.011647 timestamp:790511854.011695 payload:(null)
default	15:37:34.014548+0500	Runner	-[RTIInputSystemClient beginAllowingRemoteTextInput:]  Begin allowing remote text input: 09914883-CB9B-4C92-AC5D-5A7DF9AC455B
default	15:37:34.014571+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = YES)
default	15:37:34.015264+0500	Runner	-[RTIInputSystemClient _beginSessionWithID:forServices:force:]  Begin text input session. sessionID = 09914883-CB9B-4C92-AC5D-5A7DF9AC455B, options = <RTISessionOptions: 0x12e5dff40; shouldResign = NO; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:37:34.038873+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:37:34.039361+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:37:34.039375+0500	Runner	All generators are not complete.
default	15:37:34.039385+0500	Runner	All generators are not complete.
default	15:37:34.039398+0500	Runner	All generators are not complete.
default	15:37:34.039706+0500	Runner	TX setWindowContextID:0 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:34.039715+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90000>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.039738+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.039890+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 352}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:37:34.039983+0500	Runner	Change from input view set: (null)
default	15:37:34.039988+0500	Runner	Change to input view set: (null)
default	15:37:34.040257+0500	Runner	Change from input view set: (null)
default	15:37:34.040263+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff90b40>; (empty)>
default	15:37:34.043068+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:37:34.043081+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:37:34.043396+0500	Runner	TX signalKeyboardChanged
default	15:37:34.043442+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x148294780>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfc9e0 -> <CAFenceHandle:0x1490e4700 name=b fence=4c00000feb usable=YES>>; position {{0, 500}, {393, 352}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfc9e0 -> <CAFenceHandle:0x1490e4700 name=b fence=4c00000feb usable=YES>>; position {{0, 500}, {393, 352}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:37:34.043456+0500	Runner	TX setWindowContextID:2799989504 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:34.043508+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:37:34.043514+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff91740>; keyboard = [uninitialized]; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:37:34.044363+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.044486+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.058157+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:37:34.060609+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90b40>; (empty)>
default	15:37:34.060652+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:37:34.060658+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: -[_UIKBFeedbackGenerator activateWithCompletionBlock:]
default	15:37:34.063988+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: Nothing to activate. Keyboard feedback is disabled.
default	15:37:34.065788+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.065809+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.066456+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.066483+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.068150+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.068198+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.068734+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.069029+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.073930+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.073983+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.074192+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.074444+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.074599+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.075117+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.076939+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.079746+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.090097+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:37:34.090378+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.091136+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.091183+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.091275+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.091907+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.092861+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.093422+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91740>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.093506+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.094310+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 335}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:37:34.094675+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:37:34.094721+0500	Runner	TX signalKeyboardChanged
default	15:37:34.094729+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x148294600>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfcd40 -> <CAFenceHandle:0x1490e4000 name=d fence=4c00000feb usable=YES>>; position {{0, 517}, {393, 335}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfcd40 -> <CAFenceHandle:0x1490e4000 name=d fence=4c00000feb usable=YES>>; position {{0, 517}, {393, 335}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:37:34.094860+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOffScreenDown> toPlacement: <UIInputViewSetPlacementOnScreen> update to: {{0, 517}, {393, 335}}
default	15:37:34.094949+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x105cb4700 State: onscreen with input view; is docked>; frame={{0, 517}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x1482f1140, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:37:34.094989+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 335} [previous size: {393, 0}]
default	15:37:34.095793+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff91800>; keyboard = [uninitialized]; usesKeyClicks = NO;  >
default	15:37:34.095873+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91800>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.096234+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.096358+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:37:34.097009+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff91140>; (empty)>
default	15:37:34.097081+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91800>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:37:34.097121+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 0}]
default	15:37:34.097181+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91800>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:37:34.098154+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:37:34.103243+0500	Runner	All generators are not complete.
default	15:37:34.104223+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:37:34.105293+0500	Runner	Posted notification willShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:37:34.107017+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:37:34.127263+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:37:34.135502+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:37:34.135565+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - 486B00FE
default	15:37:34.135617+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x130cf8b20> to candidate receiver, for request token: 486B00FE
default	15:37:34.135822+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. 486B00FE.
default	15:37:34.176943+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:34.181700+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:36.027163+0500	Runner	Performing delayed generation for token=486B00FE
default	15:37:36.031100+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:36.034923+0500	Runner	channel:LegacyTextInputActions signal:DidSessionBegin sessionID:09914883-CB9B-4C92-AC5D-5A7DF9AC455B timestamp:790511856.034503 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511854.016645";
}
default	15:37:36.098081+0500	Runner	App is being debugged, do not track this hang
default	15:37:36.099890+0500	Runner	Hang detected: 1.91s (debugger attached, not reporting)
default	15:37:36.102092+0500	Runner	TX setWindowContextID:2799989504 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:37:36.103070+0500	Runner	Posted notification didShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:37:38.670063+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:38.670068+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:37:38.670078+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:37:38.670114+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:37:38.671721+0500	Runner	Reloading input views for key-window scene responder: <(null): 0x0; > force:N
default	15:37:38.671731+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 0 force: 0, fromBecomeFirstResponder: 0 (automaticKeyboard: 0, reloadIdentifier: 39CA478B-0183-4566-ACAE-61308AF03C83)
default	15:37:38.671750+0500	Runner	_inputViewsForResponder: <(null): 0x0; >, automaticKeyboard: 0, force: 0
default	15:37:38.671756+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:37:38.671761+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:37:38.671768+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 0 (automaticKeyboardEnabled: 0, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 1, requiresKBWhenFirstResponder: 0)
default	15:37:38.671775+0500	Runner	_inputViewsForResponder, useKeyboard 0 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 0)
default	15:37:38.671786+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:37:38.671796+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff91d40>; (empty)>
default	15:37:38.671807+0500	Runner	currently observing: YES
default	15:37:40.988967+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	15:37:40.989104+0500	Runner	[C1] event: client:connection_reused @16.942s
default	15:37:40.989129+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	15:37:40.989136+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:40.989144+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> now using Connection 1
default	15:37:40.989168+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> sent request, body S 4061
default	15:37:41.609968+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> received response, status 200 content K
default	15:37:41.610066+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> done using Connection 1
default	15:37:41.610095+0500	Runner	[C1] event: client:connection_idle @17.056s
default	15:37:41.610120+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	15:37:41.610146+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:37:41.610522+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> response ended
default	15:37:41.610589+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> summary for task success {transaction_duration_ms=114, response_status=200, connection=1, reused=1, reused_after_ms=935, request_start_ms=0, request_duration_ms=0, response_start_ms=113, response_duration_ms=1, request_bytes=4120, request_throughput_kbps=95275, response_bytes=95, response_throughput_kbps=548, cache_hit=false}
default	15:37:41.611109+0500	Runner	Task <E82E6CD7-507C-4BFC-B558-27ABCE0F1770>.<6> finished successfully
default	15:37:41.898659+0500	Runner	[(FBSceneManager):sceneID:bizlevel.kz-default] Received action(s): UIDidTakeScreenshotAction
default	15:37:41.899548+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:37:42.023832+0500	Runner	RX sceneBecameFocused:(null)
default	15:37:42.099354+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:42.662082+0500	Runner	[(FBSceneManager):sceneID:bizlevel.kz-default] Received action(s) in scene-update: <UIScreenshotMetadataRequestAction: 0x002525a6>
default	15:37:43.203068+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:43.203958+0500	Runner	Send response for action with key: 3
default	15:37:43.205540+0500	Runner	App is being debugged, do not track this hang
default	15:37:43.205890+0500	Runner	Hang detected: 1.15s (debugger attached, not reporting)
default	15:37:43.235125+0500	Runner	flutter: CHIPS http_status=200
default	15:37:43.235148+0500	Runner	flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
default	15:37:43.235172+0500	Runner	flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:37:43.235199+0500	Runner	flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
fault	15:37:43.236810+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"dlopen","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 28 8D 13 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A E4 8D 13 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A F4 FD 19 00 5B 87 77 BC D6 AD 3F AC 88 80 09 09 8A D4 C9 11 30 56 00 00 5B 87 77 BC D6 AD 3F AC 88 80 09 09 8A D4 C9 11 BC 66 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 84 33 EA 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 98 50 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 14 65 87 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 20 70 87 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 3E ED 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC C8 FB 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 40 E8 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 78 F8 01 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC C4 F9 08 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC CC BA 04 00 EB 9C C7 09 A4 62 37 A2 9F 91 B3 61 C0 39 27 BC 00 BF 02 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 98 89 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A D4 91 00 00 79 67 5C 6B 9D BB 34 81 A3 26 CF EC 9E 73 FF 0A 54 90 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 10 8F 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 84 8E 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 CC 6A 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 D8 D6 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:37:43.286618+0500	Runner	RX keyboardChanged (isLocal:N source:37->app<com.apple.ScreenshotServicesService(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>/UISceneHosting-com.apple.springboard:UIHostedScene-com.apple.ScreenshotServicesService-C311E0F3-B62D-492E-AE6F-F350245E4BC1)
default	15:37:43.286644+0500	Runner	handleKeyboardChange: set currentKeyboard:N (wasKeyboard:N)
default	15:37:43.286667+0500	Runner	Tracking provider: updateProviderFromRemoteUpdate for info: <<<_UIKeyboardChangedInformation: 0x148295380>; appId (null) bundleId (null) animation fence (null); position {{0, 0}, {0, 0}}; animated YES; on screen NO; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas 37->app<com.apple.ScreenshotServicesService(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>/UISceneHosting-com.apple.springboard:UIHostedScene-com.apple.ScreenshotServicesService-C311E0F3-B62D-492E-AE6F-F350245E4BC1; source display (null); source bundle com.apple.ScreenshotServicesService; host bundle (null); animation fence (null); position {{0, 0}, {0, 0}} (with IAV same); floating 0; on screen NO;  intersectable YES; snapshot NO> update to {{0, 0}, {0, 0}}
default	15:37:43.286710+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x130cfb660 State: offscreen; is docked>; frame={{0, 0}, {0, 0}}; animation=<TUIKeyboardAnimationInfo: 0x1482f20c0, duration: 0.38, from remote keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {0, 0}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {0, 0}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {0, 0}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 0}, {0, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 0}, {0, 0}}";
    UIKeyboardIsLocalUserInfoKey = 0;
}notificationsDebug: >>
default	15:37:43.286866+0500	Runner	forceReloadInputViews
default	15:37:43.287269+0500	Runner	Reloading input views for key-window scene responder: <(null): 0x0; > force:Y
default	15:37:43.289724+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: none> was:ancestor
default	15:37:43.289952+0500	Runner	Scene target of keyboard event deferring environment did change: 0; scene: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:37:43.292026+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:37:43.668392+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:37:43.668473+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:37:43.668517+0500	Runner	Deactivation reason added: 15; deactivation reasons: 0 -> 32768; animating application lifecycle event: 0
default	15:37:43.668591+0500	Runner	App transitioned to background, suspending HangTracing.
default	15:37:43.668711+0500	Runner	App with bundleID:bizlevel.kz is no longer foreground at time=4086586428244, attempting to emit telemetry with emission type: HTFGUpdateAppBackgrounded
default	15:37:43.669527+0500	Runner	Deactivation reason added: 12; deactivation reasons: 32768 -> 36864; animating application lifecycle event: 0
default	15:38:01.449572+0500	Runner	Not push traits update to screen for new style 1, <UIWindowScene: 0x1057a0200> (BD599607-7944-4E08-8563-2A336AAF206A)
default	15:38:01.449780+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:38:01.450022+0500	Runner	Deactivation reason removed: 12; deactivation reasons: 36864 -> 32768; animating application lifecycle event: 0
default	15:38:01.450155+0500	Runner	Send setDeactivating: N (-DeactivationReason:SuspendedEventsOnly)
default	15:38:01.451374+0500	Runner	Deactivation reason removed: 15; deactivation reasons: 32768 -> 0; animating application lifecycle event: 0
default	15:38:01.451468+0500	Runner	App transitioned to foreground, resuming HangTracing.
default	15:38:01.451484+0500	Runner	Updating event->rollingFGTimestamp from INVALID_FOREGROUND_TIMESTAMP to 4087019730644
default	15:38:01.509912+0500	Runner	sceneOfRecord: sceneID: sceneID:bizlevel.kz-default  persistentID: BD599607-7944-4E08-8563-2A336AAF206A
default	15:38:01.514894+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: ancestor> was:none
default	15:38:01.519556+0500	Runner	Scene target of keyboard event deferring environment did change: 1; scene: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:38:01.519586+0500	Runner	[0x10573c310] Scene target of event deferring environments did update: scene: 0x1057a0200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 0; eligibleForRecordRemoval: 1;
default	15:38:01.523272+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:38:01.738760+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: none> was:ancestor
default	15:38:01.738801+0500	Runner	Scene target of keyboard event deferring environment did change: 0; scene: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:38:02.127800+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.127826+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.127850+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.128377+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.159737+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.159818+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.159872+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.168351+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.168502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.168523+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.176553+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.176609+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.176628+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.185935+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.185945+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.185956+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.193228+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.193296+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.193320+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.193430+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:02.193487+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.193521+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.193532+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.201562+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.201674+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.201719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.209935+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.209980+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.210021+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.218312+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.218744+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.218827+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.226588+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.226622+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.226676+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.235716+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.235738+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.235770+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.243225+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.243251+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.243313+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.252876+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.252926+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.252940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.260054+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.260143+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.260215+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.268579+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.268973+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.269001+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.276602+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.276693+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.276716+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.285778+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.285949+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.285970+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.293266+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.293314+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.293344+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.303850+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.303864+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.303874+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.309990+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.310069+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.310081+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.322174+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.322221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.322233+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:02.322670+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:02.322696+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:02.322712+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.066776+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.066790+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.066993+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.093285+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.099518+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.099531+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.100373+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.100655+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.100692+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.108638+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.108670+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.113965+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.114037+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:03.114062+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.114398+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.114517+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.117151+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.117161+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.117175+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.129623+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.129646+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.129664+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.133367+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.134118+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.134130+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.137195+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.137204+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.137535+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.139214+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.139317+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.139368+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.140906+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.140944+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.140979+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.143691+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.143719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.143738+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.151608+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.151665+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.151686+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.159857+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.159917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.159940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.168634+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.168652+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.168669+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.176563+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.176696+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.176841+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.185893+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.185919+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.185940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.193454+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.193563+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.193603+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.202168+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.202194+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.202970+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.210047+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.210066+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.210079+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:03.210237+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:03.210244+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:03.210254+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:04.160687+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:04.160805+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:04.160815+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:04.160823+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:04.161650+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:04.186626+0500	Runner	policyStatus:<BKSHIDEventDeliveryPolicyObserver: 0x10546de00; token: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; status: ancestor> was:none
default	15:38:04.187208+0500	Runner	Scene target of keyboard event deferring environment did change: 1; scene: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:38:04.187228+0500	Runner	[0x10573c310] Scene target of event deferring environments did update: scene: 0x1057a0200; current systemShellManagesKeyboardFocus: 1; systemShellManagesKeyboardFocusForScene: 0; eligibleForRecordRemoval: 1;
default	15:38:04.187501+0500	Runner	Scene became target of keyboard event deferring environment: UIWindowScene: 0x1057a0200; scene identity: com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default
default	15:38:04.198118+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:04.202696+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:04.218436+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:04.218472+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:04.218486+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:04.226628+0500	Runner	flutter: LEO_DIALOG popInvoked didPop=true result=null allowPop=true caseMode=false
default	15:38:04.260010+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:05.986681+0500	Runner	flutter: LEO_DIALOG dispose caseMode=false chatId=null
default	15:38:05.988748+0500	Runner	App is being debugged, do not track this hang
default	15:38:05.988790+0500	Runner	Hang detected: 1.47s (debugger attached, not reporting)
default	15:38:05.994786+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:05.995302+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:05.995342+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:05.995393+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:05.996723+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:05.996799+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:05.996886+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:05.996937+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:05.996994+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:05.997005+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:05.997016+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
fault	15:38:06.018033+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:06.025113+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D0 F0 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 04 47 43 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:06.055630+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A EC A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:06.820786+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:06.820863+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:06.821249+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:06.821316+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:06.821439+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:06.921915+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:06.922132+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:06.922677+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:06.935726+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
fault	15:38:07.529088+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D4 A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:07.538584+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A AC 5B 56 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 70 DA 97 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A E4 FD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A D4 A0 44 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A B4 BB 42 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 98 CD 45 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 58 57 0A 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A C8 9B 0A 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 00 DC 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 C0 D8 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 34 D4 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 BC DA 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:08.303628+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:08.304308+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:08.304388+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:08.304425+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:08.304450+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:08.370444+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:08.370611+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:08.370628+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
fault	15:38:08.390276+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:08.405343+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData enumerateByteRangesUsingBlock:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A B0 52 91 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 90 6C 91 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 28 09 17 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF C0 6E 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 14 6A 13 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 08 F1 18 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF A4 D7 15 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 50 7B 19 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF D4 8E 27 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 20 8F 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:08.410852+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:08.424108+0500	Runner	nw_path_libinfo_path_check [D6056B22-DCD2-4F00-A488-26C04731C733 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:08.424140+0500	Runner	nw_path_libinfo_path_check [D084CB4B-18F5-43D8-9E8E-EC7B6F3EC61D acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:08.434587+0500	Runner	nw_path_libinfo_path_check [97E7CE64-D34C-447B-B8DE-7C481BB8FDB7 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:08.434814+0500	Runner	nw_path_libinfo_path_check [5731EB6B-1945-4332-A14E-09A7AF2A96C7 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:08.608429+0500	Runner	[0x12ff12d00] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:08.612709+0500	Runner	[0x12ff12d00] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:08.639841+0500	Runner	[0x12ff12d00] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:08.643109+0500	Runner	[0x12ff12d00] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:11.579466+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:11.583266+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:11.583285+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:11.583332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:11.583374+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:11.636714+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:11.637188+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:11.637341+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:11.644706+0500	Runner	playing feedback without gesture recognizer (<nil: 0x0>) or at null point
default	15:38:11.646893+0500	Runner	activate generator with style: TurnOn; activationCount: 0 -> 1; styleActivationCount: 0 -> 1; <UIImpactFeedbackGenerator: 0x12ff92040>
default	15:38:11.647072+0500	Runner	activate engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 0 -> 1
default	15:38:11.647109+0500	Runner	activating engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:11.647156+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Inactive -> Activating
default	15:38:11.647213+0500	Runner	starting core haptics engine for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:11.647227+0500	Runner	creating core haptics engine for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:11.647881+0500	Runner	Registered notify signal com.apple.caulk.alloc.rtdump (0)
default	15:38:11.648262+0500	Runner	[0x12ff12d00] activating connection: mach=false listener=false peer=false name=com.apple.audio.AudioConverterService.HighCapacity
default	15:38:11.649215+0500	Runner	        CHHapticEngine.mm:1511  -[CHHapticEngine initWithAudioSession:sessionIsShared:options:error:]: Creating engine 0x1482e17a0 with unshared audio session 0x0
default	15:38:11.651374+0500	Runner	[0x12ff12580] activating connection: mach=true listener=false peer=false name=com.apple.audio.AudioSession
default	15:38:12.434551+0500	Runner	    SessionCore_Create.mm:99    Created session 0x130cfc570 with ID: 0x1c32053
default	15:38:12.434562+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:12.434602+0500	Runner	[0x12ff12d00] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:12.435461+0500	Runner	[0x12ff12d00] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.routediscoverer.xpc
default	15:38:13.289657+0500	Runner	<<<< AVInputDeviceDiscoverySession >>>> -[AVInputDeviceDiscoverySession setFastDiscoveryEnabled:]: called (session=0x12ff4b980, setFastDiscoveryEnabled=NO)
default	15:38:13.289855+0500	Runner	<<<< AVInputDeviceDiscoverySession (FigRouteDiscoverer) >>>> -[AVFigRouteDiscovererInputDeviceDiscoverySessionImpl inputDeviceDiscoverySessionFastDiscoveryDidChange:]: Setting fastDiscoveryEnabled to NO (client: Runner) for session=0x12fff9500
default	15:38:13.290883+0500	Runner	<<<< AVOutputDeviceDiscoverySession >>>> -[AVOutputDeviceDiscoverySession setFastDiscoveryEnabled:]: called (session=0x130cfc9c0, setFastDiscoveryEnabled=NO)
default	15:38:13.290904+0500	Runner	<<<< AVOutputDeviceDiscoverySession (FigRouteDiscoverer) >>>> -[AVFigRouteDiscovererOutputDeviceDiscoverySessionImpl outputDeviceDiscoverySessionFastDiscoveryDidChange:]: Setting fastDiscoveryEnabled to NO (client: Runner) for session=0x130cfc9c0
default	15:38:13.291671+0500	Runner	[0x12ff11b80] activating connection: mach=true listener=false peer=false name=com.apple.audioanalyticsd
default	15:38:13.291687+0500	Runner	    AVAudioSession_iOS.mm:3447  enableNotifications: inValue = 0
default	15:38:13.293548+0500	Runner	[0x12ff11040] activating connection: mach=true listener=false peer=false name=com.apple.audio.hapticd
default	15:38:14.498529+0500	Runner	    HapticServerConfig.mm:40    -[HapticServerConfig initWithHapticPlayer:withOptions:error:]: Querying server for capabilities with 'FullGamut' Locality
default	15:38:14.498536+0500	Runner	    HapticServerConfig.mm:106   -[HapticServerConfig initWithHapticPlayer:withOptions:error:]: Querying server for UsageCategory of 'UIFeedback'
default	15:38:14.498609+0500	Runner	        AVHapticPlayer.mm:313   -[AVHapticPlayer queryServerCapabilities:reply:]: clientID: 0x1001d3b
default	15:38:14.498639+0500	Runner	[0x12ff12080] activating connection: mach=true listener=false peer=false name=com.apple.audio.AudioComponentRegistrar
default	15:38:14.498980+0500	Runner	        CHHapticEngine.mm:865   -[CHHapticEngine updateEngineBehavior]: Setting player's behavior to 0x0
default	15:38:14.498989+0500	Runner	        AVHapticPlayer.mm:323   -[AVHapticPlayer setBehavior:error:]: clientID: 0x1001d3b behavior: 0
default	15:38:14.499439+0500	Runner	        CHHapticEngine.mm:865   -[CHHapticEngine updateEngineBehavior]: Setting player's behavior to 0x4
default	15:38:14.499516+0500	Runner	        AVHapticPlayer.mm:323   -[AVHapticPlayer setBehavior:error:]: clientID: 0x1001d3b behavior: 4
default	15:38:14.500612+0500	Runner	cannot migrate AudioUnit assets for current process
default	15:38:14.503993+0500	Runner	        CHHapticEngine.mm:1281  -[CHHapticEngine startWithCompletionHandler:]: Called on engine 0x1482e17a0
default	15:38:14.504051+0500	Runner	        CHHapticEngine.mm:1231  -[CHHapticEngine doStartWithCompletionHandler:]: Starting underlying Haptic Player
default	15:38:14.504085+0500	Runner	        CHHapticEngine.mm:871   -[CHHapticEngine updateEngineBehaviorWithError:]: Setting player's behavior to 0x5
default	15:38:14.504096+0500	Runner	        AVHapticPlayer.mm:323   -[AVHapticPlayer setBehavior:error:]: clientID: 0x1001d3b behavior: 5
default	15:38:14.504918+0500	Runner	        AVHapticPlayer.mm:675   -[AVHapticPlayer startRunningWithCompletionHandler:]: start running: clientID: 0x1001d3b
default	15:38:14.504956+0500	Runner	        AVHapticClient.mm:363   -[AVHapticClient startRunning:]: Client 0x1001d3b starting
default	15:38:14.509418+0500	Runner	App is being debugged, do not track this hang
default	15:38:14.509424+0500	Runner	Hang detected: 2.08s (debugger attached, not reporting)
default	15:38:14.509448+0500	Runner	[0x12ff11680] activating connection: mach=true listener=false peer=false name=com.apple.audio.AudioSession
default	15:38:14.529438+0500	Runner	core haptics engine STARTED for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:14.529448+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Activating -> Running
default	15:38:14.534895+0500	Runner	    SessionCore_Create.mm:99    Created session 0x130cfc980 with ID: 0x1c32054
default	15:38:14.535880+0500	Runner	<<<< AVInputDeviceDiscoverySession >>>> -[AVInputDeviceDiscoverySession setFastDiscoveryEnabled:]: called (session=0x130cf8a20, setFastDiscoveryEnabled=NO)
default	15:38:14.535892+0500	Runner	<<<< AVInputDeviceDiscoverySession (FigRouteDiscoverer) >>>> -[AVFigRouteDiscovererInputDeviceDiscoverySessionImpl inputDeviceDiscoverySessionFastDiscoveryDidChange:]: Setting fastDiscoveryEnabled to NO (client: Runner) for session=0x12fff9bc0
default	15:38:14.535960+0500	Runner	<<<< AVOutputDeviceDiscoverySession >>>> -[AVOutputDeviceDiscoverySession setFastDiscoveryEnabled:]: called (session=0x130cfc8f0, setFastDiscoveryEnabled=NO)
default	15:38:14.535974+0500	Runner	<<<< AVOutputDeviceDiscoverySession (FigRouteDiscoverer) >>>> -[AVFigRouteDiscovererOutputDeviceDiscoverySessionImpl outputDeviceDiscoverySessionFastDiscoveryDidChange:]: Setting fastDiscoveryEnabled to NO (client: Runner) for session=0x130cfc8f0
default	15:38:14.543133+0500	Runner	[0x12ff13700] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.asset.xpc
default	15:38:14.543580+0500	Runner	[0x12ff112c0] activating connection: mach=false listener=false peer=false name=(anonymous)
default	15:38:14.544204+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> figProcessStateMonitor_createRemoteFromObjectID: Created monitor <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0>
default	15:38:14.544684+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.547218+0500	Runner	[0x12fe7e080] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.sandboxserver.xpc
default	15:38:14.547406+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.552139+0500	Runner	Initializing NSHTTPCookieStorage singleton
default	15:38:14.552180+0500	Runner	Initializing CFHTTPCookieStorage singleton
default	15:38:14.552191+0500	Runner	Creating default cookie storage with default identifier
default	15:38:14.554421+0500	Runner	[0x12fe7d540] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.customurlloader.xpc
default	15:38:14.554559+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.554611+0500	Runner	<<<< FigCustomURLHandling >>>> FigCustomURLLoaderCreate: newLoader: 0x10544cbd0
default	15:38:14.554645+0500	Runner	<<<< FigCustomURLHandling >>>> FigCustomURLHandlerCreate: newHandler: com.apple.avfoundation.customurl.cfurlconnection.0x105463680 options: {
    "CURLHOption_OKToLogURLs" = 0;
}
default	15:38:14.554696+0500	Runner	[0x12fe7f5c0] activating connection: mach=false listener=true peer=false name=(anonymous)
default	15:38:14.554724+0500	Runner	[0x12fe7f5c0] Connection returned listener port: 0x1e303
default	15:38:14.554769+0500	Runner	<<< FigOSTransactionsUtilities >>> FigOSTransactionCreateWithProcessName: [Fig Transaction] Added transaction weak reference holder <0x1506bd900>: 1768819094 FigCustomURLHandler  0:(null)
error	15:38:14.555260+0500	Runner	<<<< FigApplicationStateMonitor >>>> signalled err=-19431 at <>:474
default	15:38:14.555305+0500	Runner	<<<< FigCustomURLHandling >>>> curll_installHandler: 0x10544cbf0: handler: 0x105463680 priority: 100
error	15:38:14.555679+0500	Runner	<<<< FigApplicationStateMonitor >>>> signalled err=-19431 at <>:474
default	15:38:14.555691+0500	Runner	[0x148295800] activating connection: mach=false listener=false peer=true name=com.apple.xpc.anonymous.0x12fe7f5c0.peer[742].0x148295800
default	15:38:14.555918+0500	Runner	<<<< FigCustomURLHandling >>>> FigCustomURLHandlerCreate: newHandler: com.apple.avfoundation.authkeychain.0x105463800 options: {
    "CURLHOption_OKToLogURLs" = 0;
}
default	15:38:14.555928+0500	Runner	<<< FigOSTransactionsUtilities >>> FigOSTransactionCreateWithProcessName: [Fig Transaction] Added transaction weak reference holder <0x1506bda60>: 1768819094 FigCustomURLHandler  0:(null)
default	15:38:14.556034+0500	Runner	<<<< FigCustomURLHandling >>>> curll_installHandler: 0x10544cbf0: handler: 0x105463800 priority: 800
default	15:38:14.556551+0500	Runner	<<<< AVReadWriteDispatchQueue >>>> usesSerialQueue_block_invoke: Using read/write queue
default	15:38:14.559283+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke_2: currentItem KVO: P/YY will willChange AVPlayer.currentItem
default	15:38:14.559299+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY did willChange AVPlayer.currentItem
default	15:38:14.559370+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setCurrentItem:]: currentItem KVO: P/YY updating current item from (null) to I/SQI.01
default	15:38:14.559403+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:14.559434+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY will didChange AVPlayer.currentItem
default	15:38:14.559463+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY did didChange AVPlayer.currentItem
default	15:38:14.559493+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: called (self: 0x1490e5490, keys: (
    streaming
), keysForCollectionKeys: (null), handler: non-nil)
default	15:38:14.559520+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Calling FigAssetLoadValuesAsyncForProperties for properties (
    "assetProperty_AssetType"
)
default	15:38:14.559550+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Batch 0x12e5df2c0: asset batch ID = 1 (err=0, alreadyLoaded=0)
default	15:38:14.560517+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification: Received kFigAssetNotification_BatchPropertyLoadComplete (payload: {
    "assetPayload_BatchID" = 1;
})
default	15:38:14.560530+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification_block_invoke: Batch 0x12e5df2c0: Marking asset batch ID 1 as complete
default	15:38:14.560564+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader _invokeCompletionHandlerForLoadingBatches:]: Batch 0x12e5df2c0: dispatching completion handler
default	15:38:14.560698+0500	Runner	[0x12fe7cf00] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.visualcontext.xpc
default	15:38:14.560887+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.561019+0500	Runner	[0x12fe7c8c0] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.player.xpc
default	15:38:14.561187+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.561593+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: called (self: 0x1490e5490, keys: (
    tracks
), keysForCollectionKeys: (null), handler: non-nil)
default	15:38:14.561630+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Calling FigAssetLoadValuesAsyncForProperties for properties (
    "assetProperty_Tracks"
)
default	15:38:14.561662+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Batch 0x12e5de160: asset batch ID = 2 (err=0, alreadyLoaded=0)
default	15:38:14.561687+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Calling FigAssetLoadValuesAsyncForTrackProperties for properties (
    MediaCharacteristicArray
)
default	15:38:14.562093+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader loadValuesAsynchronouslyForKeys:keysForCollectionKeys:completionHandler:]: Batch 0x12e5de160: track batch ID = 3 (err=0, alreadyLoaded=0)
default	15:38:14.564455+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification: Received kFigAssetNotification_BatchPropertyLoadComplete (payload: {
    "assetPayload_BatchID" = 3;
})
default	15:38:14.564507+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification_block_invoke: Batch 0x12e5de160: Marking track batch ID 3 as complete
default	15:38:14.564594+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader _invokeCompletionHandlerForLoadingBatches:]: No completed batches
default	15:38:14.564624+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification: Received kFigAssetNotification_BatchPropertyLoadComplete (payload: {
    "assetPayload_BatchID" = 2;
})
default	15:38:14.564665+0500	Runner	<<<< AVAssetInspectorLoader >>>> handleFigAssetLoadingNotification_block_invoke: Batch 0x12e5de160: Marking asset batch ID 2 as complete
default	15:38:14.564697+0500	Runner	<<<< AVAssetInspectorLoader >>>> -[AVFigAssetInspectorLoader _invokeCompletionHandlerForLoadingBatches:]: Batch 0x12e5de160: dispatching completion handler
default	15:38:14.565587+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> FigVideoReceiverCreateWithVideoLayer: [0x1481e5c80|L/SU]: Created new VideoReceiver w/ layer <FigVideoLayer: 0x1506ee900>
default	15:38:14.566212+0500	Runner	[0x12fe7cb40] activating connection: mach=false listener=true peer=false name=(anonymous)
default	15:38:14.566227+0500	Runner	[0x12fe7cb40] Connection returned listener port: 0x17203
default	15:38:14.566340+0500	Runner	[0x12fe7cc80] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.videotarget.xpc
default	15:38:14.566477+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.566651+0500	Runner	[0x148295b00] activating connection: mach=false listener=false peer=true name=com.apple.xpc.anonymous.0x12fe7cb40.peer[742].0x148295b00
default	15:38:14.566765+0500	Runner	[0x12fe7ed00] activating connection: mach=false listener=true peer=false name=(anonymous)
default	15:38:14.566806+0500	Runner	[0x12fe7ed00] Connection returned listener port: 0x17503
default	15:38:14.567034+0500	Runner	[0x148295980] activating connection: mach=false listener=false peer=true name=com.apple.xpc.anonymous.0x12fe7ed00.peer[742].0x148295980
default	15:38:14.567082+0500	Runner	[0x148295b00] invalidated because the client process (pid 742) either cancelled the connection or exited
default	15:38:14.567189+0500	Runner	[0x12fe7ef80] activating connection: mach=false listener=false peer=false name=(anonymous)
default	15:38:14.575757+0500	Runner	generator <UIImpactFeedbackGenerator: 0x12ff92040> playing feedback <_UIDiscreteFeedback: 0x11e26fde0>
default	15:38:14.575805+0500	Runner	player dequeue needed - initial request for feedback <_UIDiscreteFeedback: 0x11e26fde0>
default	15:38:14.575818+0500	Runner	player dequeue finished for feedback <_UIDiscreteFeedback: 0x11e26fde0> with player <_UIFeedbackCoreHapticsPlayer: 0x1482e8030>
default	15:38:14.577132+0500	Runner	        AVHapticPlayer.mm:150   -[AVHapticPlayerChannel resetAtTime:error:]: sending reset event: clientID: 0x1001d3b time: 170305.610
default	15:38:14.577192+0500	Runner	        AVHapticPlayer.mm:91    -[AVHapticPlayerChannel sendEvents:atTime:error:]: sending event array: clientID: 0x1001d3b atTime: 170305.610
default	15:38:14.579233+0500	Runner	        AVHapticPlayer.mm:762   -[AVHapticPlayer finishWithCompletionHandler:]: finish with comp handler: clientID: 0x1001d3b
default	15:38:14.579282+0500	Runner	        AVHapticClient.mm:421   -[AVHapticClient finish:]: Client 0x1001d3b finishing
default	15:38:14.579294+0500	Runner	        AVHapticClient.mm:426   -[AVHapticClient finish:]_block_invoke: completionCallback set to 0x1482f5170
default	15:38:14.579310+0500	Runner	        AVHapticClient.mm:453   -[AVHapticClient finish:]: Client 0x1001d3b done with finish
default	15:38:14.580488+0500	Runner	deactivate generator with style: TurnOn; activationCount: 1 -> 0; styleActivationCount: 1 -> 0; <UIImpactFeedbackGenerator: 0x12ff92040>
default	15:38:14.580605+0500	Runner	deactivate engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 1 -> 0
default	15:38:14.580621+0500	Runner	_internal_deactivateEngineIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 0, suspended: 0
default	15:38:14.580636+0500	Runner	_internal_teardownUnderlyingPlayerIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:14.580662+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Running -> Deactivating
default	15:38:14.580674+0500	Runner	played feedback <_UIDiscreteFeedback: 0x11e26fde0> with engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> at time 170305.610445
default	15:38:14.580682+0500	Runner	        CHHapticEngine.mm:1440  -[CHHapticEngine notifyWhenPlayersFinished:]: Called on engine 0x1482e17a0 with finishedHandler 0x124d40a40
default	15:38:14.580693+0500	Runner	        AVHapticPlayer.mm:762   -[AVHapticPlayer finishWithCompletionHandler:]: finish with comp handler: clientID: 0x1001d3b
default	15:38:14.580750+0500	Runner	        AVHapticClient.mm:421   -[AVHapticClient finish:]: Client 0x1001d3b finishing
default	15:38:14.580775+0500	Runner	        AVHapticClient.mm:426   -[AVHapticClient finish:]_block_invoke: completionCallback set to 0x1482f5f20
default	15:38:14.580854+0500	Runner	        AVHapticClient.mm:453   -[AVHapticClient finish:]: Client 0x1001d3b done with finish
default	15:38:14.589420+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCPlayer_reevaluatePendingVideoTargetsAndUpdateServerPlayer: (0x1482ede00) setting 1 fullySetupVideoTargets on server player, 0 pendingVideoTargets, shouldWaitForVideoTargets: false
default	15:38:14.589474+0500	Runner	<<<< AVPlayerItem >>>> -[AVPlayerItem _updateItemIdentifierForCoordinatedPlayback]_block_invoke: <I/SQI.01|0x130cfd1b0> setting coordination identifier to (null)
default	15:38:14.594111+0500	Runner	[0x11e2652c0] activating connection: mach=true listener=false peer=false name=com.apple.coremedia.mediaplaybackd.figmetriceventtimeline.xpc
default	15:38:14.594121+0500	Runner	<<<< FigProcessStateMonitorRemote >>>> FigProcessStateMonitorCopyRemoteStateMonitor: monitorRemoteOut <FigProcessStateMonitorRemoteRef 0x12ffb8d90 <FigXPCRemoteClient 0x12ffb7e70 [0x1f34e64f0]> 742 OID: 02e6180000005301, serverDied: NO, enrolledInPurge: NO, lastPurgeID: 0> err 0
default	15:38:14.599327+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config (null) w/ pending config [DataChannelConfiguration <0x130cbf980|(null)>] activationID 3649 Resources: (
) Channels: []
default	15:38:14.599431+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x130cbf980|(null)>] activationID 3649 Resources: (
) Channels: [] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:14.599559+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Received empty config, clearing video layers
default	15:38:14.599920+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCItem_updateLayerSync: [0x1482ede00:0x124d39180] updating layerSync with configuration <LayerSynchronizerConfiguration 0x1506d54d0> layersNotSubjectToImageQueueTiming: (
), layersSubjectToImageQueueTiming: (
    "<FigVideoLayer: 0x1506ee900>"
)
default	15:38:14.600295+0500	Runner	<<<< LayerSync >>>> figlayersync_getLayerDisplayLatency: layer 0x1506ee900, context 0x1056d4c90, displayID 1: latency 0.000
default	15:38:14.600311+0500	Runner	<<<< LayerSync >>>> figlayersync_setLayerTiming: (layer 0x1506ee900) only set layer timeOffset: 0.000000 at hostTime 170305.636097
fault	15:38:14.602768+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 0C 46 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 38 34 02 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 10 33 02 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 4C 2D 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 08 2D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 40 A8 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C A5 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 98 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:14.609730+0500	Runner	        AVHapticClient.mm:1472  -[AVHapticClient clientCompletedWithError:]: Client-side (async) finish completion callback for client 0x1001d3b called from server
default	15:38:14.609743+0500	Runner	        AVHapticClient.mm:1477  -[AVHapticClient clientCompletedWithError:]_block_invoke: Async dispatch: preparing to call completionCallback for client 0x1001d3b
default	15:38:14.610356+0500	Runner	        AVHapticClient.mm:1479  -[AVHapticClient clientCompletedWithError:]_block_invoke: Calling completionCallback 0x1482f5f20 and then setting to nil
default	15:38:14.610528+0500	Runner	core haptics engine finished for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:14.610533+0500	Runner	stopping core haptics engine for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:14.610539+0500	Runner	        CHHapticEngine.mm:1418  -[CHHapticEngine stopWithCompletionHandler:]: Called on engine 0x1482e17a0
default	15:38:14.610790+0500	Runner	        CHHapticEngine.mm:1382  -[CHHapticEngine doStopWithCompletionHandler:]: Stopping underlying Haptic Player
default	15:38:14.610802+0500	Runner	_internal_deactivateEngineIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> tearedDown: 1
default	15:38:14.610811+0500	Runner	        AVHapticPlayer.mm:739   -[AVHapticPlayer stopRunningWithCompletionHandler:]: stop running: clientID: 0x1001d3b
default	15:38:14.610817+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Deactivating -> Inactive
default	15:38:14.610825+0500	Runner	        AVHapticClient.mm:398   -[AVHapticClient stopRunning:]: Client 0x1001d3b stopping
fault	15:38:14.610862+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 0C 46 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 38 34 02 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 10 33 02 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 4C 2D 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 46 24 4B 8E 51 94 32 24 B7 4E 1E B7 EE 84 BD B4 08 2D 00 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 40 A8 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C A5 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 98 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:14.614928+0500	Runner	        AVHapticClient.mm:1472  -[AVHapticClient clientCompletedWithError:]: Client-side (async) finish completion callback for client 0x1001d3b called from server
default	15:38:14.615148+0500	Runner	        AVHapticClient.mm:1477  -[AVHapticClient clientCompletedWithError:]_block_invoke: Async dispatch: preparing to call completionCallback for client 0x1001d3b
default	15:38:14.615279+0500	Runner	        AVHapticClient.mm:1484  -[AVHapticClient clientCompletedWithError:]_block_invoke: strongSelf.completionCallback is nil
default	15:38:14.621030+0500	Runner	core haptics engine STOPPED for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
fault	15:38:14.626415+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Interprocess communication on the main thread can cause non-deterministic delays.","antipattern trigger":"-[AVAudioSession category]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":0,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 A8 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C A5 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 98 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:14.628700+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Interprocess communication on the main thread can cause non-deterministic delays.","antipattern trigger":"-[AVAudioSession category]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":0,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 A8 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 3C A5 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 98 DD 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:14.641798+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD EC 93 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 58 93 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD AC 6D 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 40 61 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 94 B1 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD F8 AB 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD CC A9 06 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF FC B9 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 34 AE 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E4 E3 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:14.647525+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSBundle bundlePath]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 4D 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD EC 93 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 58 93 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 90 77 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD AC 6D 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 40 61 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 94 B1 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD F8 AB 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD CC A9 06 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF FC B9 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 34 AE 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E4 E3 37 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 24 67 4F 00 4C 4C 44 46 55 55 31 44 A1 C7 DF 04 4A C3 03 2A 78 F3 07 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:16.816865+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config [DataChannelConfiguration <0x130cbf980|(null)>] activationID 3649 Resources: (
) Channels: []  w/ pending config [DataChannelConfiguration <0x130cbd130|C/P/YY:I/SQI.01.V.1.1>] activationID 3652 Resources: (
) Channels: [[FirstFrameWasEnqueued = false, CAImageQueueSlotID = 2329912469, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5380 | retainCount 1 | identifier 0>], CAImageQueueID = 0]]
default	15:38:16.816936+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x130cbd130|C/P/YY:I/SQI.01.V.1.1>] activationID 3652 Resources: (
) Channels: [[FirstFrameWasEnqueued = false, CAImageQueueSlotID = 2329912469, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5380 | retainCount 1 | identifier 0>], CAImageQueueID = 0]] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:16.816963+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_attachVideoLayerToImageQueue: [0x1481e5c80|L/SU]: Slot assignment : Attaching videoLayer ((
    "<FigVideoLayer: 0x1506ee900>"
)) to imageQueue (2329912469)
default	15:38:16.817012+0500	Runner	<<<< FigVideoLayer >>>> -[FigVideoLayer setContentsSlotID:]: (0x1506ee900) Settings contents 0x130cfd3d0 for slotID: 2329912469
default	15:38:16.825714+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_firstFrameWasEnqueuedForImageQueueOrSlot: [0x1481e5c80|L/SU]: Called w/ imageQueueOrSlot 2329912469
default	15:38:16.883455+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCPlaybackItem_NotificationFilter: [0x124d39180] I/SQI.01 Received kFigPlaybackItemNotification_FirstVideoFrameEnqueued
error	15:38:16.883563+0500	Runner	<<<< PlayerRemoteXPC >>>> signalled err=-12860 at <>:1525
fault	15:38:17.387840+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Interprocess communication on the main thread can cause non-deterministic delays.","antipattern trigger":"-[AVURLAsset tracks]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":0,"show in console":"0"}'23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 18 36 03 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 50 7A 09 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD FC 11 07 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 34 B3 14 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 70 A4 14 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 94 15 09 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 81 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E0 7E 37 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 1C 6D 03 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 88 69 03 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 18 82 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 74 C4 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD BC B1 08 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD B4 20 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:17.393038+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Interprocess communication on the main thread can cause non-deterministic delays.","antipattern trigger":"-[AVURLAsset tracks]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":0,"show in console":"0"}'23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 18 36 03 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 50 7A 09 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD FC 11 07 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 34 B3 14 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 70 A4 14 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 94 15 09 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E8 81 37 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF E0 7E 37 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 1C 6D 03 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 88 69 03 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A 18 82 00 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD 74 C4 06 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD BC B1 08 00 23 BA 9F 10 C2 7B 30 AD AF 20 04 29 27 49 28 CD B4 20 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 3C 46 00 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC E0 E2 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 F4 03 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC 78 47 01 00 DF 97 19 48 76 F1 3C 29 B5 8B 4C B4 60 23 97 DC B4 46 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 B4 A2 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 3C DB 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:17.401721+0500	Runner	Pixel format registry initialized. Constant classes enabled.
default	15:38:17.402936+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:17.403093+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:17.407799+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:19.190505+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_firstFrameWasEnqueuedForImageQueueOrSlot: [0x1481e5c80|L/SU]: Called w/ imageQueueOrSlot 3274859862
default	15:38:19.190512+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCPlaybackItem_NotificationFilter: [0x124d39180] I/SQI.01 Received kFigPlaybackItemNotification_FirstVideoFrameEnqueued
error	15:38:19.190519+0500	Runner	<<<< PlayerRemoteXPC >>>> signalled err=-12860 at <>:1525
default	15:38:19.190660+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config [DataChannelConfiguration <0x130cbd130|C/P/YY:I/SQI.01.V.1.1>] activationID 3652 Resources: (
) Channels: [[FirstFrameWasEnqueued = true, CAImageQueueSlotID = 2329912469, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5380 | retainCount 1 | identifier 0>], CAImageQueueID = 0]]  w/ pending config [DataChannelConfiguration <0x130cbed00|C/P/YY:I/SQI.01.V.3.1>] activationID 3655 Resources: (
) Channels: [[FirstFrameWasEnqueued = true, CAImageQueueSlotID = 3274859862, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5aa0 | retainCount 1 | identifier 0>], CAImageQueueID = 0]]
default	15:38:19.190685+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x130cbed00|C/P/YY:I/SQI.01.V.3.1>] activationID 3655 Resources: (
) Channels: [[FirstFrameWasEnqueued = true, CAImageQueueSlotID = 3274859862, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5aa0 | retainCount 1 | identifier 0>], CAImageQueueID = 0]] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:19.190705+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_attachVideoLayerToImageQueue: [0x1481e5c80|L/SU]: Slot assignment : Attaching videoLayer ((
    "<FigVideoLayer: 0x1506ee900>"
)) to imageQueue (3274859862)
default	15:38:19.218324+0500	Runner	App is being debugged, do not track this hang
default	15:38:19.218416+0500	Runner	Hang detected: 1.81s (debugger attached, not reporting)
default	15:38:19.218895+0500	Runner	<<<< FigDeferredTransaction >>>> fdt_commitTransactionOnMainQueue: Warning: deferred transaction <FigDeferredTransaction 0x12cebf7a0, wants CATransaction, is committed
Changes:
<FigDeferredTransactionChange 0x1506d5890
unknown caller requesting to

0x19a823004>
<FigDeferredTransactionChange 0x1506d57a0
unknown caller requesting to

0x19a823710>

Post commit changes:
> was delayed by 1.785s before it began running
default	15:38:19.218935+0500	Runner	<<<< FigDeferredTransaction >>>> fdt_commitTransactionOnMainQueue: Warning: deferred transaction <FigDeferredTransaction 0x12cebf890, wants CATransaction, is committed
Changes:
<FigDeferredTransactionChange 0x1506d5440
unknown caller requesting to

0x19addf458>

Post commit changes:
> was delayed by 0.033s before it began running
default	15:38:19.218951+0500	Runner	<<<< LayerSync >>>> figlayersync_getLayerDisplayLatency: layer 0x1506ee900, context 0x1056d4c90, displayID 1: latency 0.000
default	15:38:19.218965+0500	Runner	<<<< LayerSync >>>> figlayersync_setLayerTiming: (layer 0x1506ee900) only set layer timeOffset: 0.000000 at hostTime 170310.256517
default	15:38:19.218988+0500	Runner	<<<< FigDeferredTransaction >>>> fdt_commitTransactionOnMainQueue: Warning: deferred transaction <FigDeferredTransaction 0x12cebd7c0, wants CATransaction, is committed
Changes:
<FigDeferredTransactionChange 0x1506d5a40
unknown caller requesting to

0x19a824e08>
<FigDeferredTransactionChange 0x1506d5bf0
unknown caller requesting to

0x19a8234bc>
<FigDeferredTransactionChange 0x1506d5bc0
unknown caller requesting to

0x19a798024>
<FigDeferredTransactionChange 0x1506d5b90
unknown caller requesting to

0x19a823354>
<FigDeferredTransactionChange 0x1506d5cb0
unknown caller requesting to

0x19a823710>

Post commit changes:
<FigDeferredTransactionChange 0x1506d5d10
unknown caller requesting to

0x19a84fe3c>
> was delayed by 0.031s before it began running
default	15:38:19.219044+0500	Runner	<<<< FigVideoLayer >>>> -[FigVideoLayer setContentsSlotID:]: (0x1506ee900) Settings contents 0x130cfd520 for slotID: 3274859862
default	15:38:19.219140+0500	Runner	<<<< FigDeferredTransaction >>>> fdt_commitTransactionOnMainQueue: Warning: deferred transaction <FigDeferredTransaction 0x12cebdc70, wants CATransaction, is committed
Changes:
<FigDeferredTransactionChange 0x1506d5d40
unknown caller requesting to

0x19a823004>
<FigDeferredTransactionChange 0x1506d5d70
unknown caller requesting to

0x19a823710>

Post commit changes:
> was delayed by 0.031s before it began running
default	15:38:19.223507+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:19.225373+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:19.225426+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:19.225606+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:19.225730+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:19.225774+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:19.225933+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:19.225948+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:19.225967+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:19.225976+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:19.225984+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:19.240027+0500	Runner	playing feedback without gesture recognizer (<nil: 0x0>) or at null point
default	15:38:19.240075+0500	Runner	activate generator with style: TurnOn; activationCount: 0 -> 1; styleActivationCount: 0 -> 1; <UIImpactFeedbackGenerator: 0x12ff909c0>
default	15:38:19.240159+0500	Runner	activate engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 0 -> 1
default	15:38:19.240185+0500	Runner	activating engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:19.240231+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Inactive -> Activating
default	15:38:19.240240+0500	Runner	starting core haptics engine for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:19.240287+0500	Runner	        CHHapticEngine.mm:1281  -[CHHapticEngine startWithCompletionHandler:]: Called on engine 0x1482e17a0
default	15:38:19.240519+0500	Runner	        CHHapticEngine.mm:1231  -[CHHapticEngine doStartWithCompletionHandler:]: Starting underlying Haptic Player
default	15:38:19.240542+0500	Runner	        CHHapticEngine.mm:871   -[CHHapticEngine updateEngineBehaviorWithError:]: Setting player's behavior to 0x5
default	15:38:19.240550+0500	Runner	        AVHapticPlayer.mm:323   -[AVHapticPlayer setBehavior:error:]: clientID: 0x1001d3b behavior: 5
default	15:38:19.240559+0500	Runner	        AVHapticPlayer.mm:675   -[AVHapticPlayer startRunningWithCompletionHandler:]: start running: clientID: 0x1001d3b
default	15:38:19.240665+0500	Runner	        AVHapticClient.mm:363   -[AVHapticClient startRunning:]: Client 0x1001d3b starting
default	15:38:19.265198+0500	Runner	core haptics engine STARTED for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:19.265233+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Activating -> Running
default	15:38:20.861903+0500	Runner	App is being debugged, do not track this hang
default	15:38:20.861963+0500	Runner	Hang detected: 1.62s (debugger attached, not reporting)
default	15:38:20.862246+0500	Runner	generator <UIImpactFeedbackGenerator: 0x12ff909c0> playing feedback <_UIDiscreteFeedback: 0x11e26f660>
default	15:38:20.862374+0500	Runner	player dequeue needed - initial request for feedback <_UIDiscreteFeedback: 0x11e26f660>
default	15:38:20.862385+0500	Runner	player dequeue finished for feedback <_UIDiscreteFeedback: 0x11e26f660> with player <_UIFeedbackCoreHapticsPlayer: 0x1482e8870>
default	15:38:20.862457+0500	Runner	deactivate generator with style: TurnOn; activationCount: 1 -> 0; styleActivationCount: 1 -> 0; <UIImpactFeedbackGenerator: 0x12ff909c0>
default	15:38:20.862983+0500	Runner	        AVHapticPlayer.mm:150   -[AVHapticPlayerChannel resetAtTime:error:]: sending reset event: clientID: 0x1001d3b time: 170311.900
default	15:38:20.863054+0500	Runner	        AVHapticPlayer.mm:91    -[AVHapticPlayerChannel sendEvents:atTime:error:]: sending event array: clientID: 0x1001d3b atTime: 170311.900
default	15:38:20.863090+0500	Runner	        AVHapticPlayer.mm:762   -[AVHapticPlayer finishWithCompletionHandler:]: finish with comp handler: clientID: 0x1001d3b
default	15:38:20.863128+0500	Runner	        AVHapticClient.mm:421   -[AVHapticClient finish:]: Client 0x1001d3b finishing
default	15:38:20.863154+0500	Runner	        AVHapticClient.mm:426   -[AVHapticClient finish:]_block_invoke: completionCallback set to 0x12ce24810
default	15:38:20.863257+0500	Runner	        AVHapticClient.mm:453   -[AVHapticClient finish:]: Client 0x1001d3b done with finish
default	15:38:20.863271+0500	Runner	deactivate engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 1 -> 0
default	15:38:20.863316+0500	Runner	_internal_deactivateEngineIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>, clientCount: 0, suspended: 0
default	15:38:20.863363+0500	Runner	_internal_teardownUnderlyingPlayerIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:20.863513+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Running -> Deactivating
default	15:38:20.863531+0500	Runner	        CHHapticEngine.mm:1440  -[CHHapticEngine notifyWhenPlayersFinished:]: Called on engine 0x1482e17a0 with finishedHandler 0x15074ca40
default	15:38:20.863538+0500	Runner	        AVHapticPlayer.mm:762   -[AVHapticPlayer finishWithCompletionHandler:]: finish with comp handler: clientID: 0x1001d3b
default	15:38:20.863552+0500	Runner	        AVHapticClient.mm:421   -[AVHapticClient finish:]: Client 0x1001d3b finishing
default	15:38:20.863558+0500	Runner	        AVHapticClient.mm:426   -[AVHapticClient finish:]_block_invoke: completionCallback set to 0x12dba8360
default	15:38:20.863564+0500	Runner	        AVHapticClient.mm:453   -[AVHapticClient finish:]: Client 0x1001d3b done with finish
default	15:38:20.864273+0500	Runner	played feedback <_UIDiscreteFeedback: 0x11e26f660> with engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> at time 170311.900148
default	15:38:20.874834+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> resuming, timeouts(15.0, 604800.0) qos(0x15) voucher((null)) activity(00000000-0000-0000-0000-000000000000)
default	15:38:20.875421+0500	Runner	[C1] event: client:connection_reused @56.868s
default	15:38:20.875451+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is false
default	15:38:20.875458+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:38:20.875499+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> now using Connection 1
default	15:38:20.875674+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> sent request, body S 17311
default	15:38:20.886210+0500	Runner	nw_path_libinfo_path_check [D5E874DC-0558-42CB-8396-E031F7D6C9C5 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:20.894341+0500	Runner	nw_path_libinfo_path_check [53578750-E698-4102-8ABC-86CF9C9C070C acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:20.897126+0500	Runner	        AVHapticClient.mm:1472  -[AVHapticClient clientCompletedWithError:]: Client-side (async) finish completion callback for client 0x1001d3b called from server
default	15:38:20.897150+0500	Runner	        AVHapticClient.mm:1477  -[AVHapticClient clientCompletedWithError:]_block_invoke: Async dispatch: preparing to call completionCallback for client 0x1001d3b
default	15:38:20.897188+0500	Runner	        AVHapticClient.mm:1479  -[AVHapticClient clientCompletedWithError:]_block_invoke: Calling completionCallback 0x12dba8360 and then setting to nil
default	15:38:20.897535+0500	Runner	core haptics engine finished for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:20.897555+0500	Runner	stopping core haptics engine for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:20.897617+0500	Runner	        CHHapticEngine.mm:1418  -[CHHapticEngine stopWithCompletionHandler:]: Called on engine 0x1482e17a0
default	15:38:20.897870+0500	Runner	        CHHapticEngine.mm:1382  -[CHHapticEngine doStopWithCompletionHandler:]: Stopping underlying Haptic Player
default	15:38:20.897887+0500	Runner	_internal_deactivateEngineIfPossible <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> tearedDown: 1
default	15:38:20.897922+0500	Runner	        AVHapticPlayer.mm:739   -[AVHapticPlayer stopRunningWithCompletionHandler:]: stop running: clientID: 0x1001d3b
default	15:38:20.897968+0500	Runner	engine <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00> state changed: Deactivating -> Inactive
default	15:38:20.898055+0500	Runner	        AVHapticClient.mm:398   -[AVHapticClient stopRunning:]: Client 0x1001d3b stopping
default	15:38:20.903311+0500	Runner	        AVHapticClient.mm:1472  -[AVHapticClient clientCompletedWithError:]: Client-side (async) finish completion callback for client 0x1001d3b called from server
default	15:38:20.903513+0500	Runner	        AVHapticClient.mm:1477  -[AVHapticClient clientCompletedWithError:]_block_invoke: Async dispatch: preparing to call completionCallback for client 0x1001d3b
default	15:38:20.903527+0500	Runner	        AVHapticClient.mm:1484  -[AVHapticClient clientCompletedWithError:]_block_invoke: strongSelf.completionCallback is nil
default	15:38:20.909455+0500	Runner	core haptics engine STOPPED for <_UIFeedbackCoreHapticsHapticsOnlyEngine: 0x12ff19d00>
default	15:38:20.994575+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> received response, status 200 content K
default	15:38:20.997489+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> done using Connection 1
default	15:38:20.997549+0500	Runner	[C1] event: client:connection_idle @56.990s
default	15:38:20.997591+0500	Runner	nw_protocol_tcp_notify [C1.1.1.1:3] nw_protocol_notification_type_connection_idle is true
default	15:38:20.997601+0500	Runner	nw_protocol_tcp_set_connection_idle [C1.1.1.1:3] os_nexus_flow_set_connection_idle returned 0
default	15:38:20.997790+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> response ended
default	15:38:20.997919+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> summary for task success {transaction_duration_ms=122, response_status=200, connection=1, reused=1, reused_after_ms=39812, request_start_ms=0, request_duration_ms=0, response_start_ms=119, response_duration_ms=3, request_bytes=17380, request_throughput_kbps=959171, response_bytes=95, response_throughput_kbps=234, cache_hit=false}
default	15:38:20.998012+0500	Runner	Task <AF21E3C5-83BD-4DB1-A08D-57B8695EAD82>.<7> finished successfully
default	15:38:21.057851+0500	Runner	[0x11e23e6c0] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:21.061059+0500	Runner	[0x11e23e6c0] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:21.568885+0500	Runner	flutter: CHIPS http_status=200
default	15:38:21.570120+0500	Runner	flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
default	15:38:21.570230+0500	Runner	flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:38:21.570300+0500	Runner	flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:38:23.691649+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.694130+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.694226+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.694286+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.722388+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.722409+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.722424+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.730745+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.730802+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.730844+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.739036+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.739079+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.739098+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.739147+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:23.739162+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.739192+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.739207+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.747406+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.747454+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.747611+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.755760+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.755899+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.755945+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.764059+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.764091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.764112+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.772396+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.772439+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.772478+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.781431+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.781481+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.781497+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.789052+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.789117+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.789136+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.797487+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.797580+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.797617+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.805774+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.805864+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.806072+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.814074+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.814091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.814100+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.823488+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.823755+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.823769+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.830739+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.830779+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.830801+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.839095+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.839140+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.839181+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.847368+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.847394+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.847414+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.855753+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.855798+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.855839+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.864084+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.864137+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.864181+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.872422+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.872464+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.872544+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.880734+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.880871+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.880883+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.889081+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.889127+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.889209+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.897403+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.897422+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.897433+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.905769+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.905922+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.905946+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.914254+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.914272+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.914288+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.922435+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.922488+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.922529+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.931221+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.931235+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.931242+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.939296+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.939681+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.939835+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.948095+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.948108+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.948127+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.955930+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.956007+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.957417+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.965846+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.967088+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.967201+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.972657+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.972692+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.973098+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.981461+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.981484+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.981513+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.989317+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.989489+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.989516+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.998306+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.998342+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.998399+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:23.998411+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:23.998490+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:23.998502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:25.055640+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:25.055649+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.055656+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:25.055664+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:25.055670+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.082194+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.083597+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:25.083642+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:25.106173+0500	Runner	Reloading input views for key-window scene responder: <FlutterTextInputView: 0x12ff14800; frame = (0 0; 1 1); > force:N
default	15:38:25.106270+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 1 force: 0, fromBecomeFirstResponder: 1 (automaticKeyboard: 1, reloadIdentifier: 2D0A47A4-FEA9-435E-B3F7-4012857D8926)
default	15:38:25.106352+0500	Runner	_inputViewsForResponder: <FlutterTextInputView: 0x12ff14800; frame = (0 0; 1 1); >, automaticKeyboard: 1, force: 0
default	15:38:25.106394+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:38:25.106420+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:38:25.106491+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 1 (automaticKeyboardEnabled: 1, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 0, requiresKBWhenFirstResponder: 1)
default	15:38:25.106507+0500	Runner	_inputViewsForResponder, useKeyboard 1 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 1)
default	15:38:25.107357+0500	Runner	_inputViewsForResponder, found assistantVC: <UISystemInputAssistantViewController: 0x105634a00; frame = {{0, 0}, {393, 44}}> (should suppress: 0, _dontNeed: 0)
default	15:38:25.107405+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:38:25.107434+0500	Runner	_inputViewsForResponder, useKeyboard ivs: <UIInputViewSet: 0x12ff91b00>
default	15:38:25.107475+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff91b00>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:25.107625+0500	Runner	currently observing: YES
default	15:38:25.107772+0500	Runner	currently observing: NO
default	15:38:25.107830+0500	Runner	-_teardownExistingDelegate:(nil) forSetDelegate:<FlutterTextInputView: 0x12ff14800> force:NO delayEndInputSession:YES
default	15:38:25.108916+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:38:25.114476+0500	Runner	[0x11e23fe80] activating connection: mach=true listener=false peer=false name=com.apple.TextInput
default	15:38:25.115258+0500	Runner	channel:CandidateBar signal:Reset uniqueStringId:(null) creationTimestamp:790511905.115155 timestamp:790511905.115183 payload:(null)
default	15:38:25.115822+0500	Runner	-[RTIInputSystemClient beginAllowingRemoteTextInput:]  Begin allowing remote text input: 0D2C3543-CE97-46BA-99A0-76738E76744B
default	15:38:25.115920+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = YES)
default	15:38:25.116801+0500	Runner	-[RTIInputSystemClient _beginSessionWithID:forServices:force:]  Begin text input session. sessionID = 0D2C3543-CE97-46BA-99A0-76738E76744B, options = <RTISessionOptions: 0x1507077c0; shouldResign = NO; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:38:25.122276+0500	Runner	Document state contextBeforeInput length is zero.
default	15:38:25.122282+0500	Runner	Cancelled smart reply generation due to nil ICH
default	15:38:25.122306+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:25.122389+0500	Runner	All generators are not complete.
default	15:38:25.122406+0500	Runner	All generators are not complete.
default	15:38:25.122436+0500	Runner	All generators are not complete.
default	15:38:25.126916+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.126998+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:25.127007+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.127029+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.133969+0500	Runner	TX setWindowContextID:0 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:25.133977+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91b00>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.134002+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.134252+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 352}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:38:25.135608+0500	Runner	All generators are not complete.
default	15:38:25.136069+0500	Runner	channel:LegacyTextInputActions signal:DidSessionBegin sessionID:0D2C3543-CE97-46BA-99A0-76738E76744B timestamp:790511905.135839 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511905.119127";
}
default	15:38:25.137731+0500	Runner	Change from input view set: (null)
default	15:38:25.137748+0500	Runner	Change to input view set: (null)
default	15:38:25.138417+0500	Runner	Change from input view set: (null)
default	15:38:25.138423+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff90600>; (empty)>
default	15:38:25.142733+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:25.143418+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:38:25.143532+0500	Runner	TX signalKeyboardChanged
default	15:38:25.143543+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x15076aa00>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfd6c0 -> <CAFenceHandle:0x1490e7cd0 name=12 fence=4c00000ffa usable=YES>>; position {{0, 500}, {393, 352}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfd6c0 -> <CAFenceHandle:0x1490e7cd0 name=12 fence=4c00000ffa usable=YES>>; position {{0, 500}, {393, 352}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:38:25.143644+0500	Runner	TX setWindowContextID:3045571768 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:25.143718+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:38:25.143749+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff92340>; keyboard = [uninitialized]; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:25.144011+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.144057+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.144095+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:38:25.144130+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90600>; (empty)>
default	15:38:25.144162+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:25.144226+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: -[_UIKBFeedbackGenerator activateWithCompletionBlock:]
default	15:38:25.144232+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: Nothing to activate. Keyboard feedback is disabled.
default	15:38:25.161089+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.161154+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.161360+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.161547+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.161763+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.161844+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.161973+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.162341+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.165862+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.166090+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.166484+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.166543+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.166870+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.166904+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.167351+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.167373+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.175293+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:38:25.175396+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.175463+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.175543+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.175573+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.175817+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.175880+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.175947+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.175983+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.176791+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 335}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:38:25.176810+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:38:25.176944+0500	Runner	TX signalKeyboardChanged
default	15:38:25.177691+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x15076a880>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfd9f0 -> <CAFenceHandle:0x1490e7f00 name=14 fence=4c00000ffa usable=YES>>; position {{0, 517}, {393, 335}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfd9f0 -> <CAFenceHandle:0x1490e7f00 name=14 fence=4c00000ffa usable=YES>>; position {{0, 517}, {393, 335}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:38:25.177776+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOffScreenDown> toPlacement: <UIInputViewSetPlacementOnScreen> update to: {{0, 517}, {393, 335}}
default	15:38:25.177939+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x150707ec0 State: onscreen with input view; is docked>; frame={{0, 517}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x1507c8940, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:38:25.177967+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 335} [previous size: {393, 0}]
default	15:38:25.178711+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff90cc0>; keyboard = [uninitialized]; usesKeyClicks = NO;  >
default	15:38:25.178724+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90cc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.178767+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.178797+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:38:25.179419+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90000>; (empty)>
default	15:38:25.179543+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff90cc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:38:25.179826+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 0}]
default	15:38:25.183861+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90cc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:25.184561+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:25.186645+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:38:25.186953+0500	Runner	Posted notification willShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:25.187093+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:38:25.197649+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:38:25.198223+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:25.210865+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:25.227972+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:25.228009+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - 1C7CAA17
default	15:38:25.228028+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x150705c80> to candidate receiver, for request token: 1C7CAA17
default	15:38:25.228045+0500	Runner	Performing delayed generation for token=1C7CAA17
default	15:38:25.228086+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. 1C7CAA17.
default	15:38:25.230176+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setRate:rateChangeReason:figPlayerSetRateHandler:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:25.233436+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer replaceCurrentItemWithPlayerItem:]: currentItem KVO: P/YY called with (null)
default	15:38:25.233457+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke_2: currentItem KVO: P/YY will willChange AVPlayer.currentItem
default	15:38:25.233521+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY did willChange AVPlayer.currentItem
default	15:38:25.233577+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _setCurrentItem:]: currentItem KVO: P/YY updating current item from I/SQI.01 to (null)
default	15:38:25.233603+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: P/YY setting timeControlStatus=0, reasonForWaitingToPlay=(null)
default	15:38:25.233617+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY will didChange AVPlayer.currentItem
default	15:38:25.233624+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer _runOnIvarAccessQueueOperationThatMayChangeCurrentItemWithPreflightBlock:modificationBlock:error:]_block_invoke: currentItem KVO: P/YY did didChange AVPlayer.currentItem
default	15:38:25.233671+0500	Runner	<<<< AVPlayerItem >>>> -[AVPlayerItem dealloc]: <I/SQI.01|0x130cfd1b0> currentItem KVO: called
default	15:38:25.233923+0500	Runner	<<<< AVPlayerItem >>>> -[AVPlayerItem dealloc]: <I/SQI.01|0x130cfd1b0> currentItem KVO
default	15:38:25.233966+0500	Runner	<<<< FigCustomURLHandling >>>> curll_invalidate: 0x10544cbd0 called
default	15:38:25.235182+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.235785+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:25.235917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cb9900>; contextId: 0xB587BCB8
default	15:38:25.236089+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.242115+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.244452+0500	Runner	<<<< AVPlayer >>>> -[AVPlayer dealloc]: AVPlayer [0x130cfd200] P/YY releasing figPlayer 0x1482d33a0
default	15:38:25.244846+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.256016+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config [DataChannelConfiguration <0x130cbed00|C/P/YY:I/SQI.01.V.3.1>] activationID 3655 Resources: (
) Channels: [[FirstFrameWasEnqueued = true, CAImageQueueSlotID = 3274859862, Settings = [PresentationSize = [Height = 640, Width = 360], TrackMatrix = [1, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0, 1], DisallowsDisplayCompositing = false, EdgeAntialiasingMask = 0], DescriptionTags = CMMutableTagCollection{
{category:'mdia' value:'vide' <OSType>}
{category:'vchn' value:1 <int64>}
}, SidebandVideoPropertiesArray = [<MTSidebandVideoProperties 0x12e6c5aa0 | retainCount 1 | identifier 0>], CAImageQueueID = 0]]  w/ pending config [DataChannelConfiguration <0x12feed540|(null)>] activationID 3658 Resources: (
) Channels: []
default	15:38:25.256072+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x12feed540|(null)>] activationID 3658 Resources: (
) Channels: [] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:25.256104+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Received empty config, clearing video layers
default	15:38:25.256303+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCItem_updateLayerSync: [0x1482ede00:0x124d39180] updating layerSync with empty configuration
default	15:38:25.256324+0500	Runner	<<<< PlayerRemoteXPC >>>> remoteXPCPlayer_Invalidate: [0x1482ede00] P/YY
default	15:38:25.261189+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config [DataChannelConfiguration <0x12feed540|(null)>] activationID 3658 Resources: (
) Channels: []  w/ pending config [DataChannelConfiguration <0x12feed130|(null)>] activationID 3661 Resources: (
) Channels: []
default	15:38:25.261262+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x12feed130|(null)>] activationID 3661 Resources: (
) Channels: [] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:25.261440+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Received empty config, clearing video layers
default	15:38:25.261631+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_activatePendingConfigurationIfReadyAndCopyNewlyActivatedConfig: [0x1481e5c80|L/SU]: Replacing active config [DataChannelConfiguration <0x12feed130|(null)>] activationID 3661 Resources: (
) Channels: []  w/ pending config [DataChannelConfiguration <0x12feed1d0|(null)>] activationID 6 Resources: (
) Channels: []
default	15:38:25.261702+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Applying configuration ([DataChannelConfiguration <0x12feed1d0|(null)>] activationID 6 Resources: (
) Channels: [] ) to videoLayers ((
    "<FigVideoLayer: 0x1506ee900>"
))
default	15:38:25.261797+0500	Runner	<<<< FigVideoReceiverForCALayer >>>> videoReceiverForCA_applyConfigurationToLayersAtHostTime: [0x1481e5c80|L/SU]: Received empty config, clearing video layers
default	15:38:25.274713+0500	Runner	[0x12fe7cb40] invalidated after the last release of the connection object
default	15:38:25.285547+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:25.345285+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:25.345336+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:25.345357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cb9900>; contextId: 0xB587BCB8
default	15:38:25.355983+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:26.283970+0500	Runner	App is being debugged, do not track this hang
default	15:38:26.284068+0500	Runner	Hang detected: 0.87s (debugger attached, not reporting)
default	15:38:26.285965+0500	Runner	TX setWindowContextID:3045571768 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:26.290271+0500	Runner	Posted notification didShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:26.656749+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.656761+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.656774+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.656887+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.665453+0500	Runner	Reloading input views for key-window scene responder: <(null): 0x0; > force:N
default	15:38:26.665523+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 0 force: 0, fromBecomeFirstResponder: 0 (automaticKeyboard: 0, reloadIdentifier: B4F058AF-DCC1-4507-8386-69387827A761)
default	15:38:26.665576+0500	Runner	_inputViewsForResponder: <(null): 0x0; >, automaticKeyboard: 0, force: 0
default	15:38:26.665648+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:38:26.665657+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:38:26.665740+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 0 (automaticKeyboardEnabled: 0, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 1, requiresKBWhenFirstResponder: 0)
default	15:38:26.665769+0500	Runner	_inputViewsForResponder, useKeyboard 0 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 0)
default	15:38:26.665935+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:38:26.665949+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff90b40>; (empty)>
default	15:38:26.665957+0500	Runner	currently observing: YES
default	15:38:26.665965+0500	Runner	currently observing: NO
default	15:38:26.665998+0500	Runner	-_teardownExistingDelegate:<FlutterTextInputView: 0x12ff14800> forSetDelegate:(nil) force:NO delayEndInputSession:NO
default	15:38:26.672003+0500	Runner	-[RTIInputSystemClient endRemoteTextInputSessionWithID:options:completion:]  Ending text input session. sessionID = 0D2C3543-CE97-46BA-99A0-76738E76744B, options = <RTISessionOptions: 0x150705980; shouldResign = YES; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:38:26.672014+0500	Runner	-[RTIInputSystemClient _endSessionWithID:forServices:options:completion:]  End input session: 0D2C3543-CE97-46BA-99A0-76738E76744B
default	15:38:26.673245+0500	Runner	-[RTIInputSystemClient endAllowingRemoteTextInput:completion:]  End allowing remote text input: 0D2C3543-CE97-46BA-99A0-76738E76744B
default	15:38:26.673722+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = NO)
default	15:38:26.673866+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:38:26.674412+0500	Runner	Requesting scene for autofill UI
default	15:38:26.674535+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff90b40>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.674587+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {0, 0}} visible: 0; notifyRemote: 1; isMinimized: NO
default	15:38:26.674813+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:N
default	15:38:26.674879+0500	Runner	TX signalKeyboardChanged
default	15:38:26.674897+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x15076aa00>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfdb50 -> <CAFenceHandle:0x1490e7410 name=16 fence=4c00000ffb usable=YES>>; position {{0, 0}, {0, 0}}; animated YES; on screen NO; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfdb50 -> <CAFenceHandle:0x1490e7410 name=16 fence=4c00000ffb usable=YES>>; position {{0, 0}, {0, 0}} (with IAV same); floating 0; on screen NO;  intersectable YES; snapshot YES>
default	15:38:26.675096+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:38:26.675116+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff92400>; (empty)>
default	15:38:26.675276+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.675817+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.675965+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.676023+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.676614+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.676681+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.676815+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.676863+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.679636+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92400>; (empty)> windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.679655+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:38:26.679713+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:26.679852+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.679888+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.680011+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.680022+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.680123+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.680134+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.680217+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.680223+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:26.680257+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOnScreen> toPlacement: <UIInputViewSetPlacementOffScreenDown> update to: {{0, 852}, {393, 335}}
default	15:38:26.680282+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x150705380 State: offscreen; is docked>; frame={{0, 852}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x1507c8880, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:38:26.680305+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 0} [previous size: {393, 335}]
default	15:38:26.680587+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff92700>; (empty)>
default	15:38:26.680624+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 0} [previous size={393, 335}]
default	15:38:26.680649+0500	Runner	Placeholder height changed from 335.0 to 0.0
default	15:38:26.680658+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92700>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:26.680697+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:38:26.680852+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:26.682662+0500	Runner	Posted notification willHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:26.682817+0500	Runner	-[RTIInputSystemClient remoteTextInputSessionWithID:textSuggestionsChanged:]  Text input session suggestions changed. sessionID = (null)
default	15:38:26.683442+0500	Runner	[0x11e23fe80] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:26.716841+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:26.723233+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.723258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.723275+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.739200+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:0D2C3543-CE97-46BA-99A0-76738E76744B timestamp:790511906.739062 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511905.119127";
}
default	15:38:26.739464+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:(null) timestamp:790511906.739356 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511906.670581";
}
default	15:38:26.739592+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.739603+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.739613+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.739690+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:26.739700+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.739706+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.739715+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.739968+0500	Runner	channel:LegacyTextInputActions signal:DidSessionEnd sessionID:0D2C3543-CE97-46BA-99A0-76738E76744B timestamp:790511906.739728 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511906.670581";
}
default	15:38:26.756344+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.756359+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.756367+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.773086+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.773116+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.773129+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.782167+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.782208+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.782459+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.790604+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:26.791167+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.791317+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.791454+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.798031+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.798089+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.798142+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.807431+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.807471+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.807487+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.823084+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.823098+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.823113+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.823178+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:26.823226+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:26.823239+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:26.823249+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:26.940254+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:27.071564+0500	Runner	TX setWindowContextID:3045571768 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:27.073534+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff90cc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:38:27.073543+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff92700>; (empty)>
default	15:38:27.073609+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff92700>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.075226+0500	Runner	-[UIDictationController setIgnoreFinalizePhrases:] Setting ignoreFinalizePhrases flag 1
default	15:38:27.075269+0500	Runner	Posted notification didHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:27.075603+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff92340>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:27.075649+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff92400>; (empty)>
default	15:38:27.182986+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:27.590094+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:27.591408+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:27.591439+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:27.591490+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:27.591789+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:27.606450+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:27.614770+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:27.699217+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:27.700542+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:27.700556+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:27.715596+0500	Runner	Reloading input views for key-window scene responder: <FlutterTextInputView: 0x12ff14000; frame = (0 0; 1 1); > force:N
default	15:38:27.715701+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 1 force: 0, fromBecomeFirstResponder: 1 (automaticKeyboard: 1, reloadIdentifier: 3E9B9C98-0BF9-45D3-9D08-1F36F97AB1E9)
default	15:38:27.715811+0500	Runner	_inputViewsForResponder: <FlutterTextInputView: 0x12ff14000; frame = (0 0; 1 1); >, automaticKeyboard: 1, force: 0
default	15:38:27.715846+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:38:27.715867+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:38:27.715930+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 1 (automaticKeyboardEnabled: 1, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 0, requiresKBWhenFirstResponder: 1)
default	15:38:27.715992+0500	Runner	_inputViewsForResponder, useKeyboard 1 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 1)
default	15:38:27.716767+0500	Runner	_inputViewsForResponder, found assistantVC: <UISystemInputAssistantViewController: 0x105634a00; frame = {{0, 0}, {393, 44}}> (should suppress: 0, _dontNeed: 0)
default	15:38:27.716795+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:38:27.716809+0500	Runner	_inputViewsForResponder, useKeyboard ivs: <UIInputViewSet: 0x12ff906c0>
default	15:38:27.716917+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x12ff906c0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:27.717020+0500	Runner	currently observing: YES
default	15:38:27.717227+0500	Runner	currently observing: NO
default	15:38:27.717304+0500	Runner	-_teardownExistingDelegate:(nil) forSetDelegate:<FlutterTextInputView: 0x12ff14000> force:NO delayEndInputSession:YES
default	15:38:27.718533+0500	Runner	-[RTIInputSystemClient remoteTextInputSessionWithID:textSuggestionsChanged:]  Text input session suggestions changed. sessionID = (null)
default	15:38:27.718775+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:38:27.726589+0500	Runner	[0x12fe7d900] activating connection: mach=true listener=false peer=false name=com.apple.TextInput
default	15:38:27.727622+0500	Runner	channel:CandidateBar signal:Reset uniqueStringId:(null) creationTimestamp:790511907.727449 timestamp:790511907.727497 payload:(null)
default	15:38:27.728308+0500	Runner	-[RTIInputSystemClient beginAllowingRemoteTextInput:]  Begin allowing remote text input: C13188AF-FB7E-4F39-AB3A-EB72297E84AB
default	15:38:27.728355+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = YES)
default	15:38:27.729532+0500	Runner	-[RTIInputSystemClient _beginSessionWithID:forServices:force:]  Begin text input session. sessionID = C13188AF-FB7E-4F39-AB3A-EB72297E84AB, options = <RTISessionOptions: 0x150707740; shouldResign = NO; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:38:27.737363+0500	Runner	Document state contextBeforeInput length is zero.
default	15:38:27.737391+0500	Runner	Cancelled smart reply generation due to nil ICH
default	15:38:27.737432+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:27.737524+0500	Runner	All generators are not complete.
default	15:38:27.737545+0500	Runner	All generators are not complete.
default	15:38:27.737725+0500	Runner	All generators are not complete.
default	15:38:27.739833+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:27.743438+0500	Runner	All generators are not complete.
default	15:38:27.744081+0500	Runner	TX setWindowContextID:0 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:27.744194+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff906c0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.744421+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.744647+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 352}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:38:27.745464+0500	Runner	channel:LegacyTextInputActions signal:DidSessionBegin sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511907.745263 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511907.732309";
}
default	15:38:27.745839+0500	Runner	Change from input view set: (null)
default	15:38:27.745848+0500	Runner	Change to input view set: (null)
default	15:38:27.746495+0500	Runner	Change from input view set: (null)
default	15:38:27.746526+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91d40>; (empty)>
default	15:38:27.750952+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:27.751614+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:38:27.751801+0500	Runner	TX signalKeyboardChanged
default	15:38:27.751878+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x15076b000>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfd750 -> <CAFenceHandle:0x10567ac30 name=19 fence=4c00000ffc usable=YES>>; position {{0, 500}, {393, 352}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfd750 -> <CAFenceHandle:0x10567ac30 name=19 fence=4c00000ffc usable=YES>>; position {{0, 500}, {393, 352}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:38:27.751897+0500	Runner	TX setWindowContextID:310078432 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:27.752284+0500	Runner	Requesting scene for autofill UI
default	15:38:27.752317+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:38:27.752451+0500	Runner	Setting input views: <<UIInputViewSet: 0x12ff91200>; keyboard = [uninitialized]; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:27.752646+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.753030+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.753063+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:38:27.766820+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff91d40>; (empty)>
default	15:38:27.766829+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:27.766849+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: -[_UIKBFeedbackGenerator activateWithCompletionBlock:]
default	15:38:27.766881+0500	Runner	<_UIKBFeedbackGenerator: 0x1056d2940>: Nothing to activate. Keyboard feedback is disabled.
default	15:38:27.768382+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.768403+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.768482+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.768558+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.768841+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.769011+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.769615+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.769807+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.772483+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.772543+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.772681+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.772743+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.772871+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.773016+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.773132+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.774477+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.776417+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:38:27.776467+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.776508+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.776623+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.776758+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.776858+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.776899+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.776998+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.777179+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.778331+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {393, 335}} visible: 1; notifyRemote: 1; isMinimized: NO
default	15:38:27.778367+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:Y
default	15:38:27.778587+0500	Runner	TX signalKeyboardChanged
default	15:38:27.778620+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x15076aa00>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfda50 -> <CAFenceHandle:0x105679b90 name=1b fence=4c00000ffc usable=YES>>; position {{0, 517}, {393, 335}}; animated YES; on screen YES; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfda50 -> <CAFenceHandle:0x105679b90 name=1b fence=4c00000ffc usable=YES>>; position {{0, 517}, {393, 335}} (with IAV same); floating 0; on screen YES;  intersectable YES; snapshot YES>
default	15:38:27.778891+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOffScreenDown> toPlacement: <UIInputViewSetPlacementOnScreen> update to: {{0, 517}, {393, 335}}
default	15:38:27.779033+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x105607740 State: onscreen with input view; is docked>; frame={{0, 517}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x12cebbe80, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:38:27.779078+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 335} [previous size: {393, 0}]
default	15:38:27.780282+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x12ff91bc0>; keyboard = [uninitialized]; usesKeyClicks = NO;  >
default	15:38:27.780296+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91bc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.780441+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.780478+0500	Runner	Moving from placement: <UIInputViewSetPlacementOffScreenDown> to placement: <UIInputViewSetPlacementOnScreen> (currentPlacement: <UIInputViewSetPlacementOffScreenDown>)
default	15:38:27.780544+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff92700>; (empty)>
default	15:38:27.780607+0500	Runner	Change to input view set: <<UIInputViewSet: 0x12ff91bc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:38:27.780908+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 0}]
default	15:38:27.780970+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91bc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  > windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:27.780992+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:27.785881+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOnScreen>
default	15:38:27.786104+0500	Runner	Posted notification willShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:27.786257+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:38:27.786494+0500	Runner	RX keyboardArbiterClientHandle:Y
default	15:38:27.797612+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:27.812608+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:27.842777+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:27.843540+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - 497176F9
default	15:38:27.843547+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x130cfac40> to candidate receiver, for request token: 497176F9
default	15:38:27.843631+0500	Runner	Performing delayed generation for token=497176F9
default	15:38:27.843940+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. 497176F9.
default	15:38:27.903356+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:28.176093+0500	Runner	TX setWindowContextID:310078432 windowState:Enabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:28.177512+0500	Runner	Posted notification didShow with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 852}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 852}, {393, 0}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:30.959981+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:30.960093+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:30.960248+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:30.962641+0500	Runner	touch down
default	15:38:30.966353+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 335}]
default	15:38:30.971605+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:30.990592+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:30.990612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:30.990655+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:30.990715+0500	Runner	touch drag
default	15:38:30.991401+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 335}]
default	15:38:30.998877+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:30.998933+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:30.998975+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:30.999002+0500	Runner	touch drag
default	15:38:31.007222+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.007258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.007277+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.007293+0500	Runner	touch drag
default	15:38:31.007347+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:31.007401+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.007416+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.007457+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.007550+0500	Runner	touch drag
default	15:38:31.015495+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.015538+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.015577+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.015604+0500	Runner	touch drag
default	15:38:31.023915+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.023957+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.023994+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.024024+0500	Runner	touch drag
default	15:38:31.032274+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.032325+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.032366+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.032397+0500	Runner	touch drag
default	15:38:31.040574+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.040612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.040640+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.040663+0500	Runner	touch drag
default	15:38:31.050631+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.050642+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.052980+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.053016+0500	Runner	touch drag
default	15:38:31.057431+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.060657+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.060687+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.060810+0500	Runner	touch drag
default	15:38:31.065742+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.066190+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.066236+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.066251+0500	Runner	touch drag
error	15:38:31.072494+0500	Runner	Could not find cached accumulator for token=F5660E79 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:31.074361+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.074388+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.074456+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.074465+0500	Runner	touch drag
default	15:38:31.082325+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.082401+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.082446+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.082474+0500	Runner	touch drag
default	15:38:31.094233+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.094288+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.094345+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.094369+0500	Runner	touch drag
default	15:38:31.103493+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.103518+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.103554+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.103559+0500	Runner	touch drag
default	15:38:31.107314+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.107336+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.108477+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.108504+0500	Runner	touch drag
default	15:38:31.116709+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.116728+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.116741+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.116751+0500	Runner	touch drag
default	15:38:31.127322+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.127336+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.127343+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.127469+0500	Runner	touch drag
default	15:38:31.134516+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.134541+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.134552+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.134625+0500	Runner	touch drag
default	15:38:31.142323+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.142342+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.142354+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.143229+0500	Runner	touch drag
default	15:38:31.149900+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.149974+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.149990+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.149996+0500	Runner	touch drag
default	15:38:31.157242+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.157608+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.157624+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.157639+0500	Runner	touch drag
default	15:38:31.169199+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.169209+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.169408+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.169471+0500	Runner	touch drag
default	15:38:31.177825+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.177834+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.177875+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.178177+0500	Runner	touch drag
default	15:38:31.182235+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.182332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.182374+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.182450+0500	Runner	touch drag
default	15:38:31.194194+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.194230+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.194257+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.194278+0500	Runner	touch drag
default	15:38:31.199065+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.199083+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.199110+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.199124+0500	Runner	touch drag
default	15:38:31.207154+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.207225+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.207243+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.207293+0500	Runner	touch drag
default	15:38:31.216016+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.216794+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.216836+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.216865+0500	Runner	touch drag
default	15:38:31.223920+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.223951+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.223974+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.223989+0500	Runner	touch drag
default	15:38:31.232291+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.232331+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.232352+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.232369+0500	Runner	touch drag
default	15:38:31.240624+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.240649+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.240704+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.240812+0500	Runner	touch drag
default	15:38:31.249011+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.249028+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.249041+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.249056+0500	Runner	touch drag
default	15:38:31.258586+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.258608+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.258647+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.258673+0500	Runner	touch drag
default	15:38:31.265759+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.267060+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.267215+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.267235+0500	Runner	touch drag
error	15:38:31.271547+0500	Runner	Could not find cached accumulator for token=8A8A6199 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:31.274059+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.274076+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.274089+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.274121+0500	Runner	touch drag
default	15:38:31.282224+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.282249+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.282269+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.282316+0500	Runner	touch drag
default	15:38:31.290625+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.290663+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.290678+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.290690+0500	Runner	touch drag
default	15:38:31.299019+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.299062+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.299082+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.299098+0500	Runner	touch drag
default	15:38:31.307297+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.307336+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.307354+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.307369+0500	Runner	touch drag
default	15:38:31.315639+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.315669+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.315694+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.315711+0500	Runner	touch drag
default	15:38:31.323985+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.324023+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.324039+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.324053+0500	Runner	touch drag
default	15:38:31.332279+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.332328+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.332348+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.332365+0500	Runner	touch drag
default	15:38:31.340624+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.340641+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.340655+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.340667+0500	Runner	touch drag
default	15:38:31.348978+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.349008+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.349030+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.349049+0500	Runner	touch drag
default	15:38:31.357223+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.357239+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.357280+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.357294+0500	Runner	touch drag
default	15:38:31.365619+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.365660+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.365680+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.365698+0500	Runner	touch drag
default	15:38:31.373963+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.373982+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.374005+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.374022+0500	Runner	touch drag
default	15:38:31.407675+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.407772+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.407792+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.407874+0500	Runner	touch drag
default	15:38:31.416363+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.416371+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.416412+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.416476+0500	Runner	touch drag
default	15:38:31.424184+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.424196+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.424312+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.424329+0500	Runner	touch drag
default	15:38:31.432648+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.432667+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.432674+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.432851+0500	Runner	touch drag
default	15:38:31.440748+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.440778+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.440818+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.440910+0500	Runner	touch drag
default	15:38:31.449441+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.449470+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.449539+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.449580+0500	Runner	touch drag
default	15:38:31.458369+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.458419+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.458431+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.458441+0500	Runner	touch drag
default	15:38:31.465686+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.465822+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.465862+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.465873+0500	Runner	touch drag
default	15:38:31.474049+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.474064+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.474081+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.474097+0500	Runner	touch drag
default	15:38:31.487643+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.487677+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.488060+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.489252+0500	Runner	touch drag
error	15:38:31.493272+0500	Runner	Could not find cached accumulator for token=2BE4AA71 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:31.494038+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.494082+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.494265+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.494421+0500	Runner	touch drag
default	15:38:31.499167+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.499198+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.499217+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.499450+0500	Runner	touch drag
default	15:38:31.507374+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.507415+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.507432+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.507452+0500	Runner	touch drag
default	15:38:31.515659+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.515701+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.515719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.515734+0500	Runner	touch drag
default	15:38:31.524041+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.524082+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.524102+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.524118+0500	Runner	touch drag
default	15:38:31.532480+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.532502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.532525+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.532541+0500	Runner	touch drag
default	15:38:31.540667+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.540713+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.540750+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.540776+0500	Runner	touch drag
default	15:38:31.549642+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.549659+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.549676+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.549683+0500	Runner	touch drag
default	15:38:31.557460+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.557648+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.557991+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.558021+0500	Runner	touch drag
default	15:38:31.566021+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.566135+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.566200+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.566251+0500	Runner	touch drag
default	15:38:31.574223+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.574254+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.574357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.574384+0500	Runner	touch drag
default	15:38:31.582967+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.583054+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.583070+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.583113+0500	Runner	touch drag
default	15:38:31.590756+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.590814+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.590862+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.590919+0500	Runner	touch drag
default	15:38:31.598992+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.616250+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.616295+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.617244+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.617260+0500	Runner	touch drag
default	15:38:31.624267+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.624319+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.624392+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.624414+0500	Runner	touch drag
default	15:38:31.633018+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.633055+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.633208+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.633254+0500	Runner	touch drag
default	15:38:31.640877+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.640911+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.640939+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.641073+0500	Runner	touch drag
default	15:38:31.649883+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.650074+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.650130+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.650149+0500	Runner	touch drag
default	15:38:31.658556+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.658612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.658626+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.658637+0500	Runner	touch drag
default	15:38:31.667157+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.668432+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.668519+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.668534+0500	Runner	touch drag
default	15:38:31.674063+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.674083+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.674103+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.674144+0500	Runner	touch drag
default	15:38:31.684899+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.684952+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.684973+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.684986+0500	Runner	touch drag
default	15:38:31.690777+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.690814+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.690844+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.690887+0500	Runner	touch drag
error	15:38:31.693027+0500	Runner	Could not find cached accumulator for token=FA14B04C type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:31.699281+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.699651+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.699721+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.699736+0500	Runner	touch drag
default	15:38:31.707370+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.707389+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.707416+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.707601+0500	Runner	touch drag
default	15:38:31.715728+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.715775+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.715817+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.715851+0500	Runner	touch drag
default	15:38:31.724037+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.724069+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.724095+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.724117+0500	Runner	touch drag
default	15:38:31.732386+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.732404+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.732424+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.732465+0500	Runner	touch drag
default	15:38:31.740709+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.740748+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.740787+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.740818+0500	Runner	touch drag
default	15:38:31.749147+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.749198+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.749305+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.749360+0500	Runner	touch drag
default	15:38:31.757466+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.757488+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.757551+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.757616+0500	Runner	touch drag
default	15:38:31.771148+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.771163+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.771213+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.771240+0500	Runner	touch drag
default	15:38:31.777606+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.777630+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.777650+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.778049+0500	Runner	touch drag
default	15:38:31.782429+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.782478+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.782516+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.782545+0500	Runner	touch drag
default	15:38:31.801800+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.801808+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.802012+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.802026+0500	Runner	touch drag
default	15:38:31.807354+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.807367+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.807393+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.807460+0500	Runner	touch drag
default	15:38:31.815732+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.815773+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.815794+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.815815+0500	Runner	touch drag
default	15:38:31.824182+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.824240+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.824265+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.824316+0500	Runner	touch drag
default	15:38:31.833133+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.833349+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.833370+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.833388+0500	Runner	touch drag
default	15:38:31.840887+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.840920+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.840940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.841023+0500	Runner	touch drag
default	15:38:31.849555+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.849692+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.849729+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.849745+0500	Runner	touch drag
default	15:38:31.857625+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.857717+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.857729+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.857789+0500	Runner	touch drag
default	15:38:31.866213+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.866235+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.866266+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.866323+0500	Runner	touch drag
default	15:38:31.874138+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.874236+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.874505+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.874516+0500	Runner	touch drag
default	15:38:31.882392+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.883666+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.883789+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.883819+0500	Runner	touch drag
default	15:38:31.898437+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.900403+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.900528+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.900538+0500	Runner	touch drag
default	15:38:31.900569+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.900590+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.900600+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.900644+0500	Runner	touch drag
error	15:38:31.900753+0500	Runner	Could not find cached accumulator for token=7B36D397 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:31.907516+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.907560+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.907579+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.907591+0500	Runner	touch drag
default	15:38:31.915781+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.915808+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.915832+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.915848+0500	Runner	touch drag
default	15:38:31.924156+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.924199+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.924217+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.924233+0500	Runner	touch drag
default	15:38:31.932465+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.932502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.932527+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.932545+0500	Runner	touch drag
default	15:38:31.940830+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.940871+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.940911+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.940943+0500	Runner	touch drag
default	15:38:31.949171+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.949228+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.949270+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.949301+0500	Runner	touch drag
default	15:38:31.957403+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.957427+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.957591+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.957622+0500	Runner	touch drag
default	15:38:31.966226+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.966238+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.966249+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.966255+0500	Runner	touch drag
default	15:38:31.974308+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.974390+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.974409+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.974451+0500	Runner	touch drag
default	15:38:31.983118+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.983297+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.983336+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.983390+0500	Runner	touch drag
default	15:38:31.990793+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.990931+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:31.990962+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:31.990998+0500	Runner	touch drag
default	15:38:31.999222+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:31.999357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.999527+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.999926+0500	Runner	touch drag
default	15:38:32.007497+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.007539+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.007579+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.007653+0500	Runner	touch drag
default	15:38:32.016551+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.016576+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.016598+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.016607+0500	Runner	touch drag
default	15:38:32.036102+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.036134+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.036150+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.036314+0500	Runner	touch drag
default	15:38:32.044745+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.044754+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.044764+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.044790+0500	Runner	touch drag
default	15:38:32.052267+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.052273+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.052282+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.052561+0500	Runner	touch drag
default	15:38:32.057876+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.057912+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.057924+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.057934+0500	Runner	touch drag
default	15:38:32.071405+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.071413+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.071429+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.071559+0500	Runner	touch drag
default	15:38:32.075119+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.075239+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.075257+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.075277+0500	Runner	touch drag
default	15:38:32.084161+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.084186+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.084197+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.084203+0500	Runner	touch drag
default	15:38:32.091025+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.091053+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.092700+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.092715+0500	Runner	touch drag
error	15:38:32.094820+0500	Runner	Could not find cached accumulator for token=A9C027F7 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:32.099761+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.099785+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.099792+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.099948+0500	Runner	touch drag
default	15:38:32.110146+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.110155+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.110162+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.110168+0500	Runner	touch drag
default	15:38:32.115819+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.115843+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.116590+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.116625+0500	Runner	touch drag
default	15:38:32.124041+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.124072+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.124109+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.124144+0500	Runner	touch drag
default	15:38:32.132482+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.132507+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.132874+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.132965+0500	Runner	touch drag
default	15:38:32.140844+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.140888+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.140906+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.140919+0500	Runner	touch drag
default	15:38:32.149271+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.149373+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.149391+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.149648+0500	Runner	touch drag
default	15:38:32.157653+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.157671+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.157685+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.157757+0500	Runner	touch drag
default	15:38:32.166194+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.166239+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.166294+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.166383+0500	Runner	touch drag
default	15:38:32.174215+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.174254+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.174269+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.174283+0500	Runner	touch drag
default	15:38:32.183039+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.183049+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.183059+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.183067+0500	Runner	touch drag
default	15:38:32.191041+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.191112+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.191144+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.191206+0500	Runner	touch drag
default	15:38:32.216219+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.216228+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.216244+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.216381+0500	Runner	touch drag
default	15:38:32.224374+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.224402+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.224447+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.224515+0500	Runner	touch drag
default	15:38:32.232738+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.232790+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.232805+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.232822+0500	Runner	touch drag
default	15:38:32.240967+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.241009+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.241034+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.241408+0500	Runner	touch drag
default	15:38:32.249779+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.249820+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.249866+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.249898+0500	Runner	touch drag
default	15:38:32.257832+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.257869+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.257935+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.258053+0500	Runner	touch drag
default	15:38:32.266566+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.266591+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.266613+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.266657+0500	Runner	touch drag
default	15:38:32.274450+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.274522+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.274699+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.274723+0500	Runner	touch drag
default	15:38:32.283622+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.283657+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.283675+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.283683+0500	Runner	touch drag
default	15:38:32.294574+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.294617+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.294636+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.294646+0500	Runner	touch drag
error	15:38:32.300030+0500	Runner	Could not find cached accumulator for token=8BC86789 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:32.300863+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.300873+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.300910+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.300971+0500	Runner	touch drag
default	15:38:32.307619+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.307694+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.308320+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.308337+0500	Runner	touch drag
default	15:38:32.316407+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.317348+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.317447+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.317630+0500	Runner	touch drag
default	15:38:32.324376+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.324454+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.324475+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.324543+0500	Runner	touch drag
default	15:38:32.332946+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.332962+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.332973+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.333024+0500	Runner	touch drag
default	15:38:32.341099+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.341438+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.341475+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.341492+0500	Runner	touch drag
default	15:38:32.349731+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.349852+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.349915+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.349976+0500	Runner	touch drag
default	15:38:32.357739+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.358108+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.358151+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.358164+0500	Runner	touch drag
default	15:38:32.365916+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.365993+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.366017+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.366096+0500	Runner	touch drag
default	15:38:32.374291+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.374339+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.374547+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.374558+0500	Runner	touch drag
default	15:38:32.382519+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.382563+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.382594+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.382642+0500	Runner	touch drag
default	15:38:32.391192+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.391226+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.393928+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.394036+0500	Runner	touch drag
default	15:38:32.402055+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.402064+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.402071+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.402079+0500	Runner	touch drag
default	15:38:32.407551+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.407594+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.407651+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.407687+0500	Runner	touch drag
default	15:38:32.416975+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.417051+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.417078+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.417088+0500	Runner	touch drag
default	15:38:32.468179+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.468228+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.468367+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.468396+0500	Runner	touch drag
default	15:38:32.474350+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.474435+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.474463+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.474495+0500	Runner	touch drag
default	15:38:32.483452+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.483464+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.483479+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.483561+0500	Runner	touch drag
default	15:38:32.491118+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.491194+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.491221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.491375+0500	Runner	touch drag
default	15:38:32.499635+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.499731+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.499748+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.499758+0500	Runner	touch drag
default	15:38:32.507637+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.507709+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.508842+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.508877+0500	Runner	touch drag
default	15:38:32.519028+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.519048+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.519058+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.519073+0500	Runner	touch drag
error	15:38:32.519666+0500	Runner	Could not find cached accumulator for token=3A6D7022 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:32.524271+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.524303+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.524332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.524349+0500	Runner	touch drag
default	15:38:32.533317+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.533353+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.533394+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.533940+0500	Runner	touch drag
default	15:38:32.540888+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.540909+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.540934+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.540950+0500	Runner	touch drag
default	15:38:32.549645+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.549657+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.549681+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.549690+0500	Runner	touch drag
default	15:38:32.557552+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.557581+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.557601+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.557615+0500	Runner	touch drag
default	15:38:32.566420+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.566587+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.566617+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.566668+0500	Runner	touch drag
default	15:38:32.574278+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.574318+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.574357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.574389+0500	Runner	touch drag
default	15:38:32.582987+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.583008+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.583091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.583138+0500	Runner	touch drag
default	15:38:32.591131+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.591186+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.591207+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.591257+0500	Runner	touch drag
default	15:38:32.599997+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.600008+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.600028+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.600084+0500	Runner	touch drag
default	15:38:32.607815+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.608103+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.608125+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.608134+0500	Runner	touch drag
default	15:38:32.617232+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.617248+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.617258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.617265+0500	Runner	touch drag
default	15:38:32.624284+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.624325+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.624362+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.624393+0500	Runner	touch drag
default	15:38:32.632623+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.632673+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.632711+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.632744+0500	Runner	touch drag
default	15:38:32.641216+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.641299+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.641330+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.641364+0500	Runner	touch drag
default	15:38:32.649770+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.649874+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.649946+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.649976+0500	Runner	touch drag
default	15:38:32.657759+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.657855+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.657886+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.657902+0500	Runner	touch drag
default	15:38:32.666312+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.666376+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.666398+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.666419+0500	Runner	touch drag
default	15:38:32.674463+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.674542+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.674565+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.674665+0500	Runner	touch drag
default	15:38:32.682734+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.719155+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.719170+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.719209+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.719218+0500	Runner	touch drag
error	15:38:32.719233+0500	Runner	Could not find cached accumulator for token=A6A88196 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:32.724493+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.724538+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.724581+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.724628+0500	Runner	touch drag
default	15:38:32.732989+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.733000+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.733022+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.733099+0500	Runner	touch drag
default	15:38:32.741065+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.741097+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.741120+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.741204+0500	Runner	touch drag
default	15:38:32.750165+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.750214+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.750252+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.750257+0500	Runner	touch drag
default	15:38:32.757720+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.757769+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.757824+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.757889+0500	Runner	touch drag
default	15:38:32.766197+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.766238+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.766256+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.766273+0500	Runner	touch drag
default	15:38:32.774333+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.774379+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.774416+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.774444+0500	Runner	touch drag
default	15:38:32.782664+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.782725+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.782767+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.782797+0500	Runner	touch drag
default	15:38:32.790997+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.791038+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.791073+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.791090+0500	Runner	touch drag
default	15:38:32.800048+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.800065+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.800076+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.800084+0500	Runner	touch drag
default	15:38:32.807666+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.807713+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.807754+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.807785+0500	Runner	touch drag
default	15:38:32.817447+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.817495+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.819111+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.819148+0500	Runner	touch drag
default	15:38:32.824388+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.824434+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.824475+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.824513+0500	Runner	touch drag
default	15:38:32.833467+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.833493+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.833504+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.833524+0500	Runner	touch drag
default	15:38:32.841252+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.841419+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.841531+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.841548+0500	Runner	touch drag
default	15:38:32.849953+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.850080+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.850100+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.850147+0500	Runner	touch drag
default	15:38:32.857728+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.857763+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.857789+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.857808+0500	Runner	touch drag
default	15:38:32.866558+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.866589+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.866605+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.866616+0500	Runner	touch drag
default	15:38:32.874342+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.874368+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.874420+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.874480+0500	Runner	touch drag
default	15:38:32.882672+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.882699+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.882761+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.882778+0500	Runner	touch drag
default	15:38:32.890990+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.891032+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.891060+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.891386+0500	Runner	touch drag
default	15:38:32.900101+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.900122+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.900182+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.900369+0500	Runner	touch drag
default	15:38:32.907819+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.908066+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.908094+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.908109+0500	Runner	touch drag
default	15:38:32.918649+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.918889+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.919028+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.919085+0500	Runner	touch drag
default	15:38:32.924357+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.924437+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.924470+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.924485+0500	Runner	touch drag
default	15:38:32.932693+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.932723+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.932745+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.932763+0500	Runner	touch drag
default	15:38:32.941442+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.941657+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.941828+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.941956+0500	Runner	touch drag
default	15:38:32.950918+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.950926+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.950932+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.951046+0500	Runner	touch drag
error	15:38:32.951073+0500	Runner	Could not find cached accumulator for token=005F82B0 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:32.957714+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.957760+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.957830+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.957854+0500	Runner	touch drag
default	15:38:32.966018+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.966048+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.966077+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.966116+0500	Runner	touch drag
default	15:38:32.974354+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.974395+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.974433+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.974462+0500	Runner	touch drag
default	15:38:32.982642+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.982695+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.982724+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.982744+0500	Runner	touch drag
default	15:38:32.991209+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:32.991255+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:32.991286+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:32.993803+0500	Runner	touch drag
default	15:38:33.004343+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.004367+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.004380+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.004424+0500	Runner	touch drag
default	15:38:33.010894+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.010905+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.011158+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.011166+0500	Runner	touch drag
default	15:38:33.018872+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.018884+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.018893+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.018903+0500	Runner	touch drag
default	15:38:33.024271+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.024291+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.024307+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.024321+0500	Runner	touch drag
default	15:38:33.032747+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.032812+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.032831+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.032859+0500	Runner	touch drag
default	15:38:33.044526+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.044540+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.044564+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.044579+0500	Runner	touch drag
default	15:38:33.053996+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.054018+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.054126+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.054143+0500	Runner	touch drag
default	15:38:33.058829+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.058959+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.058993+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.059123+0500	Runner	touch drag
default	15:38:33.068661+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.068677+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.068694+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.068710+0500	Runner	touch drag
default	15:38:33.076993+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.077006+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.077024+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.077044+0500	Runner	touch drag
default	15:38:33.083987+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.083996+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.084011+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.084587+0500	Runner	touch drag
default	15:38:33.091048+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.091150+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.091237+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.091722+0500	Runner	touch drag
default	15:38:33.099386+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.100112+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.100126+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.100145+0500	Runner	touch drag
default	15:38:33.107836+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.107860+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.109384+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.109436+0500	Runner	touch drag
default	15:38:33.116178+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.116192+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.116328+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.116884+0500	Runner	touch drag
default	15:38:33.124562+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.124583+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.124596+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.124816+0500	Runner	touch drag
default	15:38:33.133188+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.133202+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.133234+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.133275+0500	Runner	touch drag
default	15:38:33.141231+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.141247+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.141732+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.141841+0500	Runner	touch drag
error	15:38:33.146163+0500	Runner	Could not find cached accumulator for token=C296293A type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:33.149372+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.149415+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.149450+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.149466+0500	Runner	touch drag
default	15:38:33.157763+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.157800+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.157824+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.157839+0500	Runner	touch drag
default	15:38:33.166127+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.166843+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.166877+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.166887+0500	Runner	touch drag
default	15:38:33.174633+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.174669+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.174689+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.174793+0500	Runner	touch drag
default	15:38:33.183212+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.183371+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.183496+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.183562+0500	Runner	touch drag
default	15:38:33.191107+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.191148+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.191170+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.191188+0500	Runner	touch drag
default	15:38:33.199872+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.199914+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.200000+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.200071+0500	Runner	touch drag
default	15:38:33.207928+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.208374+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.208461+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.208473+0500	Runner	touch drag
default	15:38:33.216563+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.216592+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.216717+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.216737+0500	Runner	touch drag
default	15:38:33.224457+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.224497+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.224594+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.224610+0500	Runner	touch drag
default	15:38:33.232738+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.232758+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.232803+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.232817+0500	Runner	touch drag
default	15:38:33.241128+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.241159+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.241188+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.241204+0500	Runner	touch drag
default	15:38:33.249778+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.249818+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.249882+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.249979+0500	Runner	touch drag
default	15:38:33.258920+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.258941+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.258960+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.258970+0500	Runner	touch drag
default	15:38:33.266608+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.266752+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.266808+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.266881+0500	Runner	touch drag
default	15:38:33.277224+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.277230+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.277236+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.277250+0500	Runner	touch drag
default	15:38:33.282718+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.282753+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.282872+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.283711+0500	Runner	touch drag
default	15:38:33.291086+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.291150+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.291182+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.291198+0500	Runner	touch drag
default	15:38:33.299407+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.299473+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.299513+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.299542+0500	Runner	touch drag
default	15:38:33.313831+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.313879+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.313885+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.314095+0500	Runner	touch drag
default	15:38:33.316507+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.316534+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.318567+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.318608+0500	Runner	touch drag
default	15:38:33.324357+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.324377+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.324392+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.324439+0500	Runner	touch drag
default	15:38:33.332691+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.332711+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.332753+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.332767+0500	Runner	touch drag
default	15:38:33.340996+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.341015+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.341074+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.341109+0500	Runner	touch drag
default	15:38:33.351325+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.351334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.351341+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.351347+0500	Runner	touch drag
default	15:38:33.358841+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.358851+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.358860+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.358866+0500	Runner	touch drag
error	15:38:33.360455+0500	Runner	Could not find cached accumulator for token=F174BD5B type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:33.366099+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.366137+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.366158+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.366194+0500	Runner	touch drag
default	15:38:33.374423+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.374555+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.374592+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.374619+0500	Runner	touch drag
default	15:38:33.374808+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:33.374818+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:33.374825+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:33.374923+0500	Runner	touch up
error	15:38:33.387203+0500	Runner	Could not find cached accumulator for token=2CE0CCE3 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:33.415694+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511913.415459 payload:{
    Class = IATextInputActionsSessionBeganAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 0;
    textInputActionsType = 0;
    timestamp = "790511907.732309";
}
default	15:38:34.143151+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:34.143171+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:34.143209+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:34.143539+0500	Runner	touch down
default	15:38:34.144916+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:34.219126+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:34.219135+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:34.219150+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:34.219165+0500	Runner	touch up
default	15:38:35.529459+0500	Runner	registering darwin observer for name: com.apple.gms.availability.notification
default	15:38:35.529486+0500	Runner	registering darwin observer for name: com.apple.os-eligibility-domain.change.greymatter
default	15:38:35.529501+0500	Runner	registering darwin observer for name: com.apple.language.changed
default	15:38:35.529531+0500	Runner	isAvailable value changed: isMDMAllowed = true, gmAvailable (current) = false
default	15:38:35.530304+0500	Runner	Keyboard receives keyEvent type: 4; subtype: 0
default	15:38:35.533555+0500	Runner	Keyboard adds a string
default	15:38:35.535012+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:35.535435+0500	Runner	App is being debugged, do not track this hang
default	15:38:35.535443+0500	Runner	Hang detected: 1.30s (debugger attached, not reporting)
default	15:38:35.535525+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:35.535886+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.535892+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.535901+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.535979+0500	Runner	touch up
default	15:38:35.535988+0500	Runner	touch down
default	15:38:35.536171+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.536179+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.536190+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.536212+0500	Runner	touch drag
default	15:38:35.536283+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:35.536290+0500	Runner	Keyboard receives output from kbd
default	15:38:35.536298+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.536304+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.536462+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.536474+0500	Runner	touch drag
default	15:38:35.536761+0500	Runner	Keyboard inserts text
default	15:38:35.541654+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.541661+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.541702+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.541712+0500	Runner	touch up
default	15:38:35.542256+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.542268+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.542294+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.542315+0500	Runner	touch up
default	15:38:35.543586+0500	Runner	touch down
default	15:38:35.544228+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.544240+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.544266+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.544285+0500	Runner	touch drag
default	15:38:35.544302+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:35.545488+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.545592+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.550751+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.550823+0500	Runner	touch drag
default	15:38:35.554055+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.555048+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.555084+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.555151+0500	Runner	touch drag
error	15:38:35.602073+0500	Runner	Could not find cached accumulator for token=9DAF2200 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
error	15:38:35.610563+0500	Runner	Could not find cached accumulator for token=94E158D3 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:35.610717+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.610738+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.610745+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.610846+0500	Runner	touch drag
default	15:38:35.612571+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.612586+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.612600+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.612612+0500	Runner	touch drag
default	15:38:35.619726+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.619843+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.619854+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.619941+0500	Runner	touch drag
default	15:38:35.622623+0500	Runner	[0x12ff66940] activating connection: mach=true listener=false peer=false name=com.apple.TextInput.image-cache-server
default	15:38:35.625214+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.625221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.625228+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.625499+0500	Runner	touch drag
default	15:38:35.635112+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.635118+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.635127+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.635133+0500	Runner	touch drag
default	15:38:35.647290+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.647376+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.647382+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.647388+0500	Runner	touch drag
default	15:38:35.647398+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:35.647404+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:35.647411+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:35.647416+0500	Runner	touch up
error	15:38:35.654871+0500	Runner	Could not find cached accumulator for token=CE39FB4E type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
error	15:38:35.675081+0500	Runner	Could not find cached accumulator for token=4E0C6126 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:35.704504+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511915.704265 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 15;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 15;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 2;
    timestamp = "790511913.390502";
    withAlternativesCount = 0;
}
default	15:38:35.706371+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511915.706027 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 1;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 1;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 1;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 1;
    timestamp = "790511915.5176671";
    withAlternativesCount = 0;
}
fault	15:38:35.707237+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause hangs.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":1,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 94 5E 5C 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 46 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 0A 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 8C 52 95 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 09 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC 51 95 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 98 00 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E8 00 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 C6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 BD 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A0 A4 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 AE 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 A3 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C A3 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C B5 AC 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D8 E3 12 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 C7 12 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 98 94 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C 98 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 48 62 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 D6 30 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 56 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C 97 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A0 91 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C8 A6 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 52 45 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 67 45 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 91 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 DD 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 28 CE 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 FC 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E4 DE 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 D3 07 00 50 70 CB AD D0 F6 30 40 B5 81 F3 A5 E7 69 A0 F3 60 15 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 10 8F 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 84 8E 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 CC 6A 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 D8 D6 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
fault	15:38:35.719758+0500	Runner	__delegate_identifier__:Performance Diagnostics__:::____message__:{"message":"Performing I/O on the main thread can cause slow launches.","antipattern trigger":"-[NSData initWithContentsOfFile:options:error:]","message type":"suppressable","issue type":4,"category type":17,"subcategory type":3,"show in console":"0"}'B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 54 47 00 00 DF 78 2A C5 CC 02 35 8C A2 F7 14 97 03 F5 F4 4A C4 6C 92 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 94 5E 5C 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 64 46 42 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F4 0A 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 8C 52 95 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 30 09 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC 51 95 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 98 00 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E8 00 88 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 04 C6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 BD 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A0 A4 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 AE 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 A3 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 CC D6 44 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 9C A3 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C B5 AC 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D8 E3 12 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 90 C7 12 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 98 94 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C 98 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 48 62 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 B0 D6 30 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 40 56 22 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 3C 97 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 A0 91 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 C8 A6 21 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 D4 52 45 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 34 67 45 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 70 91 43 01 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 38 DD 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 28 CE 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 50 FC 06 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 E4 DE 07 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 74 D3 07 00 50 70 CB AD D0 F6 30 40 B5 81 F3 A5 E7 69 A0 F3 60 15 00 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 10 8F 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 84 8E 06 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 CC 6A 04 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 D8 D6 01 00 0B E5 4D BE 1A DC 35 88 BF FA E7 C9 9E 8D 82 08 6C CA 01 00 82 38 A6 C3 0D 27 3A 39 A3 BF 9A 27 19 D3 84 0C 98 14 00 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 F8 DD 09 00 65 19 DA FB 3D 75 33 74 92 76 10 E7 CE 4F 4D C5 54 6E 04 00 B7 83 EA 6C 0E B8 3A F9 83 15 B2 3D 71 6F 70 EF 60 40 00 00 A4 04 0D 49 94 46 38 E5 84 2B EB 8F 9C 97 1C 22 28 4E 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
default	15:38:35.799653+0500	Runner	[0x12ff66940] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:36.470706+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:36.470725+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:36.471096+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:36.471514+0500	Runner	touch down
default	15:38:36.473892+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:36.483880+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:36.491946+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:36.541992+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:36.542030+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:36.542045+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:36.542146+0500	Runner	touch up
default	15:38:36.543545+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:36.546602+0500	Runner	Keyboard receives output from kbd
default	15:38:36.562594+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:36.562773+0500	Runner	All generators are not complete.
default	15:38:36.564239+0500	Runner	All generators are not complete.
default	15:38:36.564274+0500	Runner	All generators are not complete.
default	15:38:36.564289+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:36.567914+0500	Runner	All generators are not complete.
default	15:38:36.567981+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:36.569179+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - D8453962
default	15:38:36.569263+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x1470a9cc0> to candidate receiver, for request token: D8453962
default	15:38:36.570585+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. D8453962.
default	15:38:36.589359+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511916.588736 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 4;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 4;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 2;
    timestamp = "790511915.668615";
    withAlternativesCount = 0;
}
default	15:38:37.085336+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.085344+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.085350+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.085690+0500	Runner	touch down
default	15:38:37.091995+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.155471+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.155523+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.155559+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.155891+0500	Runner	touch drag
default	15:38:37.159682+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.159703+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.159729+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.159790+0500	Runner	touch drag
default	15:38:37.162910+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.162945+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.162971+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.162983+0500	Runner	touch drag
default	15:38:37.163028+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:37.163053+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.163171+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.163180+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.163187+0500	Runner	touch drag
default	15:38:37.168885+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.168898+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.168916+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.168987+0500	Runner	touch drag
default	15:38:37.176090+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.176131+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.176156+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.176182+0500	Runner	touch drag
default	15:38:37.190135+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.190156+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.190167+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.190187+0500	Runner	touch drag
default	15:38:37.198623+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.198631+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.198751+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.201169+0500	Runner	touch drag
default	15:38:37.201464+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.201473+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.204365+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.204376+0500	Runner	touch drag
error	15:38:37.204551+0500	Runner	Could not find cached accumulator for token=1D34C808 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:37.210933+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.210953+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.210968+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.210973+0500	Runner	touch drag
default	15:38:37.220509+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.220515+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.220523+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.220638+0500	Runner	touch drag
default	15:38:37.225205+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.225229+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.225267+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.225322+0500	Runner	touch drag
default	15:38:37.234025+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.234078+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.234114+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.234244+0500	Runner	touch drag
default	15:38:37.241904+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.241919+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.241947+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.241966+0500	Runner	touch drag
default	15:38:37.250909+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.250925+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.250953+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.250958+0500	Runner	touch drag
default	15:38:37.258671+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.258702+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.258733+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.258752+0500	Runner	touch drag
default	15:38:37.267524+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.267540+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.268774+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.268793+0500	Runner	touch drag
default	15:38:37.275314+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.275357+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.275378+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.275434+0500	Runner	touch drag
default	15:38:37.284213+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.284230+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.284415+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.284441+0500	Runner	touch drag
default	15:38:37.292066+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.292103+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.292145+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.292267+0500	Runner	touch drag
default	15:38:37.300652+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.300683+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.300690+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.300697+0500	Runner	touch drag
default	15:38:37.308882+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.308918+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.308936+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.308967+0500	Runner	touch drag
default	15:38:37.309192+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.309221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.309250+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.309367+0500	Runner	touch up
error	15:38:37.331291+0500	Runner	Could not find cached accumulator for token=1AA493A1 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:37.354298+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511917.354132 payload:{
    Class = IATextInputActionsSessionDeletionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 1;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 1;
    largestSingleInsertionLength = 0;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 4;
    source = 4;
    textInputActionsType = 1;
    timestamp = "790511916.5502959";
}
default	15:38:37.520966+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.520983+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.520999+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.521096+0500	Runner	touch down
default	15:38:37.524296+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.558799+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.559180+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.559205+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.559212+0500	Runner	touch drag
default	15:38:37.567439+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.567450+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.567490+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.567512+0500	Runner	touch drag
default	15:38:37.575352+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.575386+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.575421+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.575488+0500	Runner	touch drag
default	15:38:37.587251+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.587359+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.587393+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.587404+0500	Runner	touch drag
default	15:38:37.592120+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.592142+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.592191+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.592247+0500	Runner	touch drag
default	15:38:37.592449+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:37.592608+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.592621+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.592730+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.592745+0500	Runner	touch drag
default	15:38:37.601044+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.601053+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.601070+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.601109+0500	Runner	touch drag
default	15:38:37.609528+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.609745+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.609760+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.609781+0500	Runner	touch drag
default	15:38:37.619520+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.619546+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.619559+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.619566+0500	Runner	touch drag
default	15:38:37.629743+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.629755+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.629764+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.630109+0500	Runner	touch drag
default	15:38:37.634346+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.634533+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.634558+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.635379+0500	Runner	touch drag
default	15:38:37.642807+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.642865+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.642908+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.642918+0500	Runner	touch drag
default	15:38:37.650752+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.650769+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.651384+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.651631+0500	Runner	touch drag
default	15:38:37.658845+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.658905+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.659408+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.659634+0500	Runner	touch drag
error	15:38:37.659646+0500	Runner	Could not find cached accumulator for token=93AFB51D type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:37.666995+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.667081+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.667090+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.667098+0500	Runner	touch drag
default	15:38:37.675250+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.675268+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.675286+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.675338+0500	Runner	touch drag
default	15:38:37.683720+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.683760+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.683789+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.683836+0500	Runner	touch drag
default	15:38:37.691981+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.692004+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.692023+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.692039+0500	Runner	touch drag
default	15:38:37.700309+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.700517+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.700622+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.700794+0500	Runner	touch drag
default	15:38:37.708637+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.708674+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.708705+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.708729+0500	Runner	touch drag
default	15:38:37.718319+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.718334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.718350+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.718440+0500	Runner	touch drag
default	15:38:37.725326+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.725452+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.725511+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.725567+0500	Runner	touch drag
default	15:38:37.734061+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.734091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.734119+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.734157+0500	Runner	touch drag
default	15:38:37.742249+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.742516+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.742599+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.742703+0500	Runner	touch drag
default	15:38:37.750735+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.750778+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.750883+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.750904+0500	Runner	touch drag
default	15:38:37.758898+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.759090+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.759111+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.759124+0500	Runner	touch drag
default	15:38:37.767205+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.769972+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.770694+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.770716+0500	Runner	touch drag
default	15:38:37.775387+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.775437+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.775476+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.775506+0500	Runner	touch drag
default	15:38:37.783994+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.784027+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.784123+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.784169+0500	Runner	touch drag
default	15:38:37.792027+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.792056+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.792157+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.792170+0500	Runner	touch drag
default	15:38:37.800709+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.800760+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.800791+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.800832+0500	Runner	touch drag
default	15:38:37.809672+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.809757+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.809819+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.809834+0500	Runner	touch drag
default	15:38:37.821611+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.821659+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.821696+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.821711+0500	Runner	touch drag
default	15:38:37.825412+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.825438+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.825467+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.825489+0500	Runner	touch drag
default	15:38:37.834152+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.834162+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.834201+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.834208+0500	Runner	touch drag
default	15:38:37.842143+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.842221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.842247+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.842259+0500	Runner	touch drag
default	15:38:37.851367+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.851946+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.851972+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.851979+0500	Runner	touch drag
error	15:38:37.856990+0500	Runner	Could not find cached accumulator for token=D8B48CFF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:37.858644+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.858691+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.858748+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.858773+0500	Runner	touch drag
default	15:38:37.867038+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.867079+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.867110+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.867142+0500	Runner	touch drag
default	15:38:37.875375+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.901001+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.901011+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.901021+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.901027+0500	Runner	touch drag
default	15:38:37.909055+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.909077+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.909173+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.909198+0500	Runner	touch drag
default	15:38:37.918948+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.919097+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.919116+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.919126+0500	Runner	touch drag
default	15:38:37.925657+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.925751+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.925807+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.925851+0500	Runner	touch drag
default	15:38:37.934185+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.934200+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.934315+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.934325+0500	Runner	touch drag
default	15:38:37.942466+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.942507+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.942543+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.942584+0500	Runner	touch drag
default	15:38:37.950820+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.950836+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.950850+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.950865+0500	Runner	touch drag
default	15:38:37.958749+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.958797+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.958828+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.958852+0500	Runner	touch drag
default	15:38:37.967053+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.967087+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.967137+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.967550+0500	Runner	touch drag
default	15:38:37.975414+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.975461+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.975500+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.975532+0500	Runner	touch drag
default	15:38:37.983762+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.983808+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.983849+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.983880+0500	Runner	touch drag
default	15:38:37.992103+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:37.992156+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:37.992197+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:37.992229+0500	Runner	touch drag
default	15:38:38.000812+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.001009+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.001039+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.001069+0500	Runner	touch drag
default	15:38:38.009193+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.009253+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.009322+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.009334+0500	Runner	touch drag
default	15:38:38.017658+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.017666+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.017887+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.017946+0500	Runner	touch drag
default	15:38:38.025427+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.025684+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.025696+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.025706+0500	Runner	touch drag
default	15:38:38.037693+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.037700+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.037708+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.037764+0500	Runner	touch drag
default	15:38:38.046411+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.046441+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.046458+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.046473+0500	Runner	touch drag
default	15:38:38.053425+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.053806+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.059210+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.060714+0500	Runner	touch drag
default	15:38:38.060827+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.071338+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.071427+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.071924+0500	Runner	touch drag
default	15:38:38.072333+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.072459+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.072540+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.072551+0500	Runner	touch drag
default	15:38:38.072565+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.072572+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.072793+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.072841+0500	Runner	touch up
error	15:38:38.083151+0500	Runner	Could not find cached accumulator for token=9B8E86B1 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
error	15:38:38.107171+0500	Runner	Could not find cached accumulator for token=4669A021 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:38.142502+0500	Runner	Performing delayed generation for token=D8453962
default	15:38:38.653091+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.653203+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.653429+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.653534+0500	Runner	touch down
default	15:38:38.660526+0500	Runner	Setting dynamic keyplane: Dynamic-QWERTY-Kabyle-Small_First-Alternate
default	15:38:38.684101+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:38.684185+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:38.684372+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:38.684425+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:38.685111+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:38.685184+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:38.685314+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:38.685380+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:38.686006+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 335}]
default	15:38:38.693711+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.734066+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.734345+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.734386+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.734405+0500	Runner	touch up
default	15:38:38.737466+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511918.737259 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 1;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 7;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 5;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 2;
    timestamp = "790511917.3338881";
    withAlternativesCount = 0;
}
default	15:38:38.742166+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:38.936352+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:38.936378+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:38.936413+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:38.936691+0500	Runner	touch down
default	15:38:38.941749+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.002201+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.002213+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.002223+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.002229+0500	Runner	touch up
default	15:38:39.002352+0500	Runner	Keyboard receives keyEvent type: 4; subtype: 0
default	15:38:39.002365+0500	Runner	Keyboard adds a string
default	15:38:39.008021+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:39.009526+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:39.009588+0500	Runner	Keyboard receives output from kbd
default	15:38:39.013329+0500	Runner	Keyboard inserts text
default	15:38:39.036258+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:39.036319+0500	Runner	All generators are not complete.
default	15:38:39.038510+0500	Runner	All generators are not complete.
default	15:38:39.039558+0500	Runner	All generators are not complete.
default	15:38:39.054560+0500	Runner	All generators are not complete.
default	15:38:39.054819+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:39.054850+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - F28DCD21
default	15:38:39.054975+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x1470a8580> to candidate receiver, for request token: F28DCD21
default	15:38:39.054982+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. F28DCD21.
default	15:38:39.143523+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.143603+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.143610+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.143616+0500	Runner	touch down
default	15:38:39.144860+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.192369+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.192414+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.192433+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.192497+0500	Runner	touch up
default	15:38:39.192840+0500	Runner	Keyboard receives keyEvent type: 4; subtype: 0
default	15:38:39.192914+0500	Runner	Keyboard adds a string
default	15:38:39.193272+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:39.195866+0500	Runner	Keyboard receives output from kbd
default	15:38:39.205152+0500	Runner	Keyboard inserts text
default	15:38:39.207139+0500	Runner	Setting dynamic keyplane: Dynamic-Russian-Small_Small-Letters-Small-Display
default	15:38:39.214869+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:39.214931+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:39.215023+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:39.215095+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:39.215401+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:39.215425+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:39.215457+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:39.215475+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:39.215706+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 335} [previous size={393, 335}]
default	15:38:39.219944+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:39.219999+0500	Runner	All generators are not complete.
default	15:38:39.220041+0500	Runner	All generators are not complete.
default	15:38:39.220072+0500	Runner	All generators are not complete.
default	15:38:39.225555+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:39.228003+0500	Runner	All generators are not complete.
default	15:38:39.229495+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:39.229602+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - EFB80B39
default	15:38:39.229609+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x1470aa6e0> to candidate receiver, for request token: EFB80B39
default	15:38:39.229639+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. EFB80B39.
default	15:38:39.460803+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.460925+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.460943+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.461292+0500	Runner	touch down
default	15:38:39.462528+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.518909+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.518933+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.518959+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.519187+0500	Runner	touch up
default	15:38:39.519294+0500	Runner	Keyboard receives keyEvent type: 4; subtype: 0
default	15:38:39.519489+0500	Runner	Keyboard adds a string
default	15:38:39.520286+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:39.522540+0500	Runner	Keyboard receives output from kbd
default	15:38:39.524760+0500	Runner	Keyboard inserts text
default	15:38:39.529148+0500	Runner	Cancelled Smart Reply generateCandidates
default	15:38:39.529212+0500	Runner	All generators are not complete.
default	15:38:39.529258+0500	Runner	All generators are not complete.
default	15:38:39.529289+0500	Runner	All generators are not complete.
default	15:38:39.529575+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:39.574203+0500	Runner	All generators are not complete.
default	15:38:39.575189+0500	Runner	All generators are complete, dispatching to `completionBlockJustOnce`
default	15:38:39.575304+0500	Runner	Assigning candidates of source type kbd to `containerToPush, for autocorrection flow only` - 826AEF87
default	15:38:39.575335+0500	Runner	Preparing to push <_TUIKeyboardCandidateContainer: 0x1470ab260> to candidate receiver, for request token: 826AEF87
default	15:38:39.575408+0500	Runner	containerToPush has an autocorrection list.  pushing to candidate receiver with request token. 826AEF87.
default	15:38:39.804462+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.804549+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.804646+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.804968+0500	Runner	touch down
default	15:38:39.810659+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.884915+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.884973+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.884994+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.885200+0500	Runner	touch drag
default	15:38:39.892895+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.892935+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.892987+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.893035+0500	Runner	touch drag
default	15:38:39.893225+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:39.893374+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.893460+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.893482+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.893553+0500	Runner	touch drag
default	15:38:39.902226+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.902271+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.902293+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.902307+0500	Runner	touch drag
default	15:38:39.909353+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.909419+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.909473+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.909538+0500	Runner	touch drag
default	15:38:39.918064+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.918241+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.918328+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.918529+0500	Runner	touch drag
default	15:38:39.925982+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.926079+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.926111+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.926204+0500	Runner	touch drag
default	15:38:39.934534+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.934551+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.934566+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.934708+0500	Runner	touch drag
default	15:38:39.943850+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.943905+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.943917+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.944077+0500	Runner	touch drag
default	15:38:39.950931+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.951121+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.951189+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.951225+0500	Runner	touch drag
default	15:38:39.959280+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.959292+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.959304+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.959317+0500	Runner	touch drag
default	15:38:39.969064+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.969341+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.969377+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.969435+0500	Runner	touch drag
error	15:38:39.975686+0500	Runner	Could not find cached accumulator for token=C9286830 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:39.977102+0500	Runner	Keyboard sends inputEvent to kbd
default	15:38:39.977730+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.977752+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.977788+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.977890+0500	Runner	touch drag
default	15:38:39.981729+0500	Runner	Keyboard receives output from kbd
default	15:38:39.982039+0500	Runner	Keyboard inserts text
default	15:38:39.985120+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511919.984829 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 4;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 3;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 1;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 1;
    timestamp = "790511918.734272";
    withAlternativesCount = 0;
}
default	15:38:39.985743+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:39.985806+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:39.985845+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:39.985857+0500	Runner	touch drag
default	15:38:39.992486+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.017465+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.017520+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.017724+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.017735+0500	Runner	touch up
error	15:38:40.037322+0500	Runner	Could not find cached accumulator for token=0EB60825 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:40.058495+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511920.057857 payload:{
    Class = IATextInputActionsSessionReplaceTextAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 2;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 1;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 1;
    source = 7;
    textInputActionsType = 1;
    timestamp = "790511919.983699";
}
default	15:38:40.320331+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.320384+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.320452+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.320719+0500	Runner	touch down
default	15:38:40.323621+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.330569+0500	Runner	[0x12ff64500] activating connection: mach=true listener=false peer=false name=com.apple.TextInput.image-cache-server
default	15:38:40.359519+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.359749+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.359777+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.359816+0500	Runner	touch drag
default	15:38:40.370096+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.370125+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.370150+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.370167+0500	Runner	touch drag
default	15:38:40.376185+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.376266+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.376313+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.376359+0500	Runner	touch drag
default	15:38:40.376465+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:40.376513+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.376527+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.376558+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.376595+0500	Runner	touch drag
default	15:38:40.384673+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.384684+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.384695+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.384701+0500	Runner	touch drag
default	15:38:40.392721+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.392931+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.392946+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.392955+0500	Runner	touch drag
default	15:38:40.401981+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.401998+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.402012+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.402019+0500	Runner	touch drag
default	15:38:40.410279+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.410285+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.410295+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.410310+0500	Runner	touch drag
default	15:38:40.418345+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.418375+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.418755+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.418868+0500	Runner	touch drag
default	15:38:40.425910+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.425954+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.425976+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.425993+0500	Runner	touch drag
default	15:38:40.435807+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.435861+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.435934+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.435956+0500	Runner	touch drag
default	15:38:40.442827+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.442985+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.443028+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.443135+0500	Runner	touch drag
error	15:38:40.443151+0500	Runner	Could not find cached accumulator for token=73BB43AF type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:40.450886+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.450908+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.450928+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.451147+0500	Runner	touch drag
default	15:38:40.459264+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.459305+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.459342+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.459371+0500	Runner	touch drag
default	15:38:40.467550+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.467596+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.467636+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.467691+0500	Runner	touch drag
default	15:38:40.475928+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.475949+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.475967+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.475994+0500	Runner	touch drag
default	15:38:40.484276+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.484316+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.484343+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.484361+0500	Runner	touch drag
default	15:38:40.485233+0500	Runner	[0x12ff64500] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:40.492549+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.492582+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.492608+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.492634+0500	Runner	touch drag
default	15:38:40.501003+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.501049+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.501091+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.501125+0500	Runner	touch drag
default	15:38:40.509243+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.509290+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.509327+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.509358+0500	Runner	touch drag
default	15:38:40.519551+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.519582+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.519615+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.519870+0500	Runner	touch drag
default	15:38:40.526181+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.526258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.526282+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.526375+0500	Runner	touch drag
default	15:38:40.534684+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.534702+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.534723+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.534775+0500	Runner	touch drag
default	15:38:40.542767+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.542820+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.542850+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.543287+0500	Runner	touch drag
default	15:38:40.543339+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.543349+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.543359+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.543430+0500	Runner	touch up
default	15:38:40.550937+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
error	15:38:40.579710+0500	Runner	Could not find cached accumulator for token=5BBDB7B5 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:40.612281+0500	Runner	Performing delayed generation for token=F28DCD21
default	15:38:40.785995+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.786072+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.786185+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.786454+0500	Runner	touch down
default	15:38:40.789788+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.793746+0500	Runner	[0x12ff64500] activating connection: mach=true listener=false peer=false name=com.apple.TextInput.image-cache-server
default	15:38:40.795409+0500	Runner	Performing delayed generation for token=EFB80B39
default	15:38:40.826137+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.826225+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.826258+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.826282+0500	Runner	touch drag
default	15:38:40.836658+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.836694+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.836719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.836734+0500	Runner	touch drag
default	15:38:40.842889+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.843066+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.843096+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.843111+0500	Runner	touch drag
default	15:38:40.852998+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.853022+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.853037+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.853045+0500	Runner	touch drag
default	15:38:40.859458+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.859519+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.859575+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.859771+0500	Runner	touch drag
default	15:38:40.859863+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:40.859922+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.859956+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.860007+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.860037+0500	Runner	touch drag
default	15:38:40.867888+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.867906+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.867922+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.867930+0500	Runner	touch drag
default	15:38:40.875978+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.876009+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.876040+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.876060+0500	Runner	touch drag
default	15:38:40.885245+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.885270+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.885277+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.885288+0500	Runner	touch drag
default	15:38:40.895734+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.896161+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.896373+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.896473+0500	Runner	touch drag
default	15:38:40.901765+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.901778+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.901798+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.901809+0500	Runner	touch drag
default	15:38:40.909521+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.909578+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.909729+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.909751+0500	Runner	touch drag
default	15:38:40.919027+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.919032+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.919503+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.919534+0500	Runner	touch drag
error	15:38:40.920315+0500	Runner	Could not find cached accumulator for token=A9A7FA81 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:40.925982+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.926039+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.926069+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.926094+0500	Runner	touch drag
default	15:38:40.934307+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.934334+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.934355+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.934365+0500	Runner	touch drag
default	15:38:40.942715+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.942758+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.942795+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.942825+0500	Runner	touch drag
default	15:38:40.951056+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.951129+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.952132+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.952179+0500	Runner	touch drag
default	15:38:40.952291+0500	Runner	[0x12ff64500] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:40.959362+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.959394+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.959413+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.959429+0500	Runner	touch drag
default	15:38:40.967685+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:40.967731+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:40.967772+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:40.967806+0500	Runner	touch drag
default	15:38:40.992826+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.001677+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.001699+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.001840+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.001858+0500	Runner	touch drag
default	15:38:41.009515+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.009555+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.009588+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.009707+0500	Runner	touch drag
default	15:38:41.018431+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.018477+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.018501+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.018511+0500	Runner	touch drag
default	15:38:41.026246+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.026307+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.026470+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.026492+0500	Runner	touch drag
default	15:38:41.034611+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.034647+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.034689+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.034862+0500	Runner	touch drag
default	15:38:41.043057+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.043090+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.043118+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.043252+0500	Runner	touch drag
default	15:38:41.056866+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.056898+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.056912+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.056921+0500	Runner	touch drag
default	15:38:41.060555+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.060600+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.060622+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.060640+0500	Runner	touch drag
default	15:38:41.069627+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.069756+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.069768+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.069794+0500	Runner	touch drag
default	15:38:41.080157+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.080164+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.080173+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.080178+0500	Runner	touch drag
default	15:38:41.088956+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.089010+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.089030+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.089081+0500	Runner	touch drag
default	15:38:41.094532+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.094567+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.094594+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.094618+0500	Runner	touch drag
default	15:38:41.105475+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.105726+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.105981+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.114161+0500	Runner	touch drag
default	15:38:41.114779+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.114792+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.114803+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.122819+0500	Runner	touch drag
default	15:38:41.122872+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.122880+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.122899+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.126650+0500	Runner	touch drag
default	15:38:41.129189+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.129266+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.129729+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.129762+0500	Runner	touch drag
error	15:38:41.132051+0500	Runner	Could not find cached accumulator for token=7890148F type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:41.137085+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.137233+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.138612+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.138636+0500	Runner	touch drag
default	15:38:41.146456+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.146471+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.146485+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.147380+0500	Runner	touch drag
default	15:38:41.148571+0500	Runner	Performing delayed generation for token=826AEF87
default	15:38:41.151284+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.151436+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.151448+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.151453+0500	Runner	touch drag
default	15:38:41.159445+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.159457+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.159471+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.159485+0500	Runner	touch drag
default	15:38:41.168230+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.168236+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.168242+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.168905+0500	Runner	touch drag
default	15:38:41.176024+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.176055+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.176067+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.176100+0500	Runner	touch drag
default	15:38:41.184370+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.184417+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.184432+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.184444+0500	Runner	touch drag
default	15:38:41.192755+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.192792+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.192807+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.192821+0500	Runner	touch drag
default	15:38:41.201075+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.201332+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.201354+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.201363+0500	Runner	touch drag
default	15:38:41.209508+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.209532+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.209604+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.209614+0500	Runner	touch drag
default	15:38:41.218293+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.218316+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.218460+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.218482+0500	Runner	touch drag
default	15:38:41.226213+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.226294+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.226322+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.226358+0500	Runner	touch drag
default	15:38:41.234793+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.234891+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.234951+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.235029+0500	Runner	touch drag
default	15:38:41.242921+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.242940+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.242981+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.243040+0500	Runner	touch drag
default	15:38:41.251476+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.251502+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.251521+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.251565+0500	Runner	touch drag
default	15:38:41.259541+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.259603+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.259623+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.259681+0500	Runner	touch drag
default	15:38:41.269182+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.269212+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.269227+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.269319+0500	Runner	touch drag
default	15:38:41.276139+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.276160+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.276221+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.276235+0500	Runner	touch drag
default	15:38:41.284476+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.284483+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.284491+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.284496+0500	Runner	touch drag
default	15:38:41.292758+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.292797+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.292817+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.292829+0500	Runner	touch drag
default	15:38:41.301649+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.301678+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.301707+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.301757+0500	Runner	touch drag
default	15:38:41.309782+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.309815+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.309834+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.309845+0500	Runner	touch drag
error	15:38:41.316797+0500	Runner	Could not find cached accumulator for token=E651C758 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:41.319319+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.319341+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.319395+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.319427+0500	Runner	touch drag
default	15:38:41.326045+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.326064+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.326098+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.326109+0500	Runner	touch drag
default	15:38:41.334454+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.334480+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.334505+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.334640+0500	Runner	touch drag
default	15:38:41.368649+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.369159+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.369195+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.369271+0500	Runner	touch drag
default	15:38:41.376197+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.376241+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.376282+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.376315+0500	Runner	touch drag
default	15:38:41.385157+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.385174+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.385304+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.385313+0500	Runner	touch drag
default	15:38:41.393686+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.393735+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.394155+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.394193+0500	Runner	touch drag
default	15:38:41.404016+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.404032+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.404056+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.405323+0500	Runner	touch drag
default	15:38:41.412075+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.412082+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.412096+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.412158+0500	Runner	touch drag
default	15:38:41.426440+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.426446+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.426454+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.426862+0500	Runner	touch drag
default	15:38:41.430954+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.430968+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.430989+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.431001+0500	Runner	touch drag
default	15:38:41.434401+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.434494+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.434580+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.434643+0500	Runner	touch drag
default	15:38:41.442975+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.443023+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.443041+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.443159+0500	Runner	touch drag
default	15:38:41.451451+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.451510+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.451637+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.451792+0500	Runner	touch drag
default	15:38:41.459687+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.459816+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.459877+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.459954+0500	Runner	touch drag
default	15:38:41.468811+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.468823+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.468837+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.468846+0500	Runner	touch drag
default	15:38:41.476304+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.476386+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.476533+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.476660+0500	Runner	touch drag
default	15:38:41.484417+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.484435+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.484447+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.484460+0500	Runner	touch drag
default	15:38:41.492803+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.492832+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.492860+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.492880+0500	Runner	touch drag
default	15:38:41.501168+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.501200+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.501899+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.501924+0500	Runner	touch drag
default	15:38:41.509633+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.509722+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.510020+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.510052+0500	Runner	touch drag
default	15:38:41.519042+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.520201+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.520246+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.520262+0500	Runner	touch drag
error	15:38:41.523833+0500	Runner	Could not find cached accumulator for token=CEEB54F4 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:41.526103+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.526124+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.526143+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.526175+0500	Runner	touch drag
default	15:38:41.534455+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.534499+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.534538+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.534569+0500	Runner	touch drag
default	15:38:41.542864+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.542901+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.542938+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.542968+0500	Runner	touch drag
default	15:38:41.551162+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.551204+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.551243+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.551274+0500	Runner	touch drag
default	15:38:41.559473+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.559514+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.559551+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.559578+0500	Runner	touch drag
default	15:38:41.567859+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.567904+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.567943+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.567977+0500	Runner	touch drag
default	15:38:41.576172+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.576191+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.576225+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.576250+0500	Runner	touch drag
default	15:38:41.584788+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.584800+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.584820+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.584844+0500	Runner	touch drag
default	15:38:41.593178+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.593210+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.593240+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.593251+0500	Runner	touch drag
default	15:38:41.601650+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.601691+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.601768+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.601813+0500	Runner	touch drag
default	15:38:41.609565+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.609613+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.609648+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.609658+0500	Runner	touch drag
default	15:38:41.619375+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.619402+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.619426+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.619563+0500	Runner	touch drag
default	15:38:41.626399+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.626559+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.626692+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.626708+0500	Runner	touch drag
default	15:38:41.634809+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.634825+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.634854+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.634882+0500	Runner	touch drag
default	15:38:41.643002+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.643100+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.643172+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.643260+0500	Runner	touch drag
default	15:38:41.651474+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.651585+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.651623+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.651680+0500	Runner	touch drag
default	15:38:41.659651+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.659667+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.659687+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.659703+0500	Runner	touch drag
default	15:38:41.668889+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.668930+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.668998+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.669034+0500	Runner	touch drag
default	15:38:41.676177+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.676317+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.676364+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.676397+0500	Runner	touch drag
default	15:38:41.686299+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.686307+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.687289+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.688632+0500	Runner	touch drag
default	15:38:41.692923+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.692955+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.692976+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.692992+0500	Runner	touch drag
default	15:38:41.706444+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.706451+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.713049+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.713058+0500	Runner	touch drag
default	15:38:41.713079+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.713114+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.713272+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.713429+0500	Runner	touch drag
default	15:38:41.718879+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.718920+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.718947+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.718976+0500	Runner	touch drag
error	15:38:41.724498+0500	Runner	Could not find cached accumulator for token=4873C892 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:41.726337+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.726355+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.726398+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.726413+0500	Runner	touch drag
default	15:38:41.734843+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.734858+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.734868+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.735008+0500	Runner	touch drag
default	15:38:41.742898+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.742937+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.742973+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.742990+0500	Runner	touch drag
default	15:38:41.751143+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.751351+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.751391+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.751416+0500	Runner	touch drag
default	15:38:41.759479+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.759496+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.759573+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.759588+0500	Runner	touch drag
default	15:38:41.767951+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.767999+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.768038+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.768073+0500	Runner	touch drag
default	15:38:41.776257+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.776379+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.776406+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.776431+0500	Runner	touch drag
default	15:38:41.784514+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.784558+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.784595+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.784627+0500	Runner	touch drag
default	15:38:41.792970+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.793049+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.793075+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.793135+0500	Runner	touch drag
default	15:38:41.801750+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.801796+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.801811+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.802059+0500	Runner	touch drag
default	15:38:41.818914+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.819041+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:41.819128+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:41.819200+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIRemoteKeyboardWindow: 0x130cba300>; contextId: 0x127B6BE0
default	15:38:41.819330+0500	Runner	touch up
default	15:38:41.826308+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
error	15:38:41.854156+0500	Runner	Could not find cached accumulator for token=E6777373 type:0 in -[TUIKeyboardCandidateMultiplexer receiveExternalAutocorrectionUpdate:requestToken:]_block_invoke
default	15:38:42.579004+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:42.579041+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:42.579061+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:42.579363+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:42.610191+0500	Runner	Reloading input views for key-window scene responder: <(null): 0x0; > force:N
default	15:38:42.610986+0500	Runner	_reloadInputViewsForKeyWindowSceneResponder: 0 force: 0, fromBecomeFirstResponder: 0 (automaticKeyboard: 0, reloadIdentifier: D23CDCDA-C85A-4CC7-81C2-5E2425E458C2)
default	15:38:42.611191+0500	Runner	_inputViewsForResponder: <(null): 0x0; >, automaticKeyboard: 0, force: 0
default	15:38:42.611212+0500	Runner	_inputViewsForResponder, found custom inputView: <(null): 0x0>, customInputViewController: <(null): 0x0>
default	15:38:42.611234+0500	Runner	_inputViewsForResponder, found inputAccessoryView: <(null): 0x0>
default	15:38:42.611258+0500	Runner	_inputViewsForResponder, responderRequiresKeyboard 0 (automaticKeyboardEnabled: 0, activeInstance: <UIKeyboardAutomatic: 0x124d7e580; frame = {{0, 0}, {393, 233}}; alpha = 1.000000; isHidden = 0; tAMIC = 0>, self.isOnScreen: 1, requiresKBWhenFirstResponder: 0)
default	15:38:42.611288+0500	Runner	_inputViewsForResponder, useKeyboard 0 (allowsSystemInputView: 1, !inputView <(null): 0x0>, responderRequiresKeyboard 0)
default	15:38:42.611340+0500	Runner	_inputViewsForResponder, configuring _responderWithoutAutomaticAppearanceEnabled: <(null): 0x0> (_automaticAppearEnabled: 1)
default	15:38:42.611361+0500	Runner	_inputViewsForResponder returning: <<UIInputViewSet: 0x147093900>; (empty)>
default	15:38:42.611382+0500	Runner	currently observing: YES
default	15:38:42.611479+0500	Runner	currently observing: NO
default	15:38:42.611488+0500	Runner	-_teardownExistingDelegate:<FlutterTextInputView: 0x12ff14000> forSetDelegate:(nil) force:NO delayEndInputSession:NO
default	15:38:42.612632+0500	Runner	-[RTIInputSystemClient endRemoteTextInputSessionWithID:options:completion:]  Ending text input session. sessionID = C13188AF-FB7E-4F39-AB3A-EB72297E84AB, options = <RTISessionOptions: 0x1470aa2c0; shouldResign = YES; animated = YES; offscreenDirection = 0; enhancedWindowingModeEnabled = NO
default	15:38:42.612670+0500	Runner	-[RTIInputSystemClient _endSessionWithID:forServices:options:completion:]  End input session: C13188AF-FB7E-4F39-AB3A-EB72297E84AB
default	15:38:42.613333+0500	Runner	-[RTIInputSystemClient endAllowingRemoteTextInput:completion:]  End allowing remote text input: C13188AF-FB7E-4F39-AB3A-EB72297E84AB
default	15:38:42.613409+0500	Runner	-[RTIInputSystemClient _modifyTextEditingAllowedForReason:notify:animated:modifyAllowancesBlock:completion:]  Text editing allowed did change (editingAllowedAfter = NO)
default	15:38:42.613610+0500	Runner	Handling responseContextDidChange - existing: (null), new: (null)
default	15:38:42.614536+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x147093900>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.614897+0500	Runner	-[_UIRemoteKeyboards prepareToMoveKeyboard:withIAV:isIAVRelevant:showing:notifyRemote:forScene:] position: {{0, 0}, {0, 0}} visible: 0; notifyRemote: 1; isMinimized: NO
default	15:38:42.615014+0500	Runner	prepareToMoveKeyboard: set currentKeyboard:N
default	15:38:42.615075+0500	Runner	TX signalKeyboardChanged
default	15:38:42.615178+0500	Runner	-[_UIRemoteKeyboards signalToProxyKeyboardChanged:onCompletion:]  Signaling keyboard changed <<<_UIKeyboardChangedInformation: 0x1470c6700>; appId (null) bundleId (null) animation fence <BKSAnimationFenceHandle:0x130cfe820 -> <CAFenceHandle:0x1470a49a0 name=1d fence=4c00000ffd usable=YES>>; position {{0, 0}, {0, 0}}; animated YES; on screen NO; tracking NO; resizing NO; local NO, dock state: Unknown, hasValidNotif: NO>; source canvas com.apple.frontboard.systemappservices/FBSceneManager:sceneID%3Abizlevel.kz-default; source display Main; source bundle bizlevel.kz; host bundle (null); animation fence <BKSAnimationFenceHandle:0x130cfe820 -> <CAFenceHandle:0x1470a49a0 name=1d fence=4c00000ffd usable=YES>>; position {{0, 0}, {0, 0}} (with IAV same); floating 0; on screen NO;  intersectable YES; snapshot YES>
default	15:38:42.615916+0500	Runner	Show keyboard with visual mode windowed (0)
default	15:38:42.615953+0500	Runner	Setting input views: <<UIInputViewSet: 0x1470906c0>; (empty)>
default	15:38:42.625545+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.625674+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.626740+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.626977+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.627644+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.627758+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.628495+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.628504+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.628730+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x1470906c0>; (empty)> windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.629730+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:38:42.629924+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:42.630139+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.630163+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.630304+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.630316+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.630397+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.630403+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.630537+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  > windowScene: <_UIKeyboardWindowScene: 0x12ff54c80; role: _UIScreenBasedSceneSession; persistentIdentifier: 086A498B-5F38-4559-9E5E-93355A5D982D; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.630976+0500	Runner	endPlacementForInputViewSet, returning -> <UIInputViewSetPlacementOnScreen>
default	15:38:42.632108+0500	Runner	Tracking provider: moveFromPlacement: <UIInputViewSetPlacementOnScreen> toPlacement: <UIInputViewSetPlacementOffScreenDown> update to: {{0, 852}, {393, 335}}
default	15:38:42.632966+0500	Runner	Updating tracking clients for start <TUIKeyboardTrackingCoordinator:0x12ff12440 state=<TUIKeyboardState: 0x1470a9c20 State: offscreen; is docked>; frame={{0, 852}, {393, 335}}; animation=<TUIKeyboardAnimationInfo: 0x147113480, duration: 0.38, from local keyboard, is not rotating, should animate, type: 0, notificationInfo: {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}notificationsDebug: >>
default	15:38:42.633137+0500	Runner	changeSizingConstants: size is changing [not transitioning] to {393, 0} [previous size: {393, 335}]
default	15:38:42.635200+0500	Runner	Setting tracking element input views: <<UIInputViewSet: 0x147090900>; (empty)>
default	15:38:42.635307+0500	Runner	-[_UIRemoteKeyboardPlaceholderView refreshPlaceholder]  refreshPlaceholder: size={393, 0} [previous size={393, 335}]
default	15:38:42.635412+0500	Runner	Placeholder height changed from 335.0 to 0.0
default	15:38:42.635462+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x147090900>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:42.635590+0500	Runner	Moving from placement: <UIInputViewSetPlacementOnScreen> to placement: <UIInputViewSetPlacementOffScreenDown> (currentPlacement: <UIInputViewSetPlacementOnScreen>)
default	15:38:42.636023+0500	Runner	updatePlacementWithPlacement: <UIInputViewSetPlacementOffScreenDown>
default	15:38:42.636562+0500	Runner	Posted notification willHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:42.650585+0500	Runner	[0x12fe7d900] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:42.651011+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:42.651046+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:42.651096+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:42.660559+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:42.666660+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511922.666391 payload:{
    Class = IATextInputActionsSessionInsertionAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 2;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 13;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 8;
    options = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 2;
    timestamp = "790511920.038871";
    withAlternativesCount = 0;
}
default	15:38:42.667010+0500	Runner	channel:LegacyTextInputActions signal:DidAction sessionID:(null) timestamp:790511922.666861 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 0;
    timestamp = "790511922.61421";
}
default	15:38:42.667320+0500	Runner	channel:LegacyTextInputActions signal:DidSessionEnd sessionID:C13188AF-FB7E-4F39-AB3A-EB72297E84AB timestamp:790511922.667102 payload:{
    Class = IATextInputActionsSessionEndAction;
    appBundleId = "bizlevel.kz";
    clientSideSessionErrors = "";
    flagOptions = 0;
    inputActionCountFromMergedActions = 0;
    inputMode =     {
        inputModeIdentifier = "ru_RU@sw=Russian;hw=Automatic";
        keyboardLayout = Russian;
        language = ru;
        region = RU;
    };
    insertedEmojiCount = 0;
    insertedPunctuationCount = 0;
    insertedTextLength = 0;
    largestSingleDeletionLength = 0;
    largestSingleInsertionLength = 0;
    processBundleId = "bizlevel.kz";
    "relativeRangeBefore_length" = 0;
    "relativeRangeBefore_location" = 0;
    removedEmojiCount = 0;
    removedPunctuationCount = 0;
    removedTextLength = 0;
    source = 4;
    textInputActionsType = 0;
    timestamp = "790511922.61421";
}
default	15:38:42.668097+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:42.727967+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:43.056982+0500	Runner	TX setWindowContextID:310078432 windowState:Disabled level:5.0
    focusContext:<contextID:3697527455 sceneID:bizlevel.kz-default>
default	15:38:43.058047+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff91bc0>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; usesKeyClicks = NO;  >
default	15:38:43.058056+0500	Runner	Change to input view set: <<UIInputViewSet: 0x147090900>; (empty)>
default	15:38:43.058079+0500	Runner	endPlacementForInputViewSet: <<UIInputViewSet: 0x147090900>; (empty)> windowScene: <UIWindowScene: 0x1057a0200; role: UIWindowSceneSessionRoleApplication; persistentIdentifier: BD599607-7944-4E08-8563-2A336AAF206A; activationState: UISceneActivationStateForegroundActive>
default	15:38:43.058480+0500	Runner	-[UIDictationController setIgnoreFinalizePhrases:] Setting ignoreFinalizePhrases flag 1
default	15:38:43.058511+0500	Runner	Posted notification didHide with {
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.3833";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {393, 335}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {196.5, 684.5}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {196.5, 1019.5}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 517}, {393, 335}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 852}, {393, 335}}";
    UIKeyboardIsLocalUserInfoKey = 1;
} (null)
default	15:38:43.058655+0500	Runner	Change from input view set: <<UIInputViewSet: 0x12ff91200>; keyboard = <UIKeyboardAutomatic: 0x124d7e580; frame = (0 0; 393 233); opaque = NO; layer = <CALayer: 0x105e19b00>>%; assistant = <TUISystemInputAssistantView: 0x10562d800; frame = (0 0; 393 44); >; usesKeyClicks = NO;  >
default	15:38:43.058773+0500	Runner	Change to input view set: <<UIInputViewSet: 0x1470906c0>; (empty)>
default	15:38:43.162030+0500	Runner	flutter: 🔧 DEBUG: sendMessageWithRAG начался
default	15:38:43.162048+0500	Runner	flutter: 🔧 DEBUG: session.user.id = dc7d094d-9fd1-4b78-b153-6c2185fd26ef
default	15:38:43.162147+0500	Runner	flutter: 🔧 DEBUG: chatId = null
default	15:38:43.164551+0500	Runner	Received state update for 7483 (app<bizlevel.kz(DF3F9026-8F3D-40FC-B7A8-0228817FBA89)>, unknown-NotVisible
default	15:38:43.170384+0500	Runner	nw_path_libinfo_path_check [C4BD2D72-31AF-4F10-9018-BA08775C878C acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:43.190779+0500	Runner	nw_path_libinfo_path_check [471D5678-2726-4FC6-86AA-BB03BE4B8A3F acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:43.403675+0500	Runner	[0x11e23df40] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:43.406864+0500	Runner	[0x11e23df40] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:46.157438+0500	Runner	App is being debugged, do not track this hang
default	15:38:46.157470+0500	Runner	Hang detected: 1.61s (debugger attached, not reporting)
default	15:38:46.158550+0500	Runner	nw_path_libinfo_path_check [315AB58F-2E73-432C-8A14-CF4572CE6B82 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:46.194092+0500	Runner	nw_path_libinfo_path_check [3421D78C-2299-4CA6-8A30-6BE068867BEE acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:46.194930+0500	Runner	nw_path_libinfo_path_check [FCBD7283-A12D-4D78-B3F0-9F3AD63800EE acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:46.204906+0500	Runner	nw_path_libinfo_path_check [0E628FC3-CE9C-44D3-917A-D03185D14733 acevqbdpzgbtqznbpgzr.supabase.co:0 tcp, legacy-socket, attribution: developer]
	libinfo check path: satisfied (Path is satisfied), interface: en0[802.11], ipv4, dns, uses wifi, LQM: good
default	15:38:46.394188+0500	Runner	[0x11e23df40] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:46.399642+0500	Runner	[0x11e23df40] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:46.407031+0500	Runner	[0x11e23df40] activating connection: mach=true listener=false peer=false name=com.apple.trustd
default	15:38:46.410557+0500	Runner	[0x11e23df40] invalidated because the current process cancelled the connection by calling xpc_connection_cancel()
default	15:38:47.559474+0500	Runner	flutter: CHIPS http_status=200
default	15:38:47.559566+0500	Runner	flutter: CHIPS http_body={chips: [Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]}
default	15:38:47.559674+0500	Runner	flutter: CHIPS server=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:38:47.559833+0500	Runner	flutter: CHIPS merged=[Объясни тему ур.6, Как применить на практике, Пример из моей сферы, Разобрать мою задачу, Дай микро‑шаг, Типичные ошибки]
default	15:38:50.364734+0500	Runner	TX focusApplication (peekAppEvent) stealKB:Y scene:bizlevel.kz-default
default	15:38:50.364989+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.364996+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.365004+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.365011+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.423746+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.423789+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.423854+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.428124+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.428179+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.428200+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.438330+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.438354+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.438366+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.444982+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.445067+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.445101+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.445353+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 0; ignoreInteractionEvents: 0, systemGestureStateChange: 1
default	15:38:50.445441+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.445488+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.445511+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.456540+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.456625+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.456660+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.461505+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.461668+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.461719+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.470251+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.470352+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.470422+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.478586+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.478604+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.478641+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.497641+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.497658+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.499094+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
default	15:38:50.499131+0500	Runner	Evaluating dispatch of UIEvent: 0x105617400; type: 0; subtype: 0; backing type: 11; shouldSend: 1; ignoreInteractionEvents: 0, systemGestureStateChange: 0
default	15:38:50.499174+0500	Runner	Sending UIEvent type: 0; subtype: 0; to windows: 1
default	15:38:50.499205+0500	Runner	Sending UIEvent type: 0; subtype: 0; to window: <UIWindow: 0x105628000>; contextId: 0xDC63CA9F
