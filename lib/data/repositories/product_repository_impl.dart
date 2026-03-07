import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_firestore_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductFirestoreDatasource datasource;

  ProductRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String productId) async {
    try {
      final product = await datasource.getProductById(productId);
      if (product == null) {
        return const Left(NotFoundFailure(message: 'Product not found'));
      }
      return Right(product);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    String? lastProductId,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final products = await datasource.getProducts(
        limit: limit ?? AppConstants.productsPerPage,
        lastProductId: lastProductId,
        category: category,
        searchQuery: searchQuery,
      );
      return Right(products);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts({
    int? limit,
  }) async {
    try {
      final products = await datasource.getFeaturedProducts(
        limit: limit ?? 10,
      );
      return Right(products);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getTrendingProducts({
    int? limit,
  }) async {
    try {
      final products = await datasource.getTrendingProducts(
        limit: limit ?? 10,
      );
      return Right(products);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getSellerProducts({
    required String sellerId,
    int? limit,
  }) async {
    try {
      final products = await datasource.getSellerProducts(
        sellerId: sellerId,
        limit: limit ?? AppConstants.productsPerPage,
      );
      return Right(products);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  }) async {
    try {
      final products = await datasource.searchProducts(
        query: query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        location: location,
        sortBy: sortBy,
      );
      return Right(products);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> imageUrls,
    required int stock,
    List<String>? tags,
    String? location,
  }) async {
    try {
      final product = await datasource.createProduct(
        name: name,
        description: description,
        price: price,
        category: category,
        imageUrls: imageUrls,
        stock: stock,
        tags: tags ?? [],
        location: location,
      );
      return Right(product);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final product = await datasource.updateProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        category: category,
        imageUrls: imageUrls,
        stock: stock,
        tags: tags,
        location: location,
        isFeatured: isFeatured,
        isActive: isActive,
      );
      return Right(product);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await datasource.deleteProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadProductImages(
    List<String> imagePaths,
  ) async {
    try {
      final urls = await datasource.uploadProductImages(imagePaths);
      return Right(urls);
    } catch (e) {
      return Left(FileUploadFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await datasource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<ProductEntity?> watchProduct(String productId) {
    return datasource.watchProduct(productId);
  }

  @override
  Stream<List<ProductEntity>> watchProducts() {
    return datasource.watchProducts();
  }
}