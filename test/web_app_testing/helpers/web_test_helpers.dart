import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/main.dart';
import 'package:online_course/services/supabase_service.dart';
import 'mock_data.dart';
import 'test_reporter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Browser types for cross-browser testing
enum BrowserType { chrome, firefox, safari }

/// Screen sizes for responsive testing
enum ScreenSize {
  mobile(Size(320, 568)),
  tablet(Size(768, 1024)),
  desktop(Size(1024, 768));

  const ScreenSize(this.size);
  final Size size;
}

/// Web-specific testing utilities for browser simulation and common operations
class WebTestHelper {
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration shortTimeout = Duration(seconds: 3);
  static const Duration longTimeout = Duration(seconds: 30);

  /// Initialize test environment with proper setup
  static Future<void> initializeTestEnvironment() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Load empty environment to satisfy dotenv access
    if (!dotenv.isInitialized) {
      dotenv.testLoad(fileInput: '');
    }

    // Skip real Supabase initialization in web tests to avoid network calls.
    // The app code that relies on Supabase is mocked via provider overrides.

    // Clear any existing test data
    await MockDataProvider.clearTestData();
  }

  /// Create a test app wrapper with providers and routing
  static Widget createTestApp({
    Widget? home,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        title: 'BizLevel Test',
        home: home ?? MyApp(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// Simulate browser environment with specific screen size
  static Future<void> setBrowserEnvironment(
    WidgetTester tester, {
    BrowserType browser = BrowserType.chrome,
    ScreenSize screenSize = ScreenSize.desktop,
  }) async {
    // Set screen size
    await tester.binding.setSurfaceSize(screenSize.size);

    // Add browser-specific behavior simulation
    switch (browser) {
      case BrowserType.chrome:
        // Chrome-specific setup
        break;
      case BrowserType.firefox:
        // Firefox-specific setup
        break;
      case BrowserType.safari:
        // Safari-specific setup
        break;
    }
  }

  /// Wait for widget to appear with timeout
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = defaultTimeout,
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));

      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }

    throw TimeoutException(
      'Widget not found within timeout: ${finder.description}',
      timeout,
    );
  }

  /// Wait for navigation to complete
  static Future<void> waitForNavigation(
    WidgetTester tester, {
    Duration timeout = defaultTimeout,
  }) async {
    await tester.pumpAndSettle(timeout);
  }

  /// Simulate network delay
  static Future<void> simulateNetworkDelay({
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(delay);
  }

  /// Simulate slow network conditions
  static Future<void> simulateSlowNetwork(
    WidgetTester tester,
    Future<void> Function() action,
  ) async {
    // Add network delay before action
    await simulateNetworkDelay(delay: const Duration(seconds: 2));
    await action();
    await tester.pumpAndSettle();
  }

  /// Take screenshot for test documentation
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String testName, {
    String? description,
  }) async {
    // In a real implementation, this would capture actual screenshots
    // For now, we'll log the screenshot request
    TestReporter.logScreenshot(testName, description);
  }

  /// Verify element is visible on screen
  static void verifyElementVisible(Finder finder) {
    expect(finder, findsOneWidget);

    final element = finder.evaluate().first;
    final renderObject = element.renderObject;

    if (renderObject != null) {
      expect(renderObject.paintBounds.isEmpty, false,
          reason: 'Element should be visible on screen');
    }
  }

  /// Verify element is clickable
  static Future<void> verifyElementClickable(
    WidgetTester tester,
    Finder finder,
  ) async {
    verifyElementVisible(finder);

    // Attempt to tap the element
    await tester.tap(finder);
    await tester.pump();
  }

  /// Simulate user input with realistic delays
  static Future<void> enterTextSlowly(
    WidgetTester tester,
    Finder finder,
    String text, {
    Duration delayBetweenChars = const Duration(milliseconds: 50),
  }) async {
    await tester.tap(finder);
    await tester.pump();

    for (int i = 0; i < text.length; i++) {
      await tester.enterText(finder, text.substring(0, i + 1));
      await tester.pump();
      await Future.delayed(delayBetweenChars);
    }
  }

  /// Verify loading states
  static void verifyLoadingState(Finder finder) {
    expect(finder, findsOneWidget);
    // Additional loading state verification can be added here
  }

  /// Verify error states
  static void verifyErrorState(Finder finder, String expectedError) {
    expect(finder, findsOneWidget);
    expect(find.text(expectedError), findsOneWidget);
  }

  /// Clean up test environment
  static Future<void> cleanupTestEnvironment() async {
    await MockDataProvider.clearTestData();
  }

  /// Simulate page refresh
  static Future<void> simulatePageRefresh(WidgetTester tester) async {
    // Simulate browser refresh by rebuilding the widget tree
    await tester.pumpWidget(Container());
    await tester.pump();
  }

  /// Verify responsive behavior
  static Future<void> verifyResponsiveBehavior(
    WidgetTester tester,
    Widget app,
    List<ScreenSize> screenSizes,
  ) async {
    for (final screenSize in screenSizes) {
      await setBrowserEnvironment(tester, screenSize: screenSize);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Verify layout adapts to screen size
      // This can be customized based on specific responsive requirements
    }
  }
}

/// Custom exception for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  const TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}
