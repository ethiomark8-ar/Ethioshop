import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethioshop/presentation/providers/cart_provider.dart';
import 'package:ethioshop/domain/entities/product.dart';
import '../test_config.dart';

void main() {
  group('Cart Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with empty cart', () {
      final cart = container.read(cartProvider);
      expect(cart.items, isEmpty);
      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0);
    });

    test('should add product to cart', () {
      final mockProductData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 100.00,
      );
      final product = Product.fromJson(mockProductData);

      container.read(cartProvider.notifier).addProduct(product);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items.first.product.name, 'Test Product');
      expect(cart.totalItems, 1);
      expect(cart.totalPrice, 100.00);
    });

    test('should update quantity when adding same product', () {
      final mockProductData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 100.00,
        id: 'test-id',
      );
      final product = Product.fromJson(mockProductData);

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).addProduct(product);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.totalItems, 2);
      expect(cart.totalPrice, 200.00);
    });

    test('should remove product from cart', () {
      final mockProductData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 100.00,
        id: 'test-id',
      );
      final product = Product.fromJson(mockProductData);

      container.read(cartProvider.notifier).addProduct(product);
      expect(container.read(cartProvider).items.length, 1);

      container.read(cartProvider.notifier).removeProduct('test-id');
      
      final cart = container.read(cartProvider);
      expect(cart.items, isEmpty);
    });

    test('should update product quantity', () {
      final mockProductData = MockDataGenerators.generateMockProduct(
        name: 'Test Product',
        price: 100.00,
        id: 'test-id',
      );
      final product = Product.fromJson(mockProductData);

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).updateQuantity('test-id', 5);

      final cart = container.read(cartProvider);
      expect(cart.items.first.quantity, 5);
      expect(cart.totalPrice, 500.00);
    });

    test('should calculate total correctly with multiple products', () {
      final product1 = Product.fromJson(
        MockDataGenerators.generateMockProduct(name: 'Product 1', price: 100.00, id: 'id1'),
      );
      final product2 = Product.fromJson(
        MockDataGenerators.generateMockProduct(name: 'Product 2', price: 200.00, id: 'id2'),
      );

      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product2);
      container.read(cartProvider.notifier).addProduct(product1);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 2);
      expect(cart.totalItems, 3);
      expect(cart.totalPrice, 400.00);
    });

    test('should clear cart', () {
      final product = Product.fromJson(
        MockDataGenerators.generateMockProduct(name: 'Test Product', price: 100.00, id: 'test-id'),
      );

      container.read(cartProvider.notifier).addProduct(product);
      expect(container.read(cartProvider).items.length, 1);

      container.read(cartProvider.notifier).clearCart();
      
      final cart = container.read(cartProvider);
      expect(cart.items, isEmpty);
    });
  });
}