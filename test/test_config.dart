import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Test helper functions and utilities
class TestHelpers {
  /// Creates a test widget with provider container
  static Widget createTestWidget({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Creates a test widget with theme
  static Widget createThemedTestWidget({
    required Widget child,
    ThemeData? theme,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: theme,
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Wait for animations to complete
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    await tester.pumpAndSettle(duration);
  }

  /// Pump widget with default duration
  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pump(duration);
  }

  /// Find widget by type with optional finder
  static Finder findWidgetByType<T extends Widget>() {
    return find.byType(T);
  }

  /// Find widget by key
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Find widget by text
  static Finder findWidgetByText(String text) {
    return find.text(text);
  }

  /// Tap widget safely
  static Future<void> safeTap(
    WidgetTester tester,
    Finder finder, {
    bool warnIfMissed = true,
  }) async {
    try {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    } catch (e) {
      if (warnIfMissed) {
        debugPrint('Warning: Could not tap widget: $e');
      }
    }
  }

  /// Enter text into text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Scroll into view
  static Future<void> scrollTo(
    WidgetTester tester,
    Finder finder, {
    double delta = 100.0,
  }) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }
}

/// Mock data generators for testing
class MockDataGenerators {
  /// Generate mock product
  static Map<String, dynamic> generateMockProduct({
    String id = 'test_product_1',
    String name = 'Test Product',
    double price = 1000.0,
  }) {
    return {
      'id': id,
      'name': name,
      'description': 'Test product description',
      'price': price,
      'imageUrl': 'https://example.com/image.jpg',
      'sellerId': 'seller_1',
      'categoryId': 'category_1',
      'rating': 4.5,
      'reviewCount': 10,
      'stock': 100,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Generate mock user
  static Map<String, dynamic> generateMockUser({
    String id = 'test_user_1',
    String name = 'Test User',
    String email = 'test@example.com',
  }) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': '+251912345678',
      'role': 'user',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Generate mock order
  static Map<String, dynamic> generateMockOrder({
    String id = 'test_order_1',
    String userId = 'user_1',
    String status = 'pending',
  }) {
    return {
      'id': id,
      'userId': userId,
      'items': [],
      'totalAmount': 1000.0,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

/// Custom test matchers
class CustomMatchers {
  /// Matcher for Ethiopian phone numbers
  static Matcher isValidEthiopianPhone() {
    return predicate<String>((phone) {
      return RegExp(r'^(\+251|0)(9|7)\d{8}$').hasMatch(phone);
    });
  }

  /// Matcher for ETB currency format
  static Matcher isValidETBCurrency() {
    return predicate<String>((amount) {
      return RegExp(r'^Br\d+(\.\d{2})?$').hasMatch(amount);
    });
  }
}