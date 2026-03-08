import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/user_entity.dart';

// Order State
class OrderState {
  final List<OrderEntity> orders;
  final OrderEntity? currentOrder;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.currentOrder,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<OrderEntity>? orders,
    OrderEntity? currentOrder,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<OrderEntity> get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.pending).toList();

  List<OrderEntity> get processingOrders =>
      orders.where((o) => o.status == OrderStatus.processing).toList();

  List<OrderEntity> get shippedOrders =>
      orders.where((o) => o.status == OrderStatus.shipped).toList();

  List<OrderEntity> get deliveredOrders =>
      orders.where((o) => o.status == OrderStatus.delivered).toList();

  List<OrderEntity> get cancelledOrders =>
      orders.where((o) => o.status == OrderStatus.cancelled).toList();
}

// Order Notifier
class OrderNotifier extends StateNotifier<OrderState> {
  final Ref ref;

  OrderNotifier(this.ref) : super(const OrderState()) {
    _loadMockOrders();
  }

  void _loadMockOrders() {
    // Mock orders for development
    final mockOrders = [
      OrderEntity(
        id: 'order_1',
        userId: 'user_123',
        items: const [
          OrderItemEntity(
            productId: 'prod_1',
            productName: 'Ethiopian Coffee - Yirgacheffe',
            productImage: 'https://images.unsplash.com/photo-1559056199-641a0ac8b46e?w=200',
            quantity: 2,
            price: 450.0,
            sellerId: 'seller_1',
            sellerName: 'Ethiopian Coffee House',
          ),
          OrderItemEntity(
            productId: 'prod_2',
            productName: 'Traditional Ethiopian Shamma',
            productImage: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=200',
            quantity: 1,
            price: 1200.0,
            sellerId: 'seller_2',
            sellerName: 'Habesha Crafts',
          ),
        ],
        subtotal: 2100.0,
        shippingCost: 150.0,
        tax: 113.0,
        total: 2363.0,
        status: OrderStatus.processing,
        shippingAddress: const AddressEntity(
          fullName: 'Abebe Bikila',
          phoneNumber: '+251911123456',
          region: 'Addis Ababa',
          city: 'Addis Ababa',
          subCity: 'Bole',
          specificAddress: 'Bole Medhane Alem, House No. 123',
          postalCode: '1000',
        ),
        paymentMethod: PaymentMethod.chapa,
        paymentStatus: PaymentStatus.paid,
        trackingNumber: 'ET123456789',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      OrderEntity(
        id: 'order_2',
        userId: 'user_123',
        items: const [
          OrderItemEntity(
            productId: 'prod_3',
            productName: 'Ethiopian Spices Set',
            productImage: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=200',
            quantity: 1,
            price: 350.0,
            sellerId: 'seller_3',
            sellerName: 'Abyssinia Spices',
          ),
        ],
        subtotal: 350.0,
        shippingCost: 100.0,
        tax: 23.0,
        total: 473.0,
        status: OrderStatus.delivered,
        shippingAddress: const AddressEntity(
          fullName: 'Abebe Bikila',
          phoneNumber: '+251911123456',
          region: 'Addis Ababa',
          city: 'Addis Ababa',
          subCity: 'Bole',
          specificAddress: 'Bole Medhane Alem, House No. 123',
          postalCode: '1000',
        ),
        paymentMethod: PaymentMethod.cashOnDelivery,
        paymentStatus: PaymentStatus.paid,
        trackingNumber: 'ET987654321',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      OrderEntity(
        id: 'order_3',
        userId: 'user_123',
        items: const [
          OrderItemEntity(
            productId: 'prod_4',
            productName: 'Handwoven Ethiopian Dress',
            productImage: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=200',
            quantity: 1,
            price: 2500.0,
            sellerId: 'seller_2',
            sellerName: 'Habesha Crafts',
          ),
        ],
        subtotal: 2500.0,
        shippingCost: 200.0,
        tax: 162.0,
        total: 2862.0,
        status: OrderStatus.pending,
        shippingAddress: const AddressEntity(
          fullName: 'Abebe Bikila',
          phoneNumber: '+251911123456',
          region: 'Addis Ababa',
          city: 'Addis Ababa',
          subCity: 'Kirkos',
          specificAddress: 'Kazanchis Market, Shop 45',
          postalCode: '1000',
        ),
        paymentMethod: PaymentMethod.chapa,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    state = state.copyWith(orders: mockOrders);
  }

  Future<void> createOrder({
    required List<CartItemEntity> cartItems,
    required AddressEntity shippingAddress,
    required PaymentMethod paymentMethod,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Calculate totals
      double subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

      // Shipping cost based on region
      double shippingCost = _calculateShippingCost(shippingAddress.region);

      // Tax (15% VAT in Ethiopia)
      double tax = subtotal * 0.15;

      double total = subtotal + shippingCost + tax;

      // Create order items from cart items
      final orderItems = cartItems.map((item) => OrderItemEntity(
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        quantity: item.quantity,
        price: item.price,
        sellerId: item.sellerId ?? 'unknown',
        sellerName: item.sellerName ?? 'Unknown Seller',
      )).toList();

      final order = OrderEntity(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_123',
        items: orderItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
        tax: tax,
        total: total,
        status: OrderStatus.pending,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        paymentStatus: paymentMethod == PaymentMethod.cashOnDelivery
            ? PaymentStatus.pending
            : PaymentStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add to orders list
      final updatedOrders = [order, ...state.orders];
      state = state.copyWith(
        orders: updatedOrders,
        currentOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create order: $e',
      );
    }
  }

  double _calculateShippingCost(String region) {
    // Shipping costs based on Ethiopian regions
    const shippingCosts = {
      'Addis Ababa': 100.0,
      'Oromia': 150.0,
      'Amhara': 200.0,
      'Tigray': 250.0,
      'SNNPR': 180.0,
      'Afar': 300.0,
      'Somali': 350.0,
      'Benishangul-Gumuz': 280.0,
      'Gambela': 320.0,
      'Harari': 220.0,
      'Dire Dawa': 200.0,
    };
    return shippingCosts[region] ?? 200.0;
  }

  Future<void> cancelOrder(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(
            status: OrderStatus.cancelled,
            updatedAt: DateTime.now(),
          );
        }
        return order;
      }).toList();

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel order: $e',
      );
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = state.orders.firstWhere(
        (o) => o.id == orderId,
        orElse: () => throw Exception('Order not found'),
      );

      state = state.copyWith(
        currentOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch order: $e',
      );
    }
  }

  Future<void> updatePaymentStatus(String orderId, PaymentStatus status) async {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          paymentStatus: status,
          updatedAt: DateTime.now(),
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  void clearCurrentOrder() {
    state = state.copyWith(currentOrder: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref);
});

// Order by ID provider
final orderByIdProvider = Provider.family<OrderEntity?, String>((ref, orderId) {
  final orders = ref.watch(orderProvider).orders;
  try {
    return orders.firstWhere((o) => o.id == orderId);
  } catch (e) {
    return null;
  }
});

// Orders by status provider
final ordersByStatusProvider = Provider.family<List<OrderEntity>, OrderStatus>((ref, status) {
  final orders = ref.watch(orderProvider).orders;
  return orders.where((o) => o.status == status).toList();
});

// Order count provider
final orderCountProvider = Provider<int>((ref) {
  return ref.watch(orderProvider).orders.length;
});

// Pending order count provider
final pendingOrderCountProvider = Provider<int>((ref) {
  return ref.watch(orderProvider).pendingOrders.length;
});