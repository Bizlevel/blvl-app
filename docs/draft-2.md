# логи ошибки запуска на симуляторе айфон:

Simulator device failed to launch bizlevel.kz.
Domain: FBSOpenApplicationServiceErrorDomain
Code: 1
Failure Reason: The request was denied by service delegate (SBMainWorkspace).
User Info: {
    BSErrorCodeDescription = RequestDenied;
    DVTErrorCreationDateKey = "2025-12-02 06:57:29 +0000";
    FBSOpenApplicationRequestID = 0xce5f;
    IDERunOperationFailingWorker = IDELaunchiPhoneSimulatorLauncher;
    SimCallingSelector = "launchApplicationWithID:options:pid:error:";
}
--
The request to open "bizlevel.kz" failed.
Domain: FBSOpenApplicationServiceErrorDomain
Code: 1
Failure Reason: The request was denied by service delegate (SBMainWorkspace).
User Info: {
    BSErrorCodeDescription = RequestDenied;
    FBSOpenApplicationRequestID = 0xce5f;
}
--
The operation couldn’t be completed. The process failed to launch.
Domain: FBProcessExit
Code: 64
Failure Reason: The process failed to launch.
User Info: {
    BSErrorCodeDescription = "launch-failed";
}
--
The operation couldn’t be completed. Launch failed.
Domain: RBSRequestErrorDomain
Code: 5
Failure Reason: Launch failed.
--
Launchd job spawn failed
Domain: NSPOSIXErrorDomain
Code: 153
--

Event Metadata: com.apple.dt.IDERunOperationWorkerFinished : {
    "device_identifier" = "F7F7D5FA-5763-4D8D-9D6E-7937BE64B0BA";
    "device_model" = "iPhone17,3";
    "device_osBuild" = "18.5 (22F77)";
    "device_osBuild_monotonic" = 2205007700;
    "device_os_variant" = 1;
    "device_platform" = "com.apple.platform.iphonesimulator";
    "device_platform_family" = 2;
    "device_reality" = 2;
    "device_thinningType" = "iPhone17,3";
    "device_transport" = 4;
    "launchSession_schemeCommand" = Run;
    "launchSession_schemeCommand_enum" = 1;
    "launchSession_targetArch" = arm64;
    "launchSession_targetArch_enum" = 6;
    "operation_duration_ms" = 32272;
    "operation_errorCode" = 1;
    "operation_errorDomain" = FBSOpenApplicationServiceErrorDomain;
    "operation_errorWorker" = IDELaunchiPhoneSimulatorLauncher;
    "operation_error_reportable" = 1;
    "operation_name" = IDERunOperationWorkerGroup;
    "param_consoleMode" = 1;
    "param_debugger_attachToExtensions" = 0;
    "param_debugger_attachToXPC" = 1;
    "param_debugger_type" = 3;
    "param_destination_isProxy" = 0;
    "param_destination_platform" = "com.apple.platform.iphonesimulator";
    "param_diag_MTE_enable" = 0;
    "param_diag_MainThreadChecker_stopOnIssue" = 0;
    "param_diag_MallocStackLogging_enableDuringAttach" = 0;
    "param_diag_MallocStackLogging_enableForXPC" = 1;
    "param_diag_allowLocationSimulation" = 1;
    "param_diag_checker_mtc_enable" = 1;
    "param_diag_checker_tpc_enable" = 1;
    "param_diag_gpu_frameCapture_enable" = 0;
    "param_diag_gpu_shaderValidation_enable" = 0;
    "param_diag_gpu_validation_enable" = 1;
    "param_diag_guardMalloc_enable" = 0;
    "param_diag_memoryGraphOnResourceException" = 0;
    "param_diag_queueDebugging_enable" = 1;
    "param_diag_runtimeProfile_generate" = 0;
    "param_diag_sanitizer_asan_enable" = 0;
    "param_diag_sanitizer_tsan_enable" = 0;
    "param_diag_sanitizer_tsan_stopOnIssue" = 0;
    "param_diag_sanitizer_ubsan_enable" = 0;
    "param_diag_sanitizer_ubsan_stopOnIssue" = 0;
    "param_diag_showNonLocalizedStrings" = 0;
    "param_diag_viewDebugging_enabled" = 1;
    "param_diag_viewDebugging_insertDylibOnLaunch" = 1;
    "param_install_style" = 2;
    "param_launcher_UID" = 2;
    "param_launcher_allowDeviceSensorReplayData" = 0;
    "param_launcher_kind" = 0;
    "param_launcher_style" = 0;
    "param_launcher_substyle" = 0;
    "param_lldbVersion_component_idx_1" = 0;
    "param_lldbVersion_monotonic" = 170302340003;
    "param_runnable_appExtensionHostRunMode" = 0;
    "param_runnable_productType" = "com.apple.product-type.application";
    "param_testing_launchedForTesting" = 0;
    "param_testing_suppressSimulatorApp" = 0;
    "param_testing_usingCLI" = 0;
    "sdk_canonicalName" = "iphonesimulator26.1";
    "sdk_osVersion" = "26.1";
    "sdk_platformID" = 7;
    "sdk_variant" = iphonesimulator;
    "sdk_version_monotonic" = 2301007700;
}
--


System Information

macOS Version 15.7.2 (Build 24G325)
Xcode 26.1.1 (24455) (Build 17B100)
Timestamp: 2025-12-02T11:57:29+05:00


# Логи ошибки Launch:

