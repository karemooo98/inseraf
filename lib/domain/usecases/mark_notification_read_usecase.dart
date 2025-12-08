import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  MarkNotificationReadUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Notification> call(int notificationId) =>
      _repository.markAsRead(notificationId);
}

