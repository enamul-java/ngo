import 'dart:convert';
import 'package:http/http.dart' as http;

import '../error/app_exception.dart';

class ApiClient {
  // For iOS Simulator / macOS-hosted API:
  // http://localhost/ngo/api/v1/auth/
  //
  // Android Emulator:
  // http://10.0.2.2/ngo/api/v1/auth/
  //
  // Physical device:
  // http://YOUR_COMPUTER_LAN_IP/ngo/api/v1/auth/
  static const String baseUrl = 'http://192.168.0.126:9191/ngo/api/v1/auth/';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      Map<String, dynamic> json = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) json = decoded;
        } catch (_) {}
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json;
      }

      throw ServerException(
            json['message']?.toString() ??
            json['error']?.toString() ?? 'Request failed (${response.statusCode})',
            statusCode: response.statusCode,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      print(" Unknown Exception: ==>>>> "+e.toString());
      throw const ServerException(
        'Unable to connect to the server. Please check the API URL and network.',
      );
    }
  }
}
