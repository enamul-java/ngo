
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngo/features/notification/data/datasource/remote_notification_datasource.dart';
import 'package:ngo/features/notification/data/model/notification_model.dart';
import 'package:ngo/features/notification/domain/entity/notification_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/repository/notification_repo.dart';
import '../datasource/local_notification_datasource.dart';

class NotificationRepoImple extends NotificationRepo{

  final LocalNotificationDatasource local;
  final RemoteNotificationDatasource remote;
  final Connectivity? connectivity;

  NotificationRepoImple(this.connectivity, this.local, this.remote);

  @override
  Future<List<NotificationEntity>> fetchNotifications(String email) async {

    final connectivityResult = await connectivity?.checkConnectivity();
    final isOffline = connectivityResult?.every(
          (result) => result == ConnectivityResult.none,
    );

    // If the device is known to be offline, do not waste time calling API.
    if (isOffline ?? false) {
      return _readCacheOrThrow();
    }

    try {
      List<NotificationEntity> list = [];
      List<NotificationModel> res = await remote.fetchNotifications(email);
      for (var element in res) {
        list.add(NotificationModel.toEntity(element));
      }
      int count  = await local.getNotificationCount();
      debugPrint("Local Count : ${count.toString()} and Remote Count : ${res.length.toString()}");

      if(res.length>count) {
        await local.saveData(list);
      }
    }catch(e){
      debugPrint("Online Data Face Exception : "+e.toString());
    } finally {
      //Offline Cache Data
      return await _readCacheOrThrow();
    }
  }

  Future<List<NotificationEntity>> _readCacheOrThrow() async {
    //Offline Cache Data
    final cached = await local.getNotificationList();
    if (cached == null) {
      throw const NetworkException(
        'You are offline and no cached notification data is available.',
      );
    }
    return cached;
  }

  @override
  Future<bool> deleteNotification() async {
    final res = await local.clearNotification();
    return res;
  }
}