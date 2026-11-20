
import 'package:equatable/equatable.dart';

import '../../data/model/survey_model.dart';

sealed class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object?> get props => [];
}

class HealthSurveyInitial extends SurveyState {
  const HealthSurveyInitial();
}

class HealthSurveyLoading extends SurveyState {
  const HealthSurveyLoading();
}

class HealthSurveyLoaded extends SurveyState {
  final PaginatedSurveys result;

  const HealthSurveyLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class HealthSurveyError extends SurveyState {
  final String message;

  const HealthSurveyError(this.message);

  @override
  List<Object?> get props => [message];
}
