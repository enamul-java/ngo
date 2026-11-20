
import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorHandler {
  const ErrorHandler._();

  static AppException handle(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException(
            'The request timed out. Please try again.',
          );

        case DioExceptionType.connectionError:
          return const NetworkException(
            'Unable to connect to the server. Check your internet connection.',
          );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;

          if (statusCode != null && statusCode >= 500) {
            return ServerException(
              'The server is temporarily unavailable.',
              statusCode: statusCode,
            );
          }

          return ApiException(
            _responseMessage(error.response) ??
                'The server returned an invalid response.',
          );

        case DioExceptionType.cancel:
          return const ApiException('The request was cancelled.');

        case DioExceptionType.badCertificate:
          return const NetworkException(
            'A secure connection to the server could not be established.',
          );

        case DioExceptionType.unknown:
          return const NetworkException(
            'A network error occurred. Please try again.',
          );
        case DioExceptionType.transformTimeout:
          return const NetworkException(
            'Connection time out. Please try again.',
          );
      }
    }

    if (error is FormatException) {
      return ParseException(error.message);
    }

    return UnknownException(
      error.toString().replaceFirst('Exception: ', ''),
    );
  }

  static String? _responseMessage(Response<dynamic>? response) {
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      final reason = data['reason'];
      if (reason is String && reason.isNotEmpty) {
        return reason;
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}
