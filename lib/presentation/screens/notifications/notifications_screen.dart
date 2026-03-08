import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Order Confirmed',
      body: 'Your order #12345 has been confirmed and is being processed.',
      type: 'order',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'New Message',
      body: 'You have a new message from seller John Doe.',
      type: 'chat',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Flash Sale!',
      body: 'Up to 50% off on electronics. Limited time offer!',
      type: 'promotion',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Order Delivered',
      body: 'Your order #12340 has been delivered successfully.',
      type: 'order',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Review Reminder',
      body: 'How was your experience? Leave a review for your recent purchase.',
      type: 'review',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification.isRead = true;
                  }
                });
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyNotifications()
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationTile(notification);
              },
            ),
    );
  }

  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: notification.isRead ? Colors.grey[200] : AppTheme.primaryGreen.withOpacity(0.1),
        child: Text(_getNotificationIcon(notification.type)),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: notification.isRead
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
      },
    );
  }

  String _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return '📦';
      case 'chat':
        return '💬';
      case 'promotion':
        return '🎉';
      case 'review':
        return '⭐';
      case 'payment':
        return '💳';
      default:
        return '🔔';
    }
  }
}