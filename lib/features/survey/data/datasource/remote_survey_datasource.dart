


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngo/core/log/debug_logging.dart';
import 'package:ngo/features/survey/data/model/survey_model.dart';

import '../../../../core/error/err_handler.dart';
import '../../domain/entity/survey_record.dart';

class RemoteSurveyDataSource{
  final Dio dio;
  RemoteSurveyDataSource(this.dio);

  Future<void> submit(SurveyRecord record) async {
    debugPrint("remote submit: ${record.toString()}");
    debugPrint("remote submit: ${dio.options.baseUrl}");
    await dio.post(
      'health-surveys',
      data: {
        'clientSubmissionId': record.id,
        'answers': record.answers,
        'submittedAt': record.updatedAt.toUtc().toIso8601String(),
      },
      options: Options(
        headers: {'Idempotency-Key': record.id},
      ),
    );
  }

  Future<PaginatedSurveys> getSurveyList({
    required int page,
    required int size,
  }) async {
    try {
      DebugLogging.log("SurveyLocalDataSource: ${dio.options.baseUrl}");

      final response = await dio.get(
        'surveys',
        queryParameters: {
          'page' : page,
          'size': size
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const FormatException('Invalid weather response.');
      }

      return PaginatedSurveys.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      DebugLogging.logError(error.toString());
      throw ErrorHandler.handle(error);
    }
  }
}