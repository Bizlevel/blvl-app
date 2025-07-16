import 'package:online_course/models/user_model.dart';
import 'package:online_course/models/level_model.dart';
import 'package:online_course/models/lesson_model.dart';

/// Provides consistent test data across all web testing scenarios
class MockDataProvider {
  // Test user accounts
  static const String testUserEmail = 'test@bizlevel.kz';
  static const String testUserPassword = 'TestPassword123!';
  static const String newUserEmail = 'newuser@bizlevel.kz';
  static const String newUserPassword = 'NewPassword123!';
  static const String returningUserEmail = 'returning@bizlevel.kz';
  static const String returningUserPassword = 'ReturningPassword123!';

  /// Create mock user for testing
  static UserModel createMockUser({
    String? id,
    String? email,
    String? name,
    bool onboardingCompleted = false,
    int currentLevel = 1,
  }) {
    return UserModel(
      id: id ?? 'test-user-id',
      email: email ?? testUserEmail,
      name: name ?? 'Test User',
      onboardingCompleted: onboardingCompleted,
      currentLevel: currentLevel,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create mock new user (no onboarding completed)
  static UserModel createMockNewUser() {
    return createMockUser(
      id: 'new-user-id',
      email: newUserEmail,
      name: 'New User',
      onboardingCompleted: false,
      currentLevel: 1,
    );
  }

  /// Create mock returning user (onboarding completed)
  static UserModel createMockReturningUser() {
    return createMockUser(
      id: 'returning-user-id',
      email: returningUserEmail,
      name: 'Returning User',
      onboardingCompleted: true,
      currentLevel: 3,
    );
  }

  /// Create mock levels for testing
  static List<LevelModel> createMockLevels() {
    return List.generate(30, (index) {
      final levelNumber = index + 1;
      return LevelModel(
        id: levelNumber,
        number: levelNumber,
        title: 'Level $levelNumber: Business Fundamentals',
        description: 'Learn essential business concepts in level $levelNumber',
        imageUrl: 'https://example.com/level-$levelNumber.jpg',
        isFree: levelNumber <= 3, // First 3 levels are free
        artifactTitle: 'Business Toolkit $levelNumber',
        artifactDescription: 'Essential tools for level $levelNumber',
        artifactUrl: 'https://example.com/artifact-$levelNumber.pdf',
        createdAt: DateTime.now(),
      );
    });
  }

  /// Create mock lessons for a specific level
  static List<LessonModel> createMockLessonsForLevel(int levelNumber) {
    return [
      // Text description lesson
      LessonModel(
        id: levelNumber * 10 + 1,
        levelId: levelNumber,
        order: 1,
        title: 'Introduction to Level $levelNumber',
        description: 'This is the text description for level $levelNumber. '
            'It provides an overview of what you will learn in this level.',
        videoUrl: null,
        vimeoId: null,
        durationMinutes: 2,
        quizQuestions: [],
        correctAnswers: [],
        createdAt: DateTime.now(),
      ),
      
      // Video lesson
      LessonModel(
        id: levelNumber * 10 + 2,
        levelId: levelNumber,
        order: 2,
        title: 'Video: Core Concepts',
        description: 'Watch this video to learn core concepts for level $levelNumber',
        videoUrl: 'https://example.com/video-$levelNumber.mp4',
        vimeoId: 'vimeo-$levelNumber',
        durationMinutes: 5,
        quizQuestions: [],
        correctAnswers: [],
        createdAt: DateTime.now(),
      ),
      
      // Quiz lesson
      LessonModel(
        id: levelNumber * 10 + 3,
        levelId: levelNumber,
        order: 3,
        title: 'Quiz: Test Your Knowledge',
        description: 'Test your understanding of level $levelNumber concepts',
        videoUrl: null,
        vimeoId: null,
        durationMinutes: 3,
        quizQuestions: [
          {
            'question': 'What is the most important aspect of business planning?',
            'options': [
              'Market research',
              'Financial planning', 
              'Team building',
              'Product development'
            ]
          }
        ],
        correctAnswers: [0],
        createdAt: DateTime.now(),
      ),
    ];
  }

  /// Create mock quiz content
  static String createMockQuizContent() {
    return '''
    {
      "question": "What is the most important aspect of business planning?",
      "options": [
        "Market research",
        "Financial planning", 
        "Team building",
        "Product development"
      ],
      "correctAnswer": 0,
      "hint": "Understanding your market is crucial for business success"
    }
    ''';
  }

  /// Create mock progress state
  static Map<String, dynamic> createMockProgressState({
    int currentLevel = 1,
    int currentLesson = 1,
    List<String> completedLessons = const [],
    List<String> watchedVideos = const [],
    List<String> passedQuizzes = const [],
  }) {
    return {
      'currentLevel': currentLevel,
      'currentLesson': currentLesson,
      'completedLessons': completedLessons,
      'watchedVideos': watchedVideos,
      'passedQuizzes': passedQuizzes,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// Create mock Leo chat messages
  static List<Map<String, dynamic>> createMockLeoMessages() {
    return [
      {
        'id': 'msg-1',
        'content': 'Hello! I\'m Leo, your AI business mentor. How can I help you today?',
        'isFromUser': false,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      },
      {
        'id': 'msg-2',
        'content': 'I need help understanding business planning',
        'isFromUser': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 4)).toIso8601String(),
      },
      {
        'id': 'msg-3',
        'content': 'Great question! Based on your progress in Level 1, I can see you\'re learning about business fundamentals. Let me explain the key components of business planning...',
        'isFromUser': false,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 3)).toIso8601String(),
      },
    ];
  }

