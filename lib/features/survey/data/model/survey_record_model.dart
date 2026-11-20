import 'dart:convert';

import '../../domain/entity/survey_record.dart';

class SurveyRecordModel extends SurveyRecord {
  const SurveyRecordModel({
    required super.id,
    required super.answers,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.syncedAt,
    super.lastError,
  });

  factory SurveyRecordModel.fromMap(Map<String, Object?> map) {
    final statusName = map['status'] as String? ?? 'draft';
    final status = SurveySyncStatus.values.firstWhere(
          (value) => value.name == statusName,
      orElse: () => SurveySyncStatus.draft,
    );
    return SurveyRecordModel(
      id: map['id'] as String,
      answers: Map<String, dynamic>.from(
        jsonDecode(map['answers_json'] as String) as Map,
      ),
      status: status,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      syncedAt: map['synced_at'] == null
          ? null
          : DateTime.parse(map['synced_at'] as String),
      lastError: map['last_error'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'answers_json': jsonEncode(answers),
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'synced_at': syncedAt?.toIso8601String(),
    'last_error': lastError,
  };
}
