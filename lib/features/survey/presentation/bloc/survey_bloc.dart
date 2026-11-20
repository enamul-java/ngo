

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngo/features/survey/presentation/bloc/survey_event.dart';

import '../../domain/usecase/surveys_usecase.dart';
import 'health_survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState>{

  final SurveyListUsecase surveyListUseCase;

  SurveyBloc(this.surveyListUseCase) : super(const HealthSurveyInitial()){
    on<GetSurveyList>((event, emit) async{

      final page = event.page ?? 0;
      final size = event.size ?? 20;

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
    });
  }
}