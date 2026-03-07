import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/failures/failure.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  throw UnimplementedError('ProductRepository not implemented');
});

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(ref.read(productRepositoryProvider));
});

final featuredProductsProvider = FutureProvider.autoDispose<List<ProductEntity>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getFeaturedProducts(limit: 10);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

final trendingProductsProvider = FutureProvider.autoDispose<List<ProductEntity>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getTrendingProducts(limit: 10);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

final productByIdProvider = FutureProvider.family.autoDispose<ProductEntity, String>((ref, productId) async {
  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getProductById(productId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

class ProductState {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedCategory;
  final String? searchQuery;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory,
    this.searchQuery,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;

  ProductNotifier(this._repository) : super(const ProductState());

  Future<void> loadProducts({
    String? category,
    String? searchQuery,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      selectedCategory: category,
      searchQuery: searchQuery,
    );

    final result = await _repository.getProducts(
      category: category,
      searchQuery: searchQuery,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          products: products,
          isLoading: false,
        );
      },
    );
  }

  Future<void> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      searchQuery: query,
    );

    final result = await _repository.searchProducts(
      query: query,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      location: location,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          products: products,
          isLoading: false,
        );
      },
    );
  }

  void filterByCategory(String? category) {
    if (category == null || category == 'All') {
      state = state.copyWith(selectedCategory: null);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
    loadProducts(category: state.selectedCategory, searchQuery: state.searchQuery);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}