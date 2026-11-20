import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/survey_record.dart';
import '../../domain/usecase/load_latest_survey.dart';
import '../../domain/usecase/save_draft.dart';
import '../../domain/usecase/submit_survey.dart';
import '../../domain/usecase/sync_pending_surveys.dart';
import 'add_health_survey_state.dart';

class AddSurveyCubit extends Cubit<AddSurveyState> {

  //UseCases
  final LoadLatestSurvey loadLatestSurvey;
  final SaveDraft saveDraft;
  final SubmitSurvey submitSurvey;
  final SyncPendingSurveys syncPendingSurveys;

  //Unique ID
  String surveyId = const Uuid().v4();

  Timer? _saveDebounce;

  AddSurveyCubit({
    required this.loadLatestSurvey,
    required this.saveDraft,
    required this.submitSurvey,
    required this.syncPendingSurveys,
  }) : super(const AddSurveyState());

  Future<void> load() async {
    emit(state.copyWith(status: SurveyUiStatus.loading, clearMessage: true));
    try {
      final record = await loadLatestSurvey();
      if (record != null) surveyId = record.id;
      final answers = record?.answers ?? <String, dynamic>{};
      emit(_withProgress(state.copyWith(
        status: SurveyUiStatus.ready,
        answers: answers,
        syncStatus: record?.status,
        clearMessage: true,
      )));
    } catch (_) {
      emit(state.copyWith(
        status: SurveyUiStatus.error,
        message: 'Could not read the local survey. Please try again.',
      ));
    }
  }

  void updateAnswer(String key, dynamic value) {
    final answers = Map<String, dynamic>.from(state.answers)..[key] = value;
    emit(_withProgress(state.copyWith(
      status: SurveyUiStatus.ready,
      answers: answers,
      clearMessage: true,
    )));
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 450), () {
      saveDraft(surveyId, answers).then((_) {
        if (!isClosed) {
          emit(state.copyWith(
            syncStatus: SurveySyncStatus.draft,
            message: 'Draft saved on this device',
          ));
        }
      }).catchError((e) {
        debugPrint("SaveDraft err ${e.toString()}");
        if (!isClosed) {
          emit(state.copyWith(message: 'Could not save this draft locally.'));
        }
      });
    });
  }

  Future<void> saveNow() async {
    _saveDebounce?.cancel();
    emit(state.copyWith(status: SurveyUiStatus.saving, clearMessage: true));
    try {
      await saveDraft(surveyId, state.answers);
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        syncStatus: SurveySyncStatus.draft,
        message: 'Draft saved on this device',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        message: 'Could not save the draft. Please retry.',
      ));
    }
  }

  Future<void> submit() async {
    _saveDebounce?.cancel();
    emit(state.copyWith(
      status: SurveyUiStatus.submitting,
      clearMessage: true,
    ));
    try {
      final record = await submitSurvey(surveyId, state.answers);
      final message = switch (record.status) {
        SurveySyncStatus.synced => 'Survey submitted successfully.',
        SurveySyncStatus.pending =>
        'Saved on this device. It is waiting for a connection.',
        SurveySyncStatus.failed =>
        'Saved locally, but server submission failed. You can retry sync.',
        SurveySyncStatus.draft => 'Survey saved as a draft.',
      };
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        syncStatus: record.status,
        message: message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        message: 'Could not save the survey locally. Please retry.',
      ));
    }
  }

  Future<void> syncPending() async {
    emit(state.copyWith(status: SurveyUiStatus.submitting, clearMessage: true));
    try {
      final count = await syncPendingSurveys();
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        message: count > 0
            ? '$count pending survey(s) synchronized.'
            : 'No pending surveys synchronized. Check connection or API settings.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SurveyUiStatus.ready,
        message: 'Sync could not run. Your local data is preserved.',
      ));
    }
  }

  AddSurveyState _withProgress(AddSurveyState value) {
    final completed = value.answers.values.where((v) {
      if (v == null) return false;
      if (v is String) return v.trim().isNotEmpty;
      if (v is List) return v.isNotEmpty;
      return true;
    }).length;
    return value.copyWith(
      completedFields: completed,
      totalFields: SurveyFields.allKeys.length,
    );
  }

  @override
  Future<void> close() {
    _saveDebounce?.cancel();
    return super.close();
  }

}

class SurveyFields {
  SurveyFields._();
  static const allKeys = <String>[
    'firstName','lastName','surveyDate','email','phone','street','street2',
    'city','stateProvince','postalCode','preferredContacts','birthDate','age',
    'gender','conditions','medications','pregnant','nursing','foodAllergies',
    'allergyDescription','heightInches','weightLbs','currentBmi','targetBmi',
    'bedTime','wakeTime','sleepHours','rested','sleepQuality','waterPerDay',
    'coffeePerDay','alcoholPerWeek','exercisePerWeek','exerciseType',
    'activityLimitations','energyLevel','occupation','enjoyWork','stressors',
    'stressLevel','firstMeal','lastMeal','mealsPerDay','snacks','eatOutFrequency',
    'eatOutLocation','currentWeight','goalWeight','height','triedWeightLoss',
    'weightLossDifficulty','smoking','exerciseFrequency','sleepDuration',
  ];
}
