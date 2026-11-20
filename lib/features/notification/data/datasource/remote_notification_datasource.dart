

import 'package:dio/dio.dart';
import 'package:ngo/core/error/app_exception.dart';

import '../../../../core/error/err_handler.dart';
import '../model/notification_model.dart';

class RemoteNotificationDatasource {
  final Dio dio;
  RemoteNotificationDatasource(this.dio);

  Future<List<NotificationModel>> fetchNotifications(String email) async {
    try {
      final response = await dio.get('notifications/all');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw const ApiException('Failed to load notifications.');
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}