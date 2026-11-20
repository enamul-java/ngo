

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngo/features/survey/data/model/survey_model.dart';

import '../../domain/entity/survey_record.dart';
import '../../domain/repository/survey_repository.dart';
import '../datasource/local_survey_data_source.dart';
import '../datasource/remote_survey_datasource.dart';
import '../model/survey_record_model.dart';

class SurveyRepositoryImpl implements SurveyRepository{

  final RemoteSurveyDataSource remoteDataSource;
  final LocalSurveyDataSource localDataSource;
  final Connectivity connectivity;

  SurveyRepositoryImpl(this.remoteDataSource,this.localDataSource, this.connectivity);

  @override
  Future<SurveyRecord?> loadLatest() => localDataSource.loadLatest();

  @override
  Future<void> saveDraft(String id, Map<String, dynamic> answers) async {

    debugPrint("Answer to saveDaft $answers");

    final now = DateTime.now();
    final existing = await localDataSource.loadLatest();
    final record = SurveyRecordModel(
      id: id,
      answers: Map<String, dynamic>.from(answers),
      status: existing?.id == id &&
          (existing?.status == SurveySyncStatus.pending ||
              existing?.status == SurveySyncStatus.failed)
          ? existing!.status
          : SurveySyncStatus.draft,
      createdAt: existing?.id == id ? existing!.createdAt : now,
      updatedAt: now,
      syncedAt: existing?.id == id ? existing!.syncedAt : null,
      lastError: existing?.id == id ? existing!.lastError : null,
    );
    await localDataSource.upsert(record);
  }

  @override
  Future<SurveyRecord> submit(
      String id,
      Map<String, dynamic> answers,
      ) async {
    final now = DateTime.now();
    final existing = await localDataSource.loadLatest();
    final pending = SurveyRecordModel(
      id: id,
      answers: Map<String, dynamic>.from(answers),
      status: SurveySyncStatus.pending,
      createdAt: existing?.id == id ? existing!.createdAt : now,
      updatedAt: now,
    );

    // Persist before attempting network I/O: no survey is lost if offline.
    await localDataSource.upsert(pending);

    try {
      final network = await connectivity.checkConnectivity();
      debugPrint("remote submit: NetState ${network.length}");
      if (network.contains(ConnectivityResult.none)) {
        return pending;
      }
      await remoteDataSource.submit(pending);
      final synced = SurveyRecordModel(
        id: pending.id,
        answers: pending.answers,
        status: SurveySyncStatus.synced,
        createdAt: pending.createdAt,
        updatedAt: DateTime.now(),
        syncedAt: DateTime.now(),
      );
      await localDataSource.upsert(synced);
      return synced;
    } catch (error) {
      debugPrint("remote submit: Error ${error.toString()}");
      final failed = SurveyRecordModel(
        id: pending.id,
        answers: pending.answers,
        status: SurveySyncStatus.failed,
        createdAt: pending.createdAt,
        updatedAt: DateTime.now(),
        lastError: error.toString(),
      );
      await localDataSource.upsert(failed);
      return failed;
    }
  }

  @override
  Future<int> syncPending() async {
    final network = await connectivity.checkConnectivity();
    if (network.contains(ConnectivityResult.none)) return 0;

    final pendingRecords = await localDataSource.loadPending();
    var syncedCount = 0;
    for (final record in pendingRecords) {
      try {
        await remoteDataSource.submit(record);
        await localDataSource.upsert(SurveyRecordModel(
          id: record.id,
          answers: record.answers,
          status: SurveySyncStatus.synced,
          createdAt: record.createdAt,
          updatedAt: DateTime.now(),
          syncedAt: DateTime.now(),
        ));
        syncedCount++;
      } catch (error) {
        await localDataSource.upsert(SurveyRecordModel(
          id: record.id,
          answers: record.answers,
          status: SurveySyncStatus.failed,
          createdAt: record.createdAt,
          updatedAt: DateTime.now(),
          lastError: error.toString(),
        ));
      }
    }
    return syncedCount;
  }

  @override
  Future<PaginatedSurveys> getSurveyList(int page, int size) async {
    return await remoteDataSource.getSurveyList(page: page, size: size);
  }

}