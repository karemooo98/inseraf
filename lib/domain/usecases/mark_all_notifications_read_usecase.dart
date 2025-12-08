import '../repositories/notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  MarkAllNotificationsReadUseCase(this._repository);

  final NotificationRepository _repository;

  Future<int> call() => _repository.markAllAsRead();
}

