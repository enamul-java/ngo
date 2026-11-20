import '../repository/survey_repository.dart';

class SyncPendingSurveys {
  final SurveyRepository repository;
  const SyncPendingSurveys(this.repository);

  Future<int> call() => repository.syncPending();
}