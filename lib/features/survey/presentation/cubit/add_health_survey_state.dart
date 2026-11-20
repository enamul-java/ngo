import 'package:equatable/equatable.dart';

import '../../domain/entity/survey_record.dart';


enum SurveyUiStatus { initial, loading, ready, saving, submitting, error }

class AddSurveyState extends Equatable {
  final SurveyUiStatus status;
  final Map<String, dynamic> answers;
  final SurveySyncStatus? syncStatus;
  final String? message;
  final int completedFields;
  final int totalFields;

  const AddSurveyState({
    this.status = SurveyUiStatus.initial,
    this.answers = const {},
    this.syncStatus,
    this.message,
    this.completedFields = 0,
    this.totalFields = 0,
  });

  double get progress =>
      totalFields == 0 ? 0 : completedFields / totalFields;

  AddSurveyState copyWith({
    SurveyUiStatus? status,
    Map<String, dynamic>? answers,
    SurveySyncStatus? syncStatus,
    String? message,
    bool clearMessage = false,
    int? completedFields,
    int? totalFields,
  }) =>
      AddSurveyState(
        status: status ?? this.status,
        answers: answers ?? this.answers,
        syncStatus: syncStatus ?? this.syncStatus,
        message: clearMessage ? null : message ?? this.message,
        completedFields: completedFields ?? this.completedFields,
        totalFields: totalFields ?? this.totalFields,
      );

  @override
  List<Object?> get props =>
      [status, answers, syncStatus, message, completedFields, totalFields];
}
