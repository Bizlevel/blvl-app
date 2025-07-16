# BizLevel - Technical Stack

## Framework & Language
- **Flutter 3.0+** with Dart SDK >=3.0.0 <4.0.0
- **Target Platforms**: iOS, Android, Web
- **Architecture**: Provider pattern with Riverpod for state management

## Key Dependencies

### State Management & Architecture
- `flutter_riverpod: ^2.4.0` - State management and dependency injection
- `freezed: ^2.4.1` + `json_annotation: ^4.9.0` - Immutable data classes and JSON serialization

### Backend & Services
- `supabase_flutter: ^2.3.0` - Backend as a Service (authentication, database, storage)
- `dio: ^5.4.0` - HTTP client for API calls
- `flutter_dotenv: ^5.0.2` - Environment variable management

### UI & Media
- `flutter_svg: ^2.2.0` - SVG icon rendering
- `cached_network_image: ^3.4.1` - Image caching and loading
- `video_player: ^2.8.1` + `chewie: ^1.7.0` - Video playback
- `flutter_animate: ^4.3.0` - Animations
- `responsive_framework: ^0.2.0` - Responsive design
- `shimmer: ^2.0.0` - Loading placeholders

### Monitoring & Analytics
- `sentry_flutter: ^9.4.1` - Error tracking and performance monitoring
- `package_info_plus: ^4.2.0` - App version info

### Utilities
- `shared_preferences: ^2.2.2` - Local storage
- `url_launcher: ^6.2.2` - External URL handling
- `webview_flutter: ^3.0.4` - In-app web views

## Environment Configuration
Environment variables stored in `.env` file:
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `OPENAI_API_KEY` - OpenAI API key for Leo AI mentor
- `sentry_dsn` - Sentry error tracking DSN

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run code generation (for Freezed models)
flutter packages pub run build_runner build

# Run app in debug mode
flutter run

# Run on specific device
flutter run -d chrome  # Web
flutter run -d ios     # iOS Simulator
flutter run -d android # Android Emulator
```

### Build & Deploy
```bash
# Build for production
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS
flutter build web --release          # Web

# Clean build cache
flutter clean && flutter pub get
```

### Code Generation
```bash
# Generate Freezed models and JSON serialization
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter packages pub run build_runner watch
```

## Architecture Patterns
- **MVVM**: Models, Views, ViewModels with Riverpod providers
- **Repository Pattern**: Service layer abstraction (SupabaseService)
- **Immutable State**: Freezed data classes for type safety
- **Error Handling**: Centralized error tracking with Sentry