  /// Authentication test data
  static Map<String, String> get validLoginCredentials => {
    'email': testUserEmail,
    'password': testUserPassword,
  };

  static Map<String, String> get invalidLoginCredentials => {
    'email': 'invalid@example.com',
    'password': 'wrongpassword',
  };

  static Map<String, String> get newUserRegistrationData => {
    'email': newUserEmail,
    'password': newUserPassword,
    'name': 'New Test User',
  };

  /// Video test data
  static const String mockVideoUrl = 'https://example.com/test-video.mp4';
  static const Duration mockVideoDuration = Duration(minutes: 5, seconds: 30);
  static const Duration requiredWatchTime = Duration(seconds: 5);

  /// Quiz test data
  static Map<String, dynamic> get mockQuizData => {
    'question': 'What is the primary goal of market research?',
    'options': [
      'To understand customer needs',
      'To increase sales immediately',
      'To reduce costs',
      'To hire more employees'
    ],
    'correctAnswer': 0,
    'hint': 'Think about what information businesses need about their customers',
  };

  /// Error messages for testing
  static const String authenticationError = 'Invalid email or password';
  static const String networkError = 'Network connection failed';
  static const String videoLoadError = 'Failed to load video content';
  static const String quizSubmissionError = 'Failed to submit quiz answer';

  /// Test environment URLs
  static const String testBaseUrl = 'http://localhost:3000';
  static const String testSupabaseUrl = 'https://test.supabase.co';

  /// Clear all test data (for cleanup)
  static Future<void> clearTestData() async {
    // In a real implementation, this would clear test database
    // For now, we'll just simulate the cleanup
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Setup test data in database
  static Future<void> setupTestData() async {
    // In a real implementation, this would populate test database
    // with mock users, levels, and lessons
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Create test user session
  static Map<String, dynamic> createMockSession({
    String? userId,
    String? email,
    bool isAuthenticated = true,
  }) {
    return {
      'user': {
        'id': userId ?? 'test-user-id',
        'email': email ?? testUserEmail,
        'created_at': DateTime.now().toIso8601String(),
      },
      'access_token': 'mock-access-token',
      'refresh_token': 'mock-refresh-token',
      'expires_at': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
      'token_type': 'bearer',
    };
  }
}