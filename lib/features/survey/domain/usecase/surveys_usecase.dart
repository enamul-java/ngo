

import '../../data/model/survey_model.dart';
import '../repository/survey_repository.dart';

class SurveyListUsecase {
  final SurveyRepository repository;
  SurveyListUsecase(this.repository);

  Future<PaginatedSurveys> call(int page, int size) async
  => repository.getSurveyList(page, size);

}