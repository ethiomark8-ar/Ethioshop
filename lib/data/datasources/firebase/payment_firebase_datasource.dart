import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_functions/firebase_functions.dart';

/// Firebase Payment Datasource
/// Data layer - Handles all payment-related Firebase operations
/// Integrates with Chapa payment gateway via Cloud Functions
class PaymentFirebaseDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  PaymentFirebaseDatasource({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  CollectionReference get _paymentsCollection =>
      _firestore.collection('payments');

  CollectionReference get _ordersCollection =>
      _firestore.collection('orders');

  /// Create payment intent via Cloud Function
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String orderId,
    required String email,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    String? callbackUrl,
  }) async {
    try {
      final result = await _functions.httpsCallable('createPaymentIntent').call({
        'amount': amount,
        'orderId': orderId,
        'email': email,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        if (callbackUrl != null) 'callbackUrl': callbackUrl,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to create payment intent: ${e.toString()}');
    }
  }

  /// Verify payment via Cloud Function
  Future<Map<String, dynamic>> verifyPayment({
    required String transactionId,
    required String orderId,
  }) async {
    try {
      final result = await _functions.httpsCallable('verifyPayment').call({
        'transactionId': transactionId,
        'orderId': orderId,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to verify payment: ${e.toString()}');
    }
  }

  /// Get payment status from Firestore
  Future<DocumentSnapshot> getPaymentStatus(String transactionId) async {
    return await _paymentsCollection.doc(transactionId).get();
  }

  /// Process refund via Cloud Function
  Future<void> processRefund({
    required String transactionId,
    required double amount,
    String? reason,
  }) async {
    try {
      await _functions.httpsCallable('processRefund').call({
        'transactionId': transactionId,
        'amount': amount,
        if (reason != null) 'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to process refund: ${e.toString()}');
    }
  }

  /// Release escrow funds to seller via Cloud Function
  Future<void> releaseEscrowFunds({
    required String orderId,
    required String sellerId,
    required double amount,
  }) async {
    try {
      await _functions.httpsCallable('releaseEscrowFunds').call({
        'orderId': orderId,
        'sellerId': sellerId,
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Failed to release escrow funds: ${e.toString()}');
    }
  }

  /// Get available payment methods
  Future<List<Map<String, dynamic>>> getAvailablePaymentMethods() async {
    try {
      final result = await _functions.httpsCallable('getPaymentMethods').call();
      return List<Map<String, dynamic>>.from(result.data);
    } catch (e) {
      throw Exception('Failed to get payment methods: ${e.toString()}');
    }
  }

  /// Calculate order total with fees
  Future<Map<String, dynamic>> calculateOrderTotal({
    required double subtotal,
    String? shippingMethod,
  }) async {
    try {
      final result = await _functions.httpsCallable('calculateOrderTotal').call({
        'subtotal': subtotal,
        if (shippingMethod != null) 'shippingMethod': shippingMethod,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to calculate order total: ${e.toString()}');
    }
  }

  /// Validate payment details
  Future<void> validatePaymentDetails({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      await _functions.httpsCallable('validatePaymentDetails').call({
        'email': email,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw Exception('Failed to validate payment details: ${e.toString()}');
    }
  }

  /// Create payment record in Firestore
  Future<void> createPaymentRecord({
    required String transactionId,
    required String orderId,
    required double amount,
    required String status,
    required String paymentMethod,
    Map<String, dynamic>? metadata,
  }) async {
    await _paymentsCollection.doc(transactionId).set({
      'transactionId': transactionId,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'metadata': metadata ?? {},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update payment status
  Future<void> updatePaymentStatus({
    required String transactionId,
    required String status,
    String? errorMessage,
  }) async {
    final Map<String, dynamic> data = {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (errorMessage != null) {
      data['errorMessage'] = errorMessage;
    }

    await _paymentsCollection.doc(transactionId).update(data);
  }

  /// Get payments for an order
  Future<QuerySnapshot> getOrderPayments(String orderId) async {
    return await _paymentsCollection
        .where('orderId', isEqualTo: orderId)
        .orderBy('createdAt', descending: true)
        .get();
  }

  /// Stream payment updates
  Stream<DocumentSnapshot> watchPayment(String transactionId) {
    return _paymentsCollection.doc(transactionId).snapshots();
  }
}