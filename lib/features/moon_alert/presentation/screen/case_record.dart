import 'dart:ui';

class CaseRecord {
  final String id, name, age, gender, location, lastSeen, status, description;
  final Color statusColor;

  const CaseRecord({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.lastSeen,
    required this.status,
    required this.statusColor,
    required this.description,
  });
}