Showing All Issues
Launch Runner
Platform: iOS Simulator

Device Identifier: F7F7D5FA-5763-4D8D-9D6E-7937BE64B0BA

Operating System Version: 18.5 (22F77)

Model: iPhone 16 (iPhone17,3)

Target Architecture: arm64

Simulator device failed to launch bizlevel.kz.
Domain: FBSOpenApplicationServiceErrorDomain
Code: 1
Failure Reason: The request was denied by service delegate (SBMainWorkspace).
User Info: {
    BSErrorCodeDescription = RequestDenied;
    DVTErrorCreationDateKey = "2025-12-02 06:57:29 +0000";
    FBSOpenApplicationRequestID = 0xce5f;
    IDERunOperationFailingWorker = IDELaunchiPhoneSimulatorLauncher;
    SimCallingSelector = "launchApplicationWithID:options:pid:error:";
}
--
The request to open "bizlevel.kz" failed.
Domain: FBSOpenApplicationServiceErrorDomain
Code: 1
Failure Reason: The request was denied by service delegate (SBMainWorkspace).
User Info: {
    BSErrorCodeDescription = RequestDenied;
    FBSOpenApplicationRequestID = 0xce5f;
}
--
The operation couldn’t be completed. The process failed to launch.
Domain: FBProcessExit
Code: 64
Failure Reason: The process failed to launch.
User Info: {
    BSErrorCodeDescription = "launch-failed";
}
--
The operation couldn’t be completed. Launch failed.
Domain: RBSRequestErrorDomain
Code: 5
Failure Reason: Launch failed.
--
Launchd job spawn failed
Domain: NSPOSIXErrorDomain
Code: 153
--

Event Metadata: com.apple.dt.IDERunOperationWorkerFinished : {
    "device_identifier" = "F7F7D5FA-5763-4D8D-9D6E-7937BE64B0BA";
    "device_model" = "iPhone17,3";
    "device_osBuild" = "18.5 (22F77)";
    "device_osBuild_monotonic" = 2205007700;
    "device_os_variant" = 1;
    "device_platform" = "com.apple.platform.iphonesimulator";
    "device_platform_family" = 2;
    "device_reality" = 2;
    "device_thinningType" = "iPhone17,3";
    "device_transport" = 4;
    "launchSession_schemeCommand" = Run;
    "launchSession_schemeCommand_enum" = 1;
    "launchSession_targetArch" = arm64;
    "launchSession_targetArch_enum" = 6;
    "operation_duration_ms" = 32272;
    "operation_errorCode" = 1;
    "operation_errorDomain" = FBSOpenApplicationServiceErrorDomain;
    "operation_errorWorker" = IDELaunchiPhoneSimulatorLauncher;
    "operation_error_reportable" = 1;
    "operation_name" = IDERunOperationWorkerGroup;
    "param_consoleMode" = 1;
    "param_debugger_attachToExtensions" = 0;
    "param_debugger_attachToXPC" = 1;
    "param_debugger_type" = 3;
    "param_destination_isProxy" = 0;
    "param_destination_platform" = "com.apple.platform.iphonesimulator";
    "param_diag_MTE_enable" = 0;
    "param_diag_MainThreadChecker_stopOnIssue" = 0;
    "param_diag_MallocStackLogging_enableDuringAttach" = 0;
    "param_diag_MallocStackLogging_enableForXPC" = 1;
    "param_diag_allowLocationSimulation" = 1;
    "param_diag_checker_mtc_enable" = 1;
    "param_diag_checker_tpc_enable" = 1;
    "param_diag_gpu_frameCapture_enable" = 0;
    "param_diag_gpu_shaderValidation_enable" = 0;
    "param_diag_gpu_validation_enable" = 1;
    "param_diag_guardMalloc_enable" = 0;
    "param_diag_memoryGraphOnResourceException" = 0;
    "param_diag_queueDebugging_enable" = 1;
    "param_diag_runtimeProfile_generate" = 0;
    "param_diag_sanitizer_asan_enable" = 0;
    "param_diag_sanitizer_tsan_enable" = 0;
    "param_diag_sanitizer_tsan_stopOnIssue" = 0;
    "param_diag_sanitizer_ubsan_enable" = 0;
    "param_diag_sanitizer_ubsan_stopOnIssue" = 0;
    "param_diag_showNonLocalizedStrings" = 0;
    "param_diag_viewDebugging_enabled" = 1;
    "param_diag_viewDebugging_insertDylibOnLaunch" = 1;
    "param_install_style" = 2;
    "param_launcher_UID" = 2;
    "param_launcher_allowDeviceSensorReplayData" = 0;
    "param_launcher_kind" = 0;
    "param_launcher_style" = 0;
    "param_launcher_substyle" = 0;
    "param_lldbVersion_component_idx_1" = 0;
    "param_lldbVersion_monotonic" = 170302340003;
    "param_runnable_appExtensionHostRunMode" = 0;
    "param_runnable_productType" = "com.apple.product-type.application";
    "param_testing_launchedForTesting" = 0;
    "param_testing_suppressSimulatorApp" = 0;
    "param_testing_usingCLI" = 0;
    "sdk_canonicalName" = "iphonesimulator26.1";
    "sdk_osVersion" = "26.1";
    "sdk_platformID" = 7;
    "sdk_variant" = iphonesimulator;
    "sdk_version_monotonic" = 2301007700;
}
--

Simulator device failed to launch bizlevel.kz.

