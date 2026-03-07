import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isVerified;
  final bool isSeller;
  final bool isAdmin;
  final String? location;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final double rating;
  final int totalReviews;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profileImageUrl,
    this.isVerified = false,
    this.isSeller = false,
    this.isAdmin = false,
    this.location,
    required this.createdAt,
    this.lastLoginAt,
    this.rating = 0.0,
    this.totalReviews = 0,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        profileImageUrl,
        isVerified,
        isSeller,
        isAdmin,
        location,
        createdAt,
        lastLoginAt,
        rating,
        totalReviews,
      ];

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isVerified,
    bool? isSeller,
    bool? isAdmin,
    String? location,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    double? rating,
    int? totalReviews,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      isSeller: isSeller ?? this.isSeller,
      isAdmin: isAdmin ?? this.isAdmin,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}