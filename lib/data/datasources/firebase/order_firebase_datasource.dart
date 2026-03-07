import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethioshop/domain/entities/order_entity.dart';

/// Firebase Order Datasource
/// Data layer - Handles all order-related Firebase operations
class OrderFirebaseDatasource {
  final FirebaseFirestore _firestore;

  OrderFirebaseDatasource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _ordersCollection =>
      _firestore.collection('orders');

  Future<DocumentReference> createOrder(Map<String, dynamic> orderData) async {
    final docRef = await _ordersCollection.add(orderData);
    return docRef;
  }

  Future<DocumentSnapshot> getOrderById(String orderId) async {
    return await _ordersCollection.doc(orderId).get();
  }

  Future<QuerySnapshot> getBuyerOrders({
    required String buyerId,
    OrderStatus? status,
    int? limit,
  }) async {
    Query query = _ordersCollection.where('buyerId', isEqualTo: buyerId);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    query = query.orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  Future<QuerySnapshot> getSellerOrders({
    required String sellerId,
    OrderStatus? status,
    int? limit,
  }) async {
    Query query = _ordersCollection.where('sellerId', isEqualTo: sellerId);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    query = query.orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    final Map<String, dynamic> data = {
      'status': newStatus.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Set timestamp based on status
    switch (newStatus) {
      case OrderStatus.confirmed:
        data['confirmedAt'] = FieldValue.serverTimestamp();
        break;
      case OrderStatus.shipped:
        data['shippedAt'] = FieldValue.serverTimestamp();
        break;
      case OrderStatus.delivered:
        data['deliveredAt'] = FieldValue.serverTimestamp();
        break;
      case OrderStatus.cancelled:
        data['cancelledAt'] = FieldValue.serverTimestamp();
        break;
      default:
        break;
    }

    await _ordersCollection.doc(orderId).update(data);
  }

  Future<void> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    await _ordersCollection.doc(orderId).update({
      'status': OrderStatus.cancelled.name,
      'cancelledAt': FieldValue.serverTimestamp(),
      'cancellationReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream order updates for real-time tracking
  Stream<DocumentSnapshot> watchOrder(String orderId) {
    return _ordersCollection.doc(orderId).snapshots();
  }

  /// Get order statistics for seller
  Future<Map<String, dynamic>> getSellerOrderStatistics(
    String sellerId,
  ) async {
    final orders = await _ordersCollection
        .where('sellerId', isEqualTo: sellerId)
        .get();

    final stats = <String, dynamic>{
      'totalOrders': orders.size,
      'pendingOrders': 0,
      'confirmedOrders': 0,
      'shippedOrders': 0,
      'deliveredOrders': 0,
      'cancelledOrders': 0,
      'totalRevenue': 0.0,
    };

    double totalRevenue = 0.0;
    int deliveredCount = 0;

    for (final doc in orders.docs) {
      final order = doc.data() as Map<String, dynamic>;
      final status = order['status'] as String?;
      final amount = order['totalAmount'] as double? ?? 0.0;

      switch (status) {
        case 'pending':
          stats['pendingOrders']++;
          break;
        case 'confirmed':
          stats['confirmedOrders']++;
          break;
        case 'shipped':
          stats['shippedOrders']++;
          break;
        case 'delivered':
          stats['deliveredOrders']++;
          totalRevenue += amount;
          deliveredCount++;
          break;
        case 'cancelled':
          stats['cancelledOrders']++;
          break;
      }
    }

    stats['totalRevenue'] = totalRevenue;
    stats['averageOrderValue'] = deliveredCount > 0 ? totalRevenue / deliveredCount : 0.0;

    return stats;
  }

  /// Get order statistics for admin
  Future<Map<String, dynamic>> getAdminOrderStatistics() async {
    final orders = await _ordersCollection.get();

    final stats = <String, dynamic>{
      'totalOrders': orders.size,
      'pendingOrders': 0,
      'confirmedOrders': 0,
      'shippedOrders': 0,
      'deliveredOrders': 0,
      'cancelledOrders': 0,
      'totalRevenue': 0.0,
    };

    double totalRevenue = 0.0;
    int deliveredCount = 0;

    for (final doc in orders.docs) {
      final order = doc.data() as Map<String, dynamic>;
      final status = order['status'] as String?;
      final amount = order['totalAmount'] as double? ?? 0.0;

      switch (status) {
        case 'pending':
          stats['pendingOrders']++;
          break;
        case 'confirmed':
          stats['confirmedOrders']++;
          break;
        case 'shipped':
          stats['shippedOrders']++;
          break;
        case 'delivered':
          stats['deliveredOrders']++;
          totalRevenue += amount;
          deliveredCount++;
          break;
        case 'cancelled':
          stats['cancelledOrders']++;
          break;
      }
    }

    stats['totalRevenue'] = totalRevenue;
    stats['averageOrderValue'] = deliveredCount > 0 ? totalRevenue / deliveredCount : 0.0;

    return stats;
  }
}