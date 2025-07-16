# BizLevel - Project Structure

## Root Directory Layout
```
├── android/                 # Android platform configuration
├── ios/                     # iOS platform configuration  
├── web/                     # Web platform assets
├── assets/                  # Static assets (icons, images)
├── lib/                     # Main Dart source code
├── test/                    # Unit and integration tests
├── docs/                    # Project documentation
├── supabase/               # Supabase Edge Functions
├── .kiro/                  # Kiro AI assistant configuration
└── pubspec.yaml            # Flutter dependencies
```

## Core Source Structure (`lib/`)
```
lib/
├── main.dart               # App entry point with initialization
├── models/                 # Data models (Freezed classes)
│   ├── user_model.dart
│   ├── level_model.dart
│   └── lesson_model.dart
├── providers/              # Riverpod state providers
│   ├── auth_provider.dart
│   ├── levels_provider.dart
│   └── lessons_provider.dart
├── screens/                # UI screens/pages
│   ├── auth/              # Authentication screens
│   ├── root_app.dart      # Main app with bottom navigation
│   ├── levels_map_screen.dart
│   ├── level_detail_screen.dart
│   └── leo_chat_screen.dart
├── widgets/                # Reusable UI components
│   ├── level_card.dart
│   ├── lesson_widget.dart
│   └── leo_message_bubble.dart
├── services/               # Business logic and API calls
│   ├── supabase_service.dart
│   ├── auth_service.dart
│   └── leo_service.dart
├── theme/                  # App theming and colors
│   └── color.dart
└── utils/                  # Constants and utilities
    ├── constant.dart
    └── data.dart
```

## Assets Organization
```
assets/
├── icons/                  # SVG icons
│   ├── categories/        # Category-specific icons
│   ├── home.svg
│   ├── profile.svg
│   └── chat.svg
└── images/
    └── onboarding/        # Onboarding screen images
```

## Key Architecture Principles

### File Naming Conventions
- **Snake_case** for file names: `level_detail_screen.dart`
- **PascalCase** for class names: `LevelDetailScreen`
- **camelCase** for variables and methods: `currentLevel`

### Model Structure
- Use **Freezed** for immutable data classes
- Include JSON serialization with `json_annotation`
- Generate `.freezed.dart` and `.g.dart` files via build_runner

### Provider Organization
- One provider per feature/domain
- Async providers for data fetching
- Stream providers for real-time updates (auth state)

### Screen Structure
- Each screen is a `ConsumerWidget` (Riverpod)
- Separate complex screens into multiple files if needed
- Use responsive design with `ResponsiveFramework`

### Service Layer
- `SupabaseService` - Database and storage operations
- `AuthService` - Authentication logic
- `LeoService` - AI chat functionality
- Include retry logic and error handling

### Widget Composition
- Small, focused, reusable widgets
- Use composition over inheritance
- Consistent naming: `*Card`, `*Item`, `*Widget`

## Testing Structure
```
test/
├── auth_flow_test.dart           # Authentication flow tests
├── levels_system_test.dart       # Level progression tests
├── leo_integration_test.dart     # AI chat integration tests
└── infrastructure_test.dart      # Backend integration tests
```

## Documentation
- `docs/` contains project specifications and implementation plans
- Russian language documentation for local team
- Markdown format for easy maintenance

## Environment & Configuration
- `.env` file for environment variables (not committed)
- Separate configurations for development/production
- Supabase configuration in `SupabaseService.initialize()`