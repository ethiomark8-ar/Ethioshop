import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    required String phoneNumber,
    required String role,
    String? avatarUrl,
    String? bio,
    @JsonKey(defaultValue: false) bool isVerifiedSeller,
    @JsonKey(defaultValue: false) bool isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
    UserLocationModel? location,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      role: UserRole.values.firstWhere(
        (e) => e.name == role,
        orElse: () => UserRole.buyer,
      ),
      avatarUrl: avatarUrl,
      bio: bio,
      isVerifiedSeller: isVerifiedSeller,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      preferences: preferences,
      location: location?.toEntity(),
    );
  }
}

@freezed
class UserLocationModel with _$UserLocationModel {
  const factory UserLocationModel({
    required double latitude,
    required double longitude,
    String? address,
    String? city,
    String? region,
  }) = _UserLocationModel;

  factory UserLocationModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocationModelFromJson(json);

  UserLocation toEntity() {
    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
      region: region,
    );
  }
}