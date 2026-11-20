import '../repository/survey_repository.dart';

class SaveDraft {
  final SurveyRepository repository;
  const SaveDraft(this.repository);

  Future<void> call(String id, Map<String, dynamic> answers) =>
      repository.saveDraft(id, answers);
}
