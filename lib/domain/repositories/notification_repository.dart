import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<NotificationListResponse> getNotifications();
  Future<Notification> markAsRead(int notificationId);
  Future<int> markAllAsRead();
  Future<int> sendNotification({
    required String title,
    required String message,
    String? type,
    int? userId,
    List<int>? userIds,
    bool? sendToAll,
  });
}

class NotificationListResponse {
  const NotificationListResponse({
    required this.notifications,
    required this.unreadCount,
  });

  final List<Notification> notifications;
  final int unreadCount;
}

