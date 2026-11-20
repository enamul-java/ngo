
import 'package:equatable/equatable.dart';

import '../../data/model/survey_model.dart';

sealed class HealthSurveyState extends Equatable {
  const HealthSurveyState();

  @override
  List<Object?> get props => [];
}

class HealthSurveyInitial extends HealthSurveyState {
  const HealthSurveyInitial();
}

class HealthSurveyLoading extends HealthSurveyState {
  const HealthSurveyLoading();
}

class HealthSurveyLoaded extends HealthSurveyState {
  final PaginatedSurveys result;

  const HealthSurveyLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class HealthSurveyError extends HealthSurveyState {
  final String message;

  const HealthSurveyError(this.message);

  @override
  List<Object?> get props => [message];
}
