import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethioshop/presentation/widgets/product_card.dart';
import 'package:ethioshop/domain/entities/product.dart';
import 'package:ethioshop/core/constants/app_constants.dart';
import '../test_config.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Map<String, dynamic> mockProductData;

    setUp(() {
      mockProductData = MockDataGenerators.generateMockProduct(
        name: 'Traditional Ethiopian Coffee',
        price: 450.00,
        currency: AppConstants.etbCurrency,
      );
    });

    testWidgets('should display product name correctly', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(product: product),
        ),
      );

      expect(find.text('Traditional Ethiopian Coffee'), findsOneWidget);
    });

    testWidgets('should display price in ETB', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(product: product),
        ),
      );

      expect(find.text('450 ETB'), findsOneWidget);
    });

    testWidgets('should display category', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(product: product),
        ),
      );

      expect(find.text('Food &amp; Beverages'), findsOneWidget);
    });

    testWidgets('should display discount badge when discount exists', (WidgetTester tester) async {
      mockProductData['discountPrice'] = 400.00;
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(product: product),
        ),
      );

      expect(find.text('-11%'), findsOneWidget);
      expect(find.text('400 ETB'), findsOneWidget);
    });

    testWidgets('should navigate to product detail when tapped', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      bool navigated = false;
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: product,
                onTap: () => navigated = true,
              ),
            ),
          ),
        ),
      );

      await TestHelpers.safeTap(tester, find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(navigated, true);
    });

    testWidgets('should display favorite icon when showFavorite is true', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(
            product: product,
            showFavorite: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display rating when showRating is true', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(
            product: product,
            showRating: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display seller info when showSeller is true', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(
            product: product,
            showSeller: true,
          ),
        ),
      );

      expect(find.text('Test Seller'), findsOneWidget);
    });

    testWidgets('should display location badge when showLocation is true', (WidgetTester tester) async {
      final product = Product.fromJson(mockProductData);
      
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: ProductCard(
            product: product,
            showLocation: true,
          ),
        ),
      );

      expect(find.text('Addis Ababa'), findsOneWidget);
    });
  });
}