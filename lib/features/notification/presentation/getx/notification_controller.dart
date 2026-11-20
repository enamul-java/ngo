
import 'package:get/get.dart';
import 'package:ngo/core/error/app_exception.dart';
import 'package:ngo/features/notification/domain/entity/notification_entity.dart';
import 'package:ngo/features/notification/domain/usecase/fetch_notification_usecase.dart';
import '../../data/model/notification_model.dart';

class NotificationController extends GetxController {

  final FetchNotificationUsecase fetchNotificationsUsecase;

  NotificationController(this.fetchNotificationsUsecase);

  var notifications = <NotificationEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications("enamul@gmail.com"); // Hardcoded or dynamic email context
  }

  Future<void> fetchNotifications(String email) async {
    try {
      isLoading(true);
      errorMessage('');
      notifications.value = [];

      notifications.value = await fetchNotificationsUsecase(email);

    } on AppException catch (e) {
      errorMessage(e.message ?? "An unexpected network error occurred.");
    } finally {
      isLoading(false);
    }
  }
}
