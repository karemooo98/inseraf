import '../repositories/notification_repository.dart';

class SendNotificationUseCase {
  SendNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  Future<int> call({
    required String title,
    required String message,
    String? type,
    int? userId,
    List<int>? userIds,
    bool? sendToAll,
  }) =>
      _repository.sendNotification(
        title: title,
        message: message,
        type: type,
        userId: userId,
        userIds: userIds,
        sendToAll: sendToAll,
      );
}

