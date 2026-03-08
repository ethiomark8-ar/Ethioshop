import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/failures/failure.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/product_firestore_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  late final Box<String> _wishlistBox;
  final ProductFirestoreDatasource productDatasource;

  WishlistRepositoryImpl({required this.productDatasource}) {
    _wishlistBox = Hive.box<String>(ApiConstants.offlineWishlistKey);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getWishlist() async {
    try {
      final productIds = _wishlistBox.values.toList();
      final products = <ProductEntity>[];

      for (final productId in productIds) {
        final product = await productDatasource.getProductById(productId);
        if (product != null) {
          products.add(product);
        }
      }

      return Right(products);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(String productId) async {
    try {
      if (!_wishlistBox.containsKey(productId)) {
        await _wishlistBox.put(productId, productId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      await _wishlistBox.delete(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(String productId) async {
    try {
      final isInList = _wishlistBox.containsKey(productId);
      return Right(isInList);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleWishlist(String productId) async {
    try {
      if (_wishlistBox.containsKey(productId)) {
        await _wishlistBox.delete(productId);
      } else {
        await _wishlistBox.put(productId, productId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearWishlist() async {
    try {
      await _wishlistBox.clear();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncWishlistWithServer() async {
    // TODO: Implement sync with Firestore
    return const Right(null);
  }

  @override
  Stream<List<ProductEntity>> get wishlistStream {
    return _wishlistBox.watch().asyncMap((_) async {
      final productIds = _wishlistBox.values.toList();
      final products = <ProductEntity>[];

      for (final productId in productIds) {
        final product = await productDatasource.getProductById(productId);
        if (product != null) {
          products.add(product);
        }
      }

      return products;
    });
  }
}