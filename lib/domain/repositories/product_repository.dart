import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../failures/failure.dart';

abstract class ProductRepository {
  // Product Operations
  Future<Either<Failure, ProductEntity>> getProductById(String productId);

  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    String? lastProductId,
    String? category,
    String? searchQuery,
  });

  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts({
    int? limit,
  });

  Future<Either<Failure, List<ProductEntity>>> getTrendingProducts({
    int? limit,
  });

  Future<Either<Failure, List<ProductEntity>>> getSellerProducts({
    required String sellerId,
    int? limit,
  });

  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  });

  // Seller Operations
  Future<Either<Failure, ProductEntity>> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> imageUrls,
    required int stock,
    List<String>? tags,
    String? location,
  });

  Future<Either<Failure, ProductEntity>> updateProduct({
    required String productId,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    int? stock,
    List<String>? tags,
    String? location,
    bool? isFeatured,
    bool? isActive,
  });

  Future<Either<Failure, void>> deleteProduct(String productId);

  Future<Either<Failure, List<String>>> uploadProductImages(
    List<String> imagePaths,
  );

  // Categories
  Future<Either<Failure, List<String>>> getCategories();

  // Streams
  Stream<ProductEntity?> watchProduct(String productId);
  Stream<List<ProductEntity>> watchProducts();
}