import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        relatedId,
        isRead,
        createdAt,
        data,
  ];

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}

enum NotificationType {
  order,
  chat,
  promotion,
  review,
  payment,
  system,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.order:
        return 'Order';
      case NotificationType.chat:
        return 'Chat';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.review:
        return 'Review';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.system:
        return 'System';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.order:
        return '📦';
      case NotificationType.chat:
        return '💬';
      case NotificationType.promotion:
        return '🎉';
      case NotificationType.review:
        return '⭐';
      case NotificationType.payment:
        return '💳';
      case NotificationType.system:
        return '🔔';
    }
  }
}