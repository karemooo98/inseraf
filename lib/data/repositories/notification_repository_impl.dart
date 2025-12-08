import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote_api_service.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._api);

  final RemoteApiService _api;

  @override
  Future<NotificationListResponse> getNotifications() async {
    final dynamic response = await _api.getNotifications();
    final Map<String, dynamic> responseMap = response as Map<String, dynamic>;
    
    final List<dynamic> data = responseMap['data'] as List<dynamic>? ?? <dynamic>[];
    final List<Notification> notifications = data
        .map((dynamic item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
    
    final int unreadCount = responseMap['unread_count'] as int? ?? 0;
    
    return NotificationListResponse(
      notifications: notifications,
      unreadCount: unreadCount,
    );
  }

  @override
  Future<Notification> markAsRead(int notificationId) async {
    final Map<String, dynamic> response = await _api.markNotificationAsRead(notificationId);
    final Map<String, dynamic> data = response['data'] as Map<String, dynamic>;
    return NotificationModel.fromJson(data);
  }

  @override
  Future<int> markAllAsRead() async {
    final Map<String, dynamic> response = await _api.markAllNotificationsAsRead();
    return response['updated_count'] as int? ?? 0;
  }

  @override
  Future<int> sendNotification({
    required String title,
    required String message,
    String? type,
    int? userId,
    List<int>? userIds,
    bool? sendToAll,
  }) async {
    final Map<String, dynamic> response = await _api.sendNotification(
      title: title,
      message: message,
      type: type,
      userId: userId,
      userIds: userIds,
      sendToAll: sendToAll,
    );
    return response['sent_count'] as int? ?? 0;
  }
}

