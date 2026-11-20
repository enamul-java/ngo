import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/oauth/domian/entity/oauth_session.dart';


class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _sessionKey = 'oidc_session';

  Future<void> save(OAuthSession session) async {
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode({
        'accessToken': session.accessToken,
        'refreshToken': session.refreshToken,
        'idToken': session.idToken,
        'expiresAt': session.expiresAt?.toIso8601String(),
      }),
    );
  }

  Future<OAuthSession?> read() async {
    final raw = await _storage.read(key: _sessionKey);

    if (raw == null) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;

      final accessToken = json['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        await clear();
        return null;
      }

      return OAuthSession(
        accessToken: accessToken,
        refreshToken: json['refreshToken'] as String?,
        idToken: json['idToken'] as String?,
        expiresAt: DateTime.tryParse(
          json['expiresAt'] as String? ?? '',
        ),
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }
}