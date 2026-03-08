import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for Clean Architecture error handling
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    String? message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    String? message,
  }) = NetworkFailure;

  const factory Failure.auth({
    String? message,
  }) = AuthFailure;

  const factory Failure.validation({
    String? message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;

  const factory Failure.cache({
    String? message,
  }) = CacheFailure;

  const factory Failure.payment({
    String? message,
  }) = PaymentFailure;

  const factory Failure.permission({
    String? message,
  }) = PermissionFailure;

  const factory Failure.unknown({
    String? message,
    dynamic error,
  }) = UnknownFailure;
}