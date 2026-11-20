

import '../entity/notification_entity.dart';
import '../repository/notification_repo.dart';

class FetchNotificationUsecase {

     final NotificationRepo repo;

     FetchNotificationUsecase(this.repo);

     Future<List<NotificationEntity>> call(String email) async =>
         await repo.fetchNotifications(email);

}