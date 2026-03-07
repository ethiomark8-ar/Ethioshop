import 'package:flutter_test/flutter_test.dart';
import 'package:ethioshop/data/models/product_model.dart';
import 'package:ethioshop/domain/entities/product.dart';
import '../test_config.dart';

void main() {
  group('Product Model Tests', () {
    test('should create product model from JSON', () {
      final mockData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 500.00,
      );

      final model = ProductModel.fromJson(mockData);

      expect(model.id, mockData['id']);
      expect(model.name, 'Test Product');
      expect(model.price, 500.00);
      expect(model.description, isNotEmpty);
    });

    test('should convert model to entity', () {
      final mockData = MockDataGenerators.generateMockProduct();
      final model = ProductModel.fromJson(mockData);

      final entity = model.toEntity();

      expect(entity, isA<Product>());
      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.price, model.price);
    });

    test('should convert entity to model', () {
      final mockData = MockDataGenerators.generateMockProduct();
      final entity = Product.fromJson(mockData);

      final model = ProductModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.name, entity.name);
      expect(model.price, entity.price);
    });

    test('should convert model to JSON', () {
      final mockData = MockDataGenerators.generateMockProduct();
      final model = ProductModel.fromJson(mockData);

      final json = model.toJson();

      expect(json['id'], model.id);
      expect(json['name'], model.name);
      expect(json['price'], model.price);
      expect(json['category'], model.category);
    });

    test('should handle Ethiopian currency in JSON', () {
      final mockData = MockDataGenerators.generateMockProduct(
        price: 1000.00,
        currency: 'ETB',
      );
      final model = ProductModel.fromJson(mockData);

      expect(model.currency, 'ETB');
      expect(model.price, 1000.00);
    });

    test('should handle Ethiopian regions', () {
      final regions = [
        'Addis Ababa', 'Afar', 'Amhara', 'Benishangul-Gumuz',
        'Central Ethiopia Region', 'Dire Dawa', 'Gambela',
        'Harari', 'Oromia', 'Sidama', 'Somali',
        'South Ethiopia Region', 'Tigray'
      ];

      for (final region in regions) {
        final mockData = MockDataGenerators.generateMockProduct(region: region);
        final model = ProductModel.fromJson(mockData);

        expect(model.region, region);
      }
    });

    test('should handle discount calculation', () {
      final mockData = MockDataGenerators.generateMockProduct(
        price: 1000.00,
        discountPrice: 750.00,
      );
      final model = ProductModel.fromJson(mockData);

      expect(model.discountPercentage, 25);
    });

    test('should handle stock status', () {
      final inStockData = MockDataGenerators.generateMockProduct(stock: 10);
      final inStockModel = ProductModel.fromJson(inStockData);

      final outOfStockData = MockDataGenerators.generateMockProduct(stock: 0);
      final outOfStockModel = ProductModel.fromJson(outOfStockData);

      expect(inStockModel.inStock, true);
      expect(outOfStockModel.inStock, false);
    });

    test('should handle images array', () {
      final mockData = MockDataGenerators.generateMockProduct();
      final model = ProductModel.fromJson(mockData);

      expect(model.images, isNotEmpty);
      expect(model.images.every((url) => url.startsWith('http')), true);
    });

    test('should handle empty optional fields', () {
      final mockData = {
        'id': 'test-id',
        'name': 'Test Product',
        'price': 100.00,
        'description': 'Test Description',
        'images': ['http://example.com/image.jpg'],
        'category': 'Food & Beverages',
        'sellerId': 'seller-123',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final model = ProductModel.fromJson(mockData);

      expect(model.discountPrice, isNull);
      expect(model.discountPercentage, 0);
      expect(model.stock, 0);
      expect(model.rating, 0.0);
      expect(model.reviewCount, 0);
    });
  });
}