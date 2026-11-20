import 'dart:convert';
import 'package:equatable/equatable.dart';

enum SurveySyncStatus { draft, pending, synced, failed }

class SurveyRecord extends Equatable {
  final String id;
  final Map<String, dynamic> answers;
  final SurveySyncStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final String? lastError;

  const SurveyRecord({
    required this.id,
    required this.answers,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.lastError,
  });

  String get encodedAnswers => jsonEncode(answers);

  @override
  List<Object?> get props =>
      [id, answers, status, createdAt, updatedAt, syncedAt, lastError];
}
