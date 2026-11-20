

sealed class APIRes<T>{}
class Success<T> extends APIRes<T>{
  final T data;
  Success(this.data);
}

class Err<T> extends APIRes<T> {
  final String message;
  final int code;

  Err(this.message, this.code);
}

String getApiResult(APIRes<String> res){
  return switch (res) {
    Success(data: var value) => value,
    Err(message: var message, code: var code) => message,
  };
}

// 1. Define the sealed class and all direct subtypes in the same file
sealed class Result {}

class Success2 extends Result {
  final String data;
  Success2(this.data);
}

class Failure extends Result {
  final String error;
  Failure(this.error);
}

// 2. Use exhaustive pattern matching in a switch expression
String handleResult(Result result) {
  return switch (result) {
    Success2(data: var d) => 'Got: $d',
    Failure(error: var e) => 'Error: $e',
  // If you add a new subtype (e.g., Loading) and forget to add it here,
  // Dart will show a compile-time error.
  };
}