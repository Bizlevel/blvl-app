import 'dart:convert';
import 'dart:io';

/// Issue severity levels
enum IssueSeverity { critical, high, medium, low }

/// Test result status
enum TestStatus { passed, failed, skipped }

/// Handles issue tracking and test result documentation
class TestReporter {
  static final List<TestIssue> _issues = [];
  static final List<TestResult> _results = [];
  static final List<String> _screenshots = [];

  /// Record a test issue
  static void reportIssue({
    required String title,
    required String description,
    required IssueSeverity severity,
    required String component,
    required List<String> stepsToReproduce,
    String? screenshot,
    Map<String, dynamic>? environment,
  }) {
    final issue = TestIssue(
      id: 'issue-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      severity: severity,
      component: component,
      stepsToReproduce: stepsToReproduce,
      screenshot: screenshot,
      environment: environment ?? _getCurrentEnvironment(),
      timestamp: DateTime.now(),
    );

    _issues.add(issue);
    _logIssue(issue);
  }

  /// Record a test result
  static void recordTestResult({
    required String testName,
    required TestStatus status,
    String? errorMessage,
    List<String> steps = const [],
    String browser = 'chrome',
    String screenSize = '1024x768',
    Duration? duration,
  }) {
    final result = TestResult(
      testName: testName,
      status: status,
      errorMessage: errorMessage,
      steps: steps,
      browser: browser,
      screenSize: screenSize,
      duration: duration,
      timestamp: DateTime.now(),
    );

    _results.add(result);
    _logTestResult(result);
  }

  /// Log screenshot capture
  static void logScreenshot(String testName, String? description) {
    final screenshotInfo = 'Screenshot: $testName${description != null ? ' - $description' : ''}';
    _screenshots.add(screenshotInfo);
    print('📸 $screenshotInfo');
  }

  /// Generate comprehensive test report
  static Future<String> generateReport() async {
    final report = StringBuffer();
    
    // Header
    report.writeln('# BizLevel Web App Test Report');
    report.writeln('Generated: ${DateTime.now().toIso8601String()}');
    report.writeln('');

    // Summary
    report.writeln('## Test Summary');
    report.writeln('- Total Tests: ${_results.length}');
    report.writeln('- Passed: ${_results.where((r) => r.status == TestStatus.passed).length}');
    report.writeln('- Failed: ${_results.where((r) => r.status == TestStatus.failed).length}');
    report.writeln('- Skipped: ${_results.where((r) => r.status == TestStatus.skipped).length}');
    report.writeln('- Total Issues: ${_issues.length}');
    report.writeln('');

    // Issues by severity
    report.writeln('## Issues by Severity');
    for (final severity in IssueSeverity.values) {
      final count = _issues.where((i) => i.severity == severity).length;
      report.writeln('- ${severity.name.toUpperCase()}: $count');
    }
    report.writeln('');

    // Detailed issues
    if (_issues.isNotEmpty) {
      report.writeln('## Detailed Issues');
      for (final issue in _issues) {
        report.writeln('### ${issue.title}');
        report.writeln('**ID:** ${issue.id}');
        report.writeln('**Severity:** ${issue.severity.name.toUpperCase()}');
        report.writeln('**Component:** ${issue.component}');
        report.writeln('**Description:** ${issue.description}');
        report.writeln('');
        report.writeln('**Steps to Reproduce:**');
        for (int i = 0; i < issue.stepsToReproduce.length; i++) {
          report.writeln('${i + 1}. ${issue.stepsToReproduce[i]}');
        }
        report.writeln('');
        if (issue.environment.isNotEmpty) {
          report.writeln('**Environment:**');
          issue.environment.forEach((key, value) {
            report.writeln('- $key: $value');
          });
          report.writeln('');
        }
        report.writeln('---');
        report.writeln('');
      }
    }

    // Test results
    if (_results.isNotEmpty) {
      report.writeln('## Test Results');
      for (final result in _results) {
        final statusIcon = _getStatusIcon(result.status);
        report.writeln('$statusIcon **${result.testName}**');
        report.writeln('- Status: ${result.status.name.toUpperCase()}');
        report.writeln('- Browser: ${result.browser}');
        report.writeln('- Screen Size: ${result.screenSize}');
        if (result.duration != null) {
          report.writeln('- Duration: ${result.duration!.inMilliseconds}ms');
        }
        if (result.errorMessage != null) {
          report.writeln('- Error: ${result.errorMessage}');
        }
        report.writeln('');
      }
    }

    // Screenshots
    if (_screenshots.isNotEmpty) {
      report.writeln('## Screenshots Captured');
      for (final screenshot in _screenshots) {
        report.writeln('- $screenshot');
      }
      report.writeln('');
    }

    return report.toString();
  }

