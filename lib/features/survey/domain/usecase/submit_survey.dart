import '../entity/survey_record.dart';
import '../repository/survey_repository.dart';

class SubmitSurvey {
  final SurveyRepository repository;
  const SubmitSurvey(this.repository);

  Future<SurveyRecord> call(String id, Map<String, dynamic> answers) =>
      repository.submit(id, answers);
}