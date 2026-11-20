

import 'package:ngo/features/survey/data/model/survey_model.dart';

import '../entity/survey_record.dart';

abstract class SurveyRepository {
  Future<PaginatedSurveys> getSurveyList(int page, int size);

  Future<SurveyRecord?> loadLatest();
  Future<void> saveDraft(String id, Map<String, dynamic> answers);
  Future<SurveyRecord> submit(String id, Map<String, dynamic> answers);
  Future<int> syncPending();
}