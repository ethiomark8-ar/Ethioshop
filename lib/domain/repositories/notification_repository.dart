import 'package:dartz/dartz.dart';
import '../entities/notification_entity.dart';
import '../failures/failure.dart';

abstract class NotificationRepository {
  // Notification Operations
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int? limit,
    NotificationType? type,
    bool? unreadOnly,
  });

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, void>> markAllAsRead();

  Future<Either<Failure, void>> deleteNotification(String notificationId);

  Future<Either<Failure, void>> clearAllNotifications();

  // Push Notifications
  Future<Either<Failure, void>> registerFcmToken(String token);

  Future<Either<Failure, void>> unregisterFcmToken();

  // Unread Count
  Future<Either<Failure, int>> getUnreadCount();

  // Streams
  Stream<List<NotificationEntity>> get notificationsStream;
  Stream<int> get unreadCountStream;
}