
import 'package:intl/intl.dart';
import 'package:ngo/features/notification/domain/entity/notification_entity.dart';

class NotificationModel {
  final int id;
  final String email;
  final UserModel? user;
  final String title;
  final String message;
  final String imageUrl;
  final String topic;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.email,
    this.user,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.topic,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      topic: json['topic'] ?? 'General',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy, hh:mm a').format(date);

  static NotificationEntity toEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      email: model.email,
      user: UserModel.toEntity(model.user ?? UserModel(id: 0, name: '', email: '', gender: '', dob: '', address: '')),
      title: model.title,
      message: model.message,
      imageUrl: model.imageUrl,
      topic: model.topic,
      date: model.formattedDate,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String dob;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
    );
  }

  static UserModelEntity toEntity(UserModel model) {
    return UserModelEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      gender: model.gender,
      dob: model.dob,
      address: model.address,
    );
  }
}
