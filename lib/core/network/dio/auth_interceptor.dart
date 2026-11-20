import 'dart:async';

import 'package:dio/dio.dart';

import 'api_token_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._tokens);

  final Dio _dio;
  final ApiTokenProvider _tokens;

  Future<String?>? _refreshing;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await _tokens.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
        ),
      );
    }
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        request.extra['retried'] == true ||
        request.path.startsWith('/auth/')) {
      handler.next(err);
      return;
    }

    try {
      final token = await (_refreshing ??= _tokens
          .refreshAccessToken()
          .whenComplete(() => _refreshing = null));

      if (token == null || token.isEmpty) {
        handler.next(err);
        return;
      }

      request.headers['Authorization'] = 'Bearer $token';
      request.extra['retried'] = true;

      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }
}