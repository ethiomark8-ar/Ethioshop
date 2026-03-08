import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/domain/entities/product_entity.dart';
import 'package:ethioshop/domain/repositories/product_repository.dart';

/// Get Products Use Case
/// Domain layer - Business logic for retrieving products
class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int? limit,
    ProductEntity? lastProduct,
    String? category,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    ProductSortOrder? sortOrder,
  }) async {
    // Validate parameters
    if (limit != null && limit <= 0) {
      return const Left(Failure.validation(message: 'Limit must be greater than 0'));
    }

    if (limit != null && limit > AppConstants.maxPageSize) {
      return Left(Failure.validation(
        message: 'Limit cannot exceed ${AppConstants.maxPageSize}',
      ));
    }

    if (minPrice != null && minPrice < 0) {
      return const Left(Failure.validation(message: 'Minimum price cannot be negative'));
    }

    if (maxPrice != null && maxPrice < 0) {
      return const Left(Failure.validation(message: 'Maximum price cannot be negative'));
    }

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      return const Left(Failure.validation(
        message: 'Minimum price cannot be greater than maximum price',
      ));
    }

    // Call repository
    return await _productRepository.getProducts(
      limit: limit,
      lastProduct: lastProduct,
      category: category,
      searchQuery: searchQuery,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortOrder: sortOrder,
    );
  }
}