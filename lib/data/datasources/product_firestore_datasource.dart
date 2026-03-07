import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductFirestoreDatasource {
  Future<ProductEntity?> getProductById(String productId);
  Future<List<ProductEntity>> getProducts({
    required int limit,
    String? lastProductId,
    String? category,
    String? searchQuery,
  });
  Future<List<ProductEntity>> getFeaturedProducts({required int limit});
  Future<List<ProductEntity>> getTrendingProducts({required int limit});
  Future<List<ProductEntity>> getSellerProducts({
    required String sellerId,
    required int limit,
  });
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  });
  Future<ProductEntity> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> imageUrls,
    required int stock,
    required List<String> tags,
    String? location,
  });
  Future<ProductEntity> updateProduct({
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
  Future<void> deleteProduct(String productId);
  Future<List<String>> uploadProductImages(List<String> imagePaths);
  Future<List<String>> getCategories();
  Stream<ProductEntity?> watchProduct(String productId);
  Stream<List<ProductEntity>> watchProducts();
}

class ProductFirestoreDatasourceImpl implements ProductFirestoreDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProductFirestoreDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists) return null;
    return _mapDocToProduct(doc);
  }

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    String? lastProductId,
    String? category,
    String? searchQuery,
  }) async {
    Query query = _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastProductId != null) {
      final lastDoc = await _firestore.collection('products').doc(lastProductId).get();
      query = query.startAfterDocument(lastDoc);
    }

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList();
  }

  @override
  Future<List<ProductEntity>> getFeaturedProducts({required int limit}) async {
    final snapshot = await _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList();
  }

  @override
  Future<List<ProductEntity>> getTrendingProducts({required int limit}) async {
    final snapshot = await _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('soldCount', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList();
  }

  @override
  Future<List<ProductEntity>> getSellerProducts({
    required String sellerId,
    required int limit,
  }) async {
    final snapshot = await _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList();
  }

  @override
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? sortBy,
  }) async {
    Query productQuery = _firestore.collection('products').where('isActive', isEqualTo: true);

    if (category != null && category.isNotEmpty) {
      productQuery = productQuery.where('category', isEqualTo: category);
    }

    if (minPrice != null) {
      productQuery = productQuery.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      productQuery = productQuery.where('price', isLessThanOrEqualTo: maxPrice);
    }

    if (location != null && location.isNotEmpty) {
      productQuery = productQuery.where('location', isEqualTo: location);
    }

    switch (sortBy) {
      case 'price_asc':
        productQuery = productQuery.orderBy('price', descending: false);
        break;
      case 'price_desc':
        productQuery = productQuery.orderBy('price', descending: true);
        break;
      case 'rating':
        productQuery = productQuery.orderBy('rating', descending: true);
        break;
      case 'newest':
      default:
        productQuery = productQuery.orderBy('createdAt', descending: true);
    }

    final snapshot = await productQuery.limit(50).get();
    
    var products = snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList();

    // Client-side text search
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      products = products.where((product) {
        return product.name.toLowerCase().contains(lowerQuery) ||
               product.description.toLowerCase().contains(lowerQuery) ||
               product.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    }

    return products;
  }

  @override
  Future<ProductEntity> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> imageUrls,
    required int stock,
    required List<String> tags,
    String? location,
  }) async {
    final docRef = await _firestore.collection('products').add({
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'stock': stock,
      'rating': 0.0,
      'reviewCount': 0,
      'soldCount': 0,
      'isFeatured': false,
      'isActive': true,
      'tags': tags,
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final doc = await docRef.get();
    return _mapDocToProduct(doc);
  }

  @override
  Future<ProductEntity> updateProduct({
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
    final updateData = <String, dynamic>{};

    if (name != null) updateData['name'] = name;
    if (description != null) updateData['description'] = description;
    if (price != null) updateData['price'] = price;
    if (category != null) updateData['category'] = category;
    if (imageUrls != null) updateData['imageUrls'] = imageUrls;
    if (stock != null) updateData['stock'] = stock;
    if (tags != null) updateData['tags'] = tags;
    if (location != null) updateData['location'] = location;
    if (isFeatured != null) updateData['isFeatured'] = isFeatured;
    if (isActive != null) updateData['isActive'] = isActive;
    updateData['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('products').doc(productId).update(updateData);

    final doc = await _firestore.collection('products').doc(productId).get();
    return _mapDocToProduct(doc);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<List<String>> uploadProductImages(List<String> imagePaths) async {
    final urls = <String>[];
    for (int i = 0; i < imagePaths.length; i++) {
      final file = File(imagePaths[i]);
      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child('product_images/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Future<List<String>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Stream<ProductEntity?> watchProduct(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists ? _mapDocToProduct(doc) : null);
  }

  @override
  Stream<List<ProductEntity>> watchProducts() {
    return _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => _mapDocToProduct(doc)).toList());
  }

  ProductEntity _mapDocToProduct(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductEntity(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerAvatar: data['sellerAvatar'],
      stock: data['stock'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      soldCount: data['soldCount'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      isActive: data['isActive'] ?? true,
      tags: List<String>.from(data['tags'] ?? []),
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}