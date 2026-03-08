import 'package:hive_flutter/hive_flutter.dart';
import 'package:ethioshop/core/utils/constants.dart';
import 'package:ethioshop/domain/entities/cart_item_entity.dart';

/// Hive-based Cart Local Datasource
/// Data layer - Offline-first cart storage using Hive
class CartLocalDatasource {
  late Box<CartItemEntity> _cartBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(AppConstants.boxCart)) {
      _cartBox = await Hive.openBox<CartItemEntity>(AppConstants.boxCart);
    } else {
      _cartBox = Hive.box<CartItemEntity>(AppConstants.boxCart);
    }
  }

  /// Get all cart items
  List<CartItemEntity> getCartItems() {
    return _cartBox.values.toList();
  }

  /// Add item to cart or update if exists
  Future<void> addToCart(CartItemEntity item) async {
    final existingItem = _cartBox.get(item.productId);

    if (existingItem != null) {
      // Update quantity if item exists
      await updateQuantity(
        productId: item.productId,
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item
      await _cartBox.put(item.productId, item);
    }
  }

  /// Update item quantity
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final existingItem = _cartBox.get(productId);

    if (existingItem != null) {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        await removeFromCart(productId);
      } else {
        // Update quantity
        final updatedItem = existingItem.copyWith(quantity: quantity);
        await _cartBox.put(productId, updatedItem);
      }
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String productId) async {
    await _cartBox.delete(productId);
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  /// Get item count in cart
  int get itemCount => _cartBox.length;

  /// Get cart summary
  CartSummary getCartSummary() {
    final items = getCartItems();
    int totalItems = 0;
    double subtotal = 0.0;

    for (final item in items) {
      totalItems += item.quantity;
      subtotal += item.totalPrice;
    }

    return CartSummary(
      totalItems: totalItems,
      totalProducts: items.length,
      subtotal: subtotal,
      tax: 0.0, // Tax will be calculated during checkout
      shipping: 0.0, // Shipping will be calculated during checkout
      total: subtotal, // Total will be calculated during checkout
    );
  }

  /// Check if item exists in cart
  bool containsItem(String productId) {
    return _cartBox.containsKey(productId);
  }

  /// Get item by product ID
  CartItemEntity? getItem(String productId) {
    return _cartBox.get(productId);
  }

  /// Get cart items as map for serialization
  Map<String, dynamic> getCartAsMap() {
    final items = getCartItems();
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'itemCount': itemCount,
      'summary': getCartSummary().toJson(),
    };
  }

  /// Load cart from map
  Future<void> loadCartFromMap(Map<String, dynamic> data) async {
    await clearCart();

    if (data.containsKey('items')) {
      final itemsList = data['items'] as List;
      for (final itemData in itemsList) {
        final item = CartItemEntity.fromJson(Map<String, dynamic>.from(itemData));
        await _cartBox.put(item.productId, item);
      }
    }
  }

  /// Stream cart changes
  Stream<List<CartItemEntity>> watchCart() {
    return _cartBox.watch().map((_) => getCartItems());
  }

  /// Export cart for sync
  List<Map<String, dynamic>> exportCart() {
    return getCartItems().map((item) => item.toJson()).toList();
  }

  /// Import cart from sync
  Future<void> importCart(List<Map<String, dynamic>> cartData) async {
    await clearCart();

    for (final itemData in cartData) {
      final item = CartItemEntity.fromJson(itemData);
      await _cartBox.put(item.productId, item);
    }
  }

  /// Close box
  Future<void> close() async {
    await _cartBox.close();
  }
}