  /// Save report to file
  static Future<void> saveReportToFile([String? filename]) async {
    final report = await generateReport();
    final file = File(filename ?? 'test_report_${DateTime.now().millisecondsSinceEpoch}.md');
    await file.writeAsString(report);
    print('📄 Test report saved to: ${file.path}');
  }

  /// Export issues as JSON
  static Future<void> exportIssuesAsJson([String? filename]) async {
    final issuesJson = _issues.map((issue) => issue.toJson()).toList();
    final file = File(filename ?? 'test_issues_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(issuesJson));
    print('📋 Issues exported to: ${file.path}');
  }

  /// Clear all recorded data
  static void clearAll() {
    _issues.clear();
    _results.clear();
    _screenshots.clear();
  }

  /// Get current environment information
  static Map<String, dynamic> _getCurrentEnvironment() {
    return {
      'platform': Platform.operatingSystem,
      'dart_version': Platform.version,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Log issue to console
  static void _logIssue(TestIssue issue) {
    final severityIcon = _getSeverityIcon(issue.severity);
    print('$severityIcon [${issue.severity.name.toUpperCase()}] ${issue.title}');
    print('   Component: ${issue.component}');
    print('   ${issue.description}');
  }

  /// Log test result to console
  static void _logTestResult(TestResult result) {
    final statusIcon = _getStatusIcon(result.status);
    print('$statusIcon ${result.testName} (${result.browser}, ${result.screenSize})');
    if (result.errorMessage != null) {
      print('   Error: ${result.errorMessage}');
    }
  }

  /// Get icon for issue severity
  static String _getSeverityIcon(IssueSeverity severity) {
    switch (severity) {
      case IssueSeverity.critical:
        return '🔴';
      case IssueSeverity.high:
        return '🟠';
      case IssueSeverity.medium:
        return '🟡';
      case IssueSeverity.low:
        return '🟢';
    }
  }

  /// Get icon for test status
  static String _getStatusIcon(TestStatus status) {
    switch (status) {
      case TestStatus.passed:
        return '✅';
      case TestStatus.failed:
        return '❌';
      case TestStatus.skipped:
        return '⏭️';
    }
  }

  /// Get all recorded issues
  static List<TestIssue> get issues => List.unmodifiable(_issues);

  /// Get all test results
  static List<TestResult> get results => List.unmodifiable(_results);

  /// Get pass rate percentage
  static double get passRate {
    if (_results.isEmpty) return 0.0;
    final passed = _results.where((r) => r.status == TestStatus.passed).length;
    return (passed / _results.length) * 100;
  }
}

/// Represents a test issue
class TestIssue {
  final String id;
  final String title;
  final String description;
  final IssueSeverity severity;
  final String component;
  final List<String> stepsToReproduce;
  final String? screenshot;
  final Map<String, dynamic> environment;
  final DateTime timestamp;

  TestIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.component,
    required this.stepsToReproduce,
    this.screenshot,
    required this.environment,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity.name,
      'component': component,
      'stepsToReproduce': stepsToReproduce,
      'screenshot': screenshot,
      'environment': environment,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Represents a test result
class TestResult {
  final String testName;
  final TestStatus status;
  final String? errorMessage;
  final List<String> steps;
  final String browser;
  final String screenSize;
  final Duration? duration;
  final DateTime timestamp;

  TestResult({
    required this.testName,
    required this.status,
    this.errorMessage,
    required this.steps,
    required this.browser,
    required this.screenSize,
    this.duration,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'status': status.name,
      'errorMessage': errorMessage,
      'steps': steps,
      'browser': browser,
      'screenSize': screenSize,
      'duration': duration?.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}