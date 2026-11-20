
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngo/features/survey/domain/usecase/surveys_usecase.dart';

import 'health_survey_state.dart';


class HealthSurveyCubit extends Cubit<HealthSurveyState> {

  final SurveyListUsecase surveyListUseCase;

  HealthSurveyCubit({required this.surveyListUseCase})
      : super(const HealthSurveyInitial());

  Future<void> fetchSurveys({
    int page = 0,
    int size = 20,
  }) async {
    emit(const HealthSurveyLoading());

    try {
      final result = await surveyListUseCase(
        page,
        size,
      );

      emit(HealthSurveyLoaded(result));
    } catch (e) {
      emit(
        HealthSurveyError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
