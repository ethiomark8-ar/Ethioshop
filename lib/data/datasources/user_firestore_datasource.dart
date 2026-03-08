import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserFirestoreDatasource {
  Future<UserEntity?> getUserById(String userId);
  Future<void> createUser(UserEntity user);
  Future<UserEntity> updateUser({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  });
  Future<void> deleteUser(String userId);
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  });
}

class UserFirestoreDatasourceImpl implements UserFirestoreDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  UserFirestoreDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<UserEntity?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) return null;

    return _mapDocToUserEntity(doc);
  }

  @override
  Future<void> createUser(UserEntity user) async {
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'profileImageUrl': user.profileImageUrl,
      'isVerified': user.isVerified,
      'isSeller': user.isSeller,
      'isAdmin': user.isAdmin,
      'location': user.location,
      'createdAt': Timestamp.fromDate(user.createdAt),
      'lastLoginAt': user.lastLoginAt != null
          ? Timestamp.fromDate(user.lastLoginAt!)
          : null,
      'rating': user.rating,
      'totalReviews': user.totalReviews,
    });
  }

  @override
  Future<UserEntity> updateUser({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? location,
    String? profileImageUrl,
  }) async {
    final updateData = <String, dynamic>{};

    if (fullName != null) updateData['fullName'] = fullName;
    if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
    if (location != null) updateData['location'] = location;
    if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;

    await _firestore.collection('users').doc(userId).update(updateData);

    final doc = await _firestore.collection('users').doc(userId).get();
    return _mapDocToUserEntity(doc);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    final file = _storage.ref().child('user_avatars/$userId.jpg');
    final uploadTask = await file.putFile(imagePath as File);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }

  UserEntity _mapDocToUserEntity(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserEntity(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      isVerified: data['isVerified'] ?? false,
      isSeller: data['isSeller'] ?? false,
      isAdmin: data['isAdmin'] ?? false,
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
    );
  }
}