
abstract interface class ApiTokenProvider {
  Future<String?> getAccessToken();

  Future<String?> refreshAccessToken();
}