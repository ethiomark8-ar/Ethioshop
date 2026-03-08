import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../failures/failure.dart';

abstract class WishlistRepository {
  // Wishlist Operations
  Future<Either<Failure, List<ProductEntity>>> getWishlist();

  Future<Either<Failure, void>> addToWishlist(String productId);

  Future<Either<Failure, void>> removeFromWishlist(String productId);

  Future<Either<Failure, bool>> isInWishlist(String productId);

  Future<Either<Failure, void>> toggleWishlist(String productId);

  Future<Either<Failure, void>> clearWishlist();

  // Sync
  Future<Either<Failure, void>> syncWishlistWithServer();

  // Streams
  Stream<List<ProductEntity>> get wishlistStream;
}