import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/failures/failure.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  throw UnimplementedError('WishlistRepository not implemented');
});

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(ref.read(wishlistRepositoryProvider));
});

final isInWishlistProvider = Provider.family<bool, String>((ref, productId) {
  final state = ref.watch(wishlistProvider);
  return state.productIds.contains(productId);
});

class WishlistState {
  final List<ProductEntity> products;
  final Set<String> productIds;
  final bool isLoading;
  final String? errorMessage;

  const WishlistState({
    this.products = const [],
    this.productIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  WishlistState copyWith({
    List<ProductEntity>? products,
    Set<String>? productIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WishlistState(
      products: products ?? this.products,
      productIds: productIds ?? this.productIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepository _repository;

  WishlistNotifier(this._repository) : super(const WishlistState()) {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getWishlist();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (products) {
        final ids = products.map((p) => p.id).toSet();
        state = state.copyWith(
          products: products,
          productIds: ids,
          isLoading: false,
        );
      },
    );
  }

  Future<void> addToWishlist(String productId) async {
    final result = await _repository.addToWishlist(productId);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadWishlist();
      },
    );
  }

  Future<void> removeFromWishlist(String productId) async {
    final result = await _repository.removeFromWishlist(productId);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadWishlist();
      },
    );
  }

  Future<void> toggleWishlist(String productId) async {
    final result = await _repository.toggleWishlist(productId);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        loadWishlist();
      },
    );
  }

  Future<void> clearWishlist() async {
    final result = await _repository.clearWishlist();

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        state = state.copyWith(products: [], productIds: {});
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}