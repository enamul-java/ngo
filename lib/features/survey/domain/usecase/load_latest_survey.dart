

import '../entity/survey_record.dart';
import '../repository/survey_repository.dart';

class LoadLatestSurvey {
  final SurveyRepository repository;
  const LoadLatestSurvey(this.repository);

  Future<SurveyRecord?> call() => repository.loadLatest();
}
