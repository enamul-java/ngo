
class NotificationEntity {
  final int id;
  final String email;
  final UserModelEntity? user;
  final String title;
  final String message;
  final String imageUrl;
  final String topic;
  final String date;

  NotificationEntity({
    required this.id,
    required this.email,
    this.user,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.topic,
    required this.date,
  });
}
class UserModelEntity {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String dob;
  final String address;

  UserModelEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dob,
    required this.address,
  });
}
