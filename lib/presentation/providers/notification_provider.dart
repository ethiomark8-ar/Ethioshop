import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/notification_entity.dart';

// Notification State
class NotificationState {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? error,
    bool? hasMore,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationEntity> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationEntity> get readNotifications =>
      notifications.where((n) => n.isRead).toList();
}

// Notification Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref ref;

  NotificationNotifier(this.ref) : super(const NotificationState()) {
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    // Mock notifications for development
    final now = DateTime.now();
    final mockNotifications = [
      NotificationEntity(
        id: 'notif_1',
        userId: 'user_123',
        title: 'Order Shipped',
        body: 'Your order #ET123456789 has been shipped and is on its way to Addis Ababa.',
        type: NotificationType.order,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        data: {'orderId': 'order_1'},
      ),
      NotificationEntity(
        id: 'notif_2',
        userId: 'user_123',
        title: 'New Message',
        body: 'You have a new message from Ethiopian Coffee House about your order.',
        type: NotificationType.message,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 4)),
        data: {'chatId': 'chat_1', 'senderId': 'seller_1'},
      ),
      NotificationEntity(
        id: 'notif_3',
        userId: 'user_123',
        title: 'Price Drop Alert',
        body: 'Great news! "Traditional Ethiopian Shamma" is now 10% off.',
        type: NotificationType.promotion,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
        data: {'productId': 'prod_2'},
      ),
      NotificationEntity(
        id: 'notif_4',
        userId: 'user_123',
        title: 'Order Delivered',
        body: 'Your order #ET987654321 has been successfully delivered.',
        type: NotificationType.order,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
        data: {'orderId': 'order_2'},
      ),
      NotificationEntity(
        id: 'notif_5',
        userId: 'user_123',
        title: 'Review Request',
        body: 'How was your experience with "Ethiopian Spices Set"? Share your feedback!',
        type: NotificationType.review,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 4)),
        data: {'productId': 'prod_3', 'orderId': 'order_2'},
      ),
      NotificationEntity(
        id: 'notif_6',
        userId: 'user_123',
        title: 'Welcome to EthioShop',
        body: 'Thank you for joining EthioShop! Start exploring amazing Ethiopian products.',
        type: NotificationType.system,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 7)),
        data: {},
      ),
      NotificationEntity(
        id: 'notif_7',
        userId: 'user_123',
        title: 'New Arrival',
        body: 'Check out our new collection of traditional Ethiopian jewelry!',
        type: NotificationType.promotion,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 5)),
        data: {'category': 'jewelry'},
      ),
      NotificationEntity(
        id: 'notif_8',
        userId: 'user_123',
        title: 'Wishlist Update',
        body: 'An item in your wishlist is back in stock!',
        type: NotificationType.system,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
        data: {'productId': 'prod_5'},
      ),
    ];

    // Sort by createdAt descending
    mockNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.copyWith(notifications: mockNotifications);
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (!refresh) {
      // Already loaded from constructor
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload mock notifications
      _loadMockNotifications();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications: $e',
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((notif) {
      if (notif.id == notificationId) {
        return notif.copyWith(isRead: true, readAt: DateTime.now());
      }
      return notif;
    }).toList();

    state = state.copyWith(notifications: updatedNotifications);
  }

  Future<void> markAllAsRead() async {
    final now = DateTime.now();
    final updatedNotifications = state.notifications.map((notif) {
      if (!notif.isRead) {
        return notif.copyWith(isRead: true, readAt: now);
      }
      return notif;
    }).toList();

    state = state.copyWith(notifications: updatedNotifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    final updatedNotifications = state.notifications
        .where((notif) => notif.id != notificationId)
        .toList();

    state = state.copyWith(notifications: updatedNotifications);
  }

  Future<void> deleteAllRead() async {
    final updatedNotifications = state.notifications
        .where((notif) => !notif.isRead)
        .toList();

    state = state.copyWith(notifications: updatedNotifications);
  }

  Future<void> deleteAll() async {
    state = state.copyWith(notifications: []);
  }

  Future<void> addNotification(NotificationEntity notification) async {
    final updatedNotifications = [notification, ...state.notifications];
    state = state.copyWith(notifications: updatedNotifications);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

// Unread notification count provider
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

// Notifications by type provider
final notificationsByTypeProvider = Provider.family<List<NotificationEntity>, NotificationType>((ref, type) {
  final notifications = ref.watch(notificationProvider).notifications;
  return notifications.where((n) => n.type == type).toList();
});