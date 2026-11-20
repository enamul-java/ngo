


import '../entity/notification_entity.dart';

abstract class NotificationRepo {
  Future<List<NotificationEntity>> fetchNotifications(String email);
  Future<bool> deleteNotification();
}