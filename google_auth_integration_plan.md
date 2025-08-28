# Plan: Integrate "Sign in with Google" with Supabase

This document outlines the steps to add a "Sign in with Google" button to the application, leveraging Supabase for authentication.

## Current State
The application currently uses Supabase for its authentication backend.

## Proposed Solution
Integrate Google OAuth as an authentication provider through Supabase, allowing users to register and log in using their Google accounts.

## Detailed Steps

### 1. Supabase Configuration
*   **Enable Google Provider:** In your Supabase project settings, navigate to "Authentication" -> "Providers" and enable Google.
*   **Configure Redirect URLs:** Set up the appropriate redirect URLs for your application. This typically includes:
    *   `https://<YOUR_SUPABASE_URL>/auth/v1/callback` (for web)
    *   Custom URL schemes for mobile platforms (e.g., `io.supabase.flutter://login-callback`)

### 2. Flutter Project Setup
*   **Add Dependencies:** Add the following dependencies to your `pubspec.yaml` file:
    ```yaml
    dependencies:
      supabase_flutter: ^latest_version
      google_sign_in: ^latest_version
    ```
*   **Install Dependencies:** Run `flutter pub get` in your terminal to fetch the new packages.
*   **Platform-Specific Setup:**
    *   **Android:** Configure your `android/app/build.gradle` for Google Sign-In (e.g., add `google-services` plugin, specify `applicationId`).
    *   **iOS:** Configure your `ios/Runner/Info.plist` and `ios/Runner.xcodeproj` for Google Sign-In (e.g., add `REVERSED_CLIENT_ID`, URL Schemes).
    *   **Web:** Ensure your `index.html` includes the Google Sign-In script.

### 3. Implement Google Sign-In in Flutter
*   **Authentication Screen:** Modify your existing authentication screen (e.g., `lib/screens/auth/auth_screen.dart`) or create a new one to include a "Sign in with Google" button.
*   **Google Sign-In Logic:**
    *   When the button is pressed, use the `google_sign_in` package to initiate the Google sign-in flow.
    *   Obtain the Google ID Token and Access Token from the successful sign-in.
*   **Supabase Integration:**
    *   Use `supabase.auth.signInWithOAuth(Provider.google, ...)` passing the obtained Google tokens. Supabase will handle the registration or login process.

### 4. Handle Authentication State
*   **Listen for Auth Changes:** Implement a listener for Supabase authentication state changes (e.g., `supabase.auth.onAuthStateChange`).
*   **Redirection:** Upon successful authentication, redirect the user to the main application screen (e.g., `lib/screens/home/home_screen.dart`).
*   **Error Handling:** Display appropriate error messages to the user if the sign-in process fails.

### 5. Testing
*   **Cross-Platform Testing:** Test the entire "Sign in with Google" flow on Android, iOS, and Web platforms.
*   **User Scenarios:** Verify both new user registration and existing user login through Google.
*   **Edge Cases:** Test scenarios like network interruptions, user cancellation, and invalid credentials.

## Authentication Flow Diagram

```mermaid
graph TD
    A[User Clicks "Sign in with Google"] --> B{Flutter App Initiates Google Sign-In};
    B --> C[Google Authentication Flow];
    C -- User Authenticates --> D[Google Returns Credentials to Flutter App];
    D --> E{Flutter App Calls Supabase signInWithOAuth};
    E --> F[Supabase Authenticates with Google];
    F -- Success --> G[Supabase Returns Session to Flutter App];
    G --> H[Flutter App Updates Auth State];
    H --> I[User Redirected to Home Screen];
    F -- Failure --> J[Supabase Returns Error];
    J --> K[Flutter App Displays Error];