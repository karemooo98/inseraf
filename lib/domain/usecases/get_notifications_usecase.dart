import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  Future<NotificationListResponse> call() => _repository.getNotifications();
}

