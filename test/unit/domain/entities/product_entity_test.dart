import 'package:flutter_test/flutter_test.dart';
import 'package:ethioshop/domain/entities/product.dart';
import 'package:ethioshop/domain/entities/user.dart';
import '../test_config.dart';

void main() {
  group('Product Entity Tests', () {
    test('should create product from valid JSON', () {
      final mockData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 500.00,
      );

      final product = Product.fromJson(mockData);

      expect(product.id, mockData['id']);
      expect(product.name, 'Test Product');
      expect(product.price, 500.00);
      expect(product.description, isNotEmpty);
      expect(product.images, isNotEmpty);
      expect(product.category, isNotEmpty);
      expect(product.sellerId, isNotEmpty);
    });

    test('should create product with discount', () {
      final mockData = MockDataGenerators.generateMockProduct(
        price: 1000.00,
        discountPrice: 800.00,
      );

      final product = Product.fromJson(mockData);

      expect(product.price, 1000.00);
      expect(product.discountPrice, 800.00);
      expect(product.discountPercentage, 20);
    });

    test('should calculate discount percentage correctly', () {
      final mockData = MockDataGenerators.generateMockProduct(
        price: 500.00,
        discountPrice: 400.00,
      );

      final product = Product.fromJson(mockData);

      expect(product.discountPercentage, 20);
    });

    test('should convert product to JSON', () {
      final mockData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 500.00,
      );
      final product = Product.fromJson(mockData);

      final json = product.toJson();

      expect(json['id'], product.id);
      expect(json['name'], 'Test Product');
      expect(json['price'], 500.00);
      expect(json['category'], isNotEmpty);
    });

    test('should handle empty images list', () {
      final mockData = MockDataGenerators.generateMockProduct();
      mockData['images'] = [];

      final product = Product.fromJson(mockData);

      expect(product.images, isEmpty);
    });

    test('should create product with all Ethiopian features', () {
      final mockData = MockDataGenerators.generateMockProduct(
        region: 'Addis Ababa',
        city: 'Addis Ababa',
      );

      final product = Product.fromJson(mockData);

      expect(product.region, 'Addis Ababa');
      expect(product.city, 'Addis Ababa');
    });

    test('should handle rating calculation', () {
      final mockData = MockDataGenerators.generateMockProduct(
        rating: 4.5,
        reviewCount: 100,
      );

      final product = Product.fromJson(mockData);

      expect(product.rating, 4.5);
      expect(product.reviewCount, 100);
    });

    test('should handle stock management', () {
      final mockData = MockDataGenerators.generateMockProduct(
        stock: 50,
      );

      final product = Product.fromJson(mockData);

      expect(product.stock, 50);
      expect(product.inStock, true);
    });

    test('should detect out of stock', () {
      final mockData = MockDataGenerators.generateMockProduct(
        stock: 0,
      );

      final product = Product.fromJson(mockData);

      expect(product.stock, 0);
      expect(product.inStock, false);
    });

    test('should create product with seller info', () {
      final mockData = MockDataGenerators.generateMockProduct();
      final product = Product.fromJson(mockData);

      expect(product.sellerId, isNotEmpty);
      expect(product.sellerName, isNotNull);
    });
  });
}