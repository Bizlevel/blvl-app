-- LLDB integration loaded --
FirebaseEarlyInit: configuring Firebase before UIApplicationMain
11.15.0 - [FirebaseCore][I-COR000003] The default Firebase app has not yet been configured. Add `FirebaseApp.configure()` to your application initialization. This can be done in in the App Delegate's application(_:didFinishLaunchingWithOptions:)` (or the `@main` struct's initializer in SwiftUI). Read more: https://firebase.google.com/docs/ios/setup#initialize_firebase_in_your_app
11.15.0 - [FirebaseCore][I-COR000001] Configuring the default app.
11.15.0 - [FirebaseMessaging][I-FCM028009] Deleted checkin plist file.
11.15.0 - [FirebaseMessaging][I-FCM002000] FIRMessaging library version 11.15.0
11.15.0 - [GULReachability][I-REA902003] Monitoring the network status
11.15.0 - [FirebaseInstallations][I-FIS002000] -[FIRInstallationsIDController createGetInstallationItemPromise], appName: __FIRAPP_DEFAULT
Firebase configured with plist at /private/var/containers/Bundle/Application/D9DA96D1-1A6E-4F51-979D-7C6B0E2B42A0/Runner.app/GoogleService-Info.plist
fopen failed for data file: errno = 2 (No such file or directory)
Errors found! Invalidating cache...
fopen failed for data file: errno = 2 (No such file or directory)
Errors found! Invalidating cache...
flutter: BOOTSTRAP [dotenv] done in 1607ms
11.15.0 - [GoogleUtilities/AppDelegateSwizzler][I-SWZ001011] App Delegate Proxy is disabled.
flutter: BOOTSTRAP [supabase] done in 5ms
flutter: BOOTSTRAP [firebase] done in 0ms
11.15.0 - [GULReachability][I-REA902004] Network status has changed. Code:2, status:Connected
11.15.0 - [FirebaseMessaging][I-FCM033002] Removed cached checkin preferences from Keychain because this is a fresh install.
11.15.0 - [FirebaseMessaging][I-FCM033006] Resetting old checkin and deleting server token registrations.
11.15.0 - [FirebaseInstallations][I-FIS002001] -[FIRInstallationsIDController installationWithValidAuthTokenForcingRefresh:0], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseMessaging][I-FCM034011] Invalidating cached token for 355423136369 (*) due to APNs token change.
11.15.0 - [FirebaseMessaging][I-FCM043000] Info is not found in Keychain. OSStatus: -25300. Keychain query: {
    acct = "bizlevel.kz";
    class = genp;
    gena = "com.google.iid-tokens";
    "m_Limit" = "m_LimitAll";
    nleg = 1;
    "r_Attributes" = 1;
    "r_Data" = 1;
}
11.15.0 - [FirebaseMessaging][I-FCM027006] Checkin parameters: {
    checkin =     {
        iosbuild =         {
            model = "iPhone16,1";
            "os_version" = "IOS_26.1";
        };
        "last_checkin_msec" = 0;
        type = 2;
        "user_number" = 0;
    };
    digest = "";
    fragment = 0;
    id = 0;
    locale = "ru_KZ";
    "security_token" = 0;
    "time_zone" = "Asia/Almaty";
    "user_serial_number" = 0;
    version = 2;
}
11.15.0 - [FirebaseMessaging][I-FCM034000] Fetch new token for authorizedEntity: 355423136369, scope: *
11.15.0 - [FirebaseMessaging][I-FCM043000] Info is not found in Keychain. OSStatus: -25300. Keychain query: {
    acct = "bizlevel.kz";
    class = genp;
    gena = "com.google.iid-tokens";
    "m_Limit" = "m_LimitAll";
    nleg = 1;
    "r_Attributes" = 1;
    "r_Data" = 1;
}
11.15.0 - [FirebaseMessaging][I-FCM025004] Checkin is in progress
11.15.0 - [FirebaseInstallations][I-FIS001001] Sending request: <NSMutableURLRequest: 0x1365a9c20> { URL: https://firebaseinstallations.googleapis.com/v1/projects/bizlevel-d22e1/installations/ }, body:{"appId":"1:355423136369:ios:58ad933cd9d4993f6b09d0","fid":"dIiNbxqY9U2_u3HER87zIy","authVersion":"FIS_v2","sdkVersion":"i:11.15.0"}, headers: {
    "Content-Type" = "application/json";
    "X-Goog-Api-Key" = "AIzaSyAswGpmZU0EERpXjyp9hE33-xBoX0jIjY4";
    "X-Ios-Bundle-Identifier" = "bizlevel.kz";
    "X-firebase-client" = "H4sIAAAAAAAAE13OwQrCMBAE0F8pezZtt6KFHv0C79bDmmw1GLshG0QR_92IguBteAPDPODElPKBKSsMuwc4yvxO0LXdyiAa7GG_ADrynGEAijGwiYHyJOkyNl60-pi689h0y03fv0GzJB6biYJy5TgGuY-NFSsUxWmRq7el99uTzIzrBVaTT2wmWzYRa1zV7Uf8rJlC-FfRn4iaKyf1MpcD6xqrmxVXxrHfYNvCs9z_9jB0zxfx07O38gAAAA";
}.
11.15.0 - [FirebaseMessaging][I-FCM027002] Invalid last checkin timestamp 2025-11-17 06:24:58 +0000 in future.
11.15.0 - [FirebaseMessaging][I-FCM027003] Checkin successful with authId: 4639371808120188670, digest: N2gKGKsgsZc2eWX0txvz8Q==, lastCheckinTimestamp: 1763360698000
11.15.0 - [FirebaseMessaging][I-FCM025004] Successfully got checkin credentials
11.15.0 - [FirebaseMessaging][I-FCM028010] Checkin plist file is saved
11.15.0 - [FirebaseMessaging][I-FCM043002] Couldn't delete item from Keychain OSStatus: -25300 with the keychain query {
    acct = "bizlevel.kz";
    class = genp;
    gena = "com.google.iid";
    nleg = 1;
    svce = "com.google.iid.checkin";
}
11.15.0 - [FirebaseInstallations][I-FIS002000] -[FIRInstallationsIDController createGetInstallationItemPromise], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseMessaging][I-FCM034000] Fetch new token for authorizedEntity: 355423136369, scope: *
11.15.0 - [FirebaseMessaging][I-FCM034000] Fetch new token for authorizedEntity: 355423136369, scope: *
11.15.0 - [FirebaseInstallations][I-FIS001003] Request response received: <NSMutableURLRequest: 0x1365a9c20> { URL: https://firebaseinstallations.googleapis.com/v1/projects/bizlevel-d22e1/installations/ }, error: (null), body: {
  "name": "projects/355423136369/installations/dIiNbxqY9U2_u3HER87zIy",
  "fid": "dIiNbxqY9U2_u3HER87zIy",
  "refreshToken": "3_AS3qfwKfIeMs9qu6OXYgHLmWL2y20C7xu0NSCXhmsT-9ddcl5MBNP2Tw4ezdhZyt3raP7RM3QHjQY0yjxg1lzE56D6cL2ubkfsNbnj2rnXdxZg",
  "authToken": {
    "token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjE6MzU1NDIzMTM2MzY5Omlvczo1OGFkOTMzY2Q5ZDQ5OTNmNmIwOWQwIiwiZXhwIjoxNzYzOTY1NDk5LCJmaWQiOiJkSWlOYnhxWTlVMl91M0hFUjg3ekl5IiwicHJvamVjdE51bWJlciI6MzU1NDIzMTM2MzY5fQ.AB2LPV8wRQIge1KMA8cfHEFZZhfxAiCkVMrbOmZAmZJ7sflkngE5o7QCIQDiE5XdO9h2Q3Pe1kl2riuhX9u2GJdqzUUi_BrRhywl7Q",
    "expiresIn": "604800s"
  }
}
.
11.15.0 - [FirebaseInstallations][I-FIS001005] Parsing server response for https://firebaseinstallations.googleapis.com/v1/projects/bizlevel-d22e1/installations/.
11.15.0 - [FirebaseInstallations][I-FIS001007] FIRInstallationsItem parsed successfully.
11.15.0 - [FirebaseMessaging][I-FCM041000] Unregister request to https://fcmtoken.googleapis.com/register content: X-osv=26.1&device=5168165342859551321&plat=2&app=bizlevel.kz&app_ver=1.0.6&X-cliv=fiid-11.15.0&delete=true
11.15.0 - [FirebaseMessaging][I-FCM034007] Successfully deleted GCM server registrations on app reset
11.15.0 - [FirebaseInstallations][I-FIS002001] -[FIRInstallationsIDController installationWithValidAuthTokenForcingRefresh:0], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseInstallations][I-FIS002000] -[FIRInstallationsIDController createGetInstallationItemPromise], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseMessaging][I-FCM040000] Register request to https://fcmtoken.googleapis.com/register content: X-osv=26.1&device=4639371808120188670&X-scope=*&plat=2&app=bizlevel.kz&app_ver=1.0.6&X-cliv=fiid-11.15.0&sender=355423136369&X-subtype=355423136369&appid=dIiNbxqY9U2_u3HER87zIy&apns_token=p_cdb184505b8cfadc9a3918a7236206d8c24efd06f82ac08879881f5436b08aab&gmp_app_id=1:355423136369:ios:58ad933cd9d4993f6b09d0
11.15.0 - [FirebaseInstallations][I-FIS002001] -[FIRInstallationsIDController installationWithValidAuthTokenForcingRefresh:0], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseInstallations][I-FIS002000] -[FIRInstallationsIDController createGetInstallationItemPromise], appName: __FIRAPP_DEFAULT
11.15.0 - [FirebaseMessaging][I-FCM043002] Couldn't delete item from Keychain OSStatus: -25300 with the keychain query {
    acct = "bizlevel.kz";
    class = genp;
    gena = "com.google.iid-tokens";
    nleg = 1;
    svce = "355423136369:*";
}
11.15.0 - [FirebaseMessaging][I-FCM040000] Register request to https://fcmtoken.googleapis.com/register content: X-osv=26.1&device=4639371808120188670&X-scope=*&plat=2&app=bizlevel.kz&app_ver=1.0.6&X-cliv=fiid-11.15.0&sender=355423136369&X-subtype=355423136369&appid=dIiNbxqY9U2_u3HER87zIy&apns_token=p_cdb184505b8cfadc9a3918a7236206d8c24efd06f82ac08879881f5436b08aab&gmp_app_id=1:355423136369:ios:58ad933cd9d4993f6b09d0
11.15.0 - [FirebaseMessaging][I-FCM034001] Token fetch successful, token: dIiNbxqY9U2_u3HER87zIy:APA91bFGdwILb5kdRX1A_aCcD7xHrBWU2jje30iggsxu7952yyy_FQcz5EHlLOZ8m6z2J0fksA_OZWaxJwx-qQ6trHyClYa_gAvkoygMhg9KdwkouJkpadI, authorizedEntity: 355423136369, scope:*
11.15.0 - [FirebaseMessaging][I-FCM034001] Token fetch successful, token: dIiNbxqY9U2_u3HER87zIy:APA91bFGdwILb5kdRX1A_aCcD7xHrBWU2jje30iggsxu7952yyy_FQcz5EHlLOZ8m6z2J0fksA_OZWaxJwx-qQ6trHyClYa_gAvkoygMhg9KdwkouJkpadI, authorizedEntity: 355423136369, scope:*
Message from debugger: killed