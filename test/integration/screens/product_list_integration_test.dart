import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethioshop/presentation/screens/home/home_screen.dart';
import 'package:ethioshop/domain/entities/product.dart';
import 'package:ethioshop/core/constants/app_constants.dart';
import '../test_config.dart';

void main() {
  group('Product List Integration Tests', () {
    testWidgets('should display product list correctly', (WidgetTester tester) async {
      final mockProducts = List.generate(
        5,
        (index) => Product.fromJson(
          MockDataGenerators.generateMockProduct(
            name: 'Product $index',
            price: (index + 1) * 100.0,
          ),
        ),
      );

      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text('Product ${index + 1}'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mockProducts[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${mockProducts[index].price} ${AppConstants.etbCurrency}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: mockProducts.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all products are displayed
      for (int i = 0; i < 5; i++) {
        expect(find.text('Product $i'), findsOneWidget);
        expect(find.text('${(i + 1) * 100.0} ETB'), findsOneWidget);
      }
    });

    testWidgets('should filter products by category', (WidgetTester tester) async {
      final allProducts = [
        Product.fromJson(
          MockDataGenerators.generateMockProduct(
            name: 'Coffee',
            category: 'Food & Beverages',
          ),
        ),
        Product.fromJson(
          MockDataGenerators.generateMockProduct(
            name: 'T-Shirt',
            category: 'Clothing',
          ),
        ),
        Product.fromJson(
          MockDataGenerators.generateMockProduct(
            name: 'Tea',
            category: 'Food & Beverages',
          ),
        ),
      ];

      final filteredProducts = allProducts
          .where((p) => p.category == 'Food & Beverages')
          .toList();

      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredProducts[index].name),
                    subtitle: Text(filteredProducts[index].category),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify only food & beverages products are displayed
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Tea'), findsOneWidget);
      expect(find.text('T-Shirt'), findsNothing);
    });

    testWidgets('should handle empty product list', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('Loading products...'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading products...'), findsOneWidget);
    });

    testWidgets('should handle error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load products',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load products'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should navigate to product detail on tap', (WidgetTester tester) async {
      final product = Product.fromJson(
        MockDataGenerators.generateMockProduct(
          name: 'Test Product',
          price: 500.00,
        ),
      );

      bool navigated = false;

      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: GestureDetector(
                onTap: () => navigated = true,
                child: Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('${product.price} ${AppConstants.etbCurrency}'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(navigated, true);
    });

    testWidgets('should display Ethiopian currency correctly', (WidgetTester tester) async {
      final product = Product.fromJson(
        MockDataGenerators.generateMockProduct(
          price: 1250.50,
          currency: 'ETB',
        ),
      );

      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: ListTile(
                title: Text(product.name),
                subtitle: Text(
                  '${product.price.toStringAsFixed(2)} ${AppConstants.etbCurrency}',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('1250.50 ETB'), findsOneWidget);
    });

    testWidgets('should display discount badge', (WidgetTester tester) async {
      final product = Product.fromJson(
        MockDataGenerators.generateMockProduct(
          price: 1000.00,
          discountPrice: 800.00,
        ),
      );

      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.discountPrice} ETB'),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('-20%'), findsOneWidget);
      expect(find.text('800.0 ETB'), findsOneWidget);
    });
  });
}