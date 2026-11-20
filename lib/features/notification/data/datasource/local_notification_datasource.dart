

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ngo/core/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entity/notification_entity.dart';
import 'package:ngo/features/notification/data/model/notification_model.dart';

class LocalNotificationDatasource {

  final AppDatabase database;

  LocalNotificationDatasource(this.database);

  Future<List<NotificationEntity>?> getNotificationList() async {
    final rows = await database.db.query(
      'notification',
      orderBy: 'notification_id ASC',
    );
    debugPrint("Rows : "+rows.toString());
    return _toNotificationList(rows);
  }

  Future<int> getNotificationCount() async {
    final rows = await database.db.rawQuery(
      '''
      SELECT COUNT(*) 
      FROM notification 
      WHERE status = "U" 
      ''',
    );
    //await clearNotification();
    debugPrint("Rows Count : "+rows.toString());
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  Future<int> getNotificationCountWithId(int id) async {
    final rows = await database.db.rawQuery(
      '''
      SELECT COUNT(*) 
      FROM notification 
      WHERE notification_id = $id 
      ''',
    );
    debugPrint("Rows Count with id $id : "+rows.toString());
    return Sqflite.firstIntValue(rows) ?? 0;
  }


  Future<void> saveData(List<NotificationEntity> list) async {

        debugPrint("List : ${list.length}");

        //final batch = database.db.batch();

        for(var element in list){
          try {
            final count = await getNotificationCountWithId(element.id);
            if(count<1) {
              database.db.insert(
                'notification',
                _toNotificationMap(element),
                conflictAlgorithm: ConflictAlgorithm.ignore,
              );
            }
          }catch(e){
            debugPrint(e.toString());
          }
        }
        //await batch.commit(noResult: true);
  }

  static Map<String, dynamic> _toNotificationMap(NotificationEntity entity) =>
      {
        'notification_id': entity.id,
        'email': entity.email,
        'user': jsonEncode(_toUserMap(entity.user ??
            UserModelEntity(id: 0, name: '', email: '', gender: '', dob: '', address: ''))),
        'title': entity.title,
        'message': entity.message,
        'imageUrl': entity.imageUrl,
        'topic': entity.topic,
        'date': entity.date,
        'status': 'U',
      };

  static Map<String, dynamic> _toUserMap(UserModelEntity entity) => {
    'id': entity.id,
    'name': entity.name,
    'email': entity.email,
    'gender': entity.gender,
    'dob': entity.dob,
    'address': entity.address,
  };

  static Future<List<NotificationEntity>?> _toNotificationList(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) {
      return null;
    }

    return rows.map((row) => NotificationEntity(
      id: row['notification_id'] as int,
      email: row['email'] as String,
      user: UserModel.toEntity(UserModel.fromJson(_toUserModel(row['user'] as String))),
      title: row['title'] as String,
      message: row['message'] as String,
      imageUrl: row['imageUrl'] as String,
      topic: row['topic'] as String,
      date: row['date'] as String
    )).toList();
  }

  static Map<String, dynamic> _toUserModel(String? userJson)=>
      userJson != null ? jsonDecode(userJson) : {};

  Future<bool> clearNotification() async {
    try{
      database.db.delete(
        'notification',
      );
    }catch(e){
      debugPrint("Delete Err: ${e.toString()}");
      return false;
    }
    return true;
  }
}