import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/failures/failure.dart';
import '../../core/constants/app_constants.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  throw UnimplementedError('CartRepository not implemented');
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(cartRepositoryProvider));
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.read(cartRepositoryProvider).cartTotal;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.read(cartRepositoryProvider).cartItemCount;
});

class CartState {
  final List<CartItemEntity> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CartState copyWith({
    List<CartItemEntity>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => subtotal >= AppConstants.freeDeliveryThreshold 
      ? 0.0 
      : AppConstants.standardDeliveryFee;
  double get total => subtotal + deliveryFee;
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getCartItems();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (items) {
        state = state.copyWith(
          items: items,
          isLoading: false,
        );
      },
    );
  }

  Future<void> addToCart({
    required String productId,
    required String name,
    required String description,
    required String image,
    required double price,
    required String category,
    required int availableStock,
    required String sellerId,
    required String sellerName,
  }) async {
    final result = await _repository.addToCart(
      productId: productId,
      name: name,
      description: description,
      image: image,
      price: price,
      category: category,
      availableStock: availableStock,
      sellerId: sellerId,
      sellerName: sellerName,
    );

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadCart();
      },
    );
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final result = await _repository.updateCartItemQuantity(
      productId: productId,
      quantity: quantity,
    );

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadCart();
      },
    );
  }

  Future<void> removeFromCart(String productId) async {
    final result = await _repository.removeFromCart(productId);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadCart();
      },
    );
  }

  Future<void> clearCart() async {
    final result = await _repository.clearCart();

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        state = state.copyWith(items: []);
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}