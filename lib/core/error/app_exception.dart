


sealed class AppException implements Exception {
  const AppException(this.message,{this.statusCode});
  final String message;
  final int? statusCode;
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

final class ApiException extends AppException {
  const ApiException(super.message);
}

final class ParseException extends AppException {
  const ParseException(super.message);
}

final class UnknownException extends AppException {
  const UnknownException(super.message);
}
