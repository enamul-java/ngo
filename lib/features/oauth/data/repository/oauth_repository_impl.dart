


import '../../../../core/security/secure_token_storage.dart';
import '../../domian/entity/oauth_session.dart';
import '../../domian/repository/oauth_repository.dart';
import '../datasource/keycloak_auth_datasource.dart';

class OAuthRepositoryImpl implements OAuthRepository {

  OAuthRepositoryImpl(this._keycloak, this._storage);

  final KeycloakAuthDataSource _keycloak;
  final TokenStorage _storage;

  OAuthSession? _session;

  @override
  Future<OAuthSession?> login() async {
    final session = await _keycloak.login();

    if (session == null) return null;

    await _storage.save(session);
    _session = session;
    return session;
  }

  @override
  Future<OAuthSession?> restoreSession() async {
    _session = await _storage.read();

    if (_session == null) return null;

    if (!_session!.isExpired) return _session;

    return refreshSession();
  }

  @override
  Future<OAuthSession?> refreshSession() async {
    final current = _session ?? await _storage.read();

    if (current == null) return null;

    final updated = await _keycloak.refresh(current);

    if (updated == null) {
      _session = null;
      await _storage.clear();
      return null;
    }

    await _storage.save(updated);
    _session = updated;
    return updated;
  }

  @override
  Future<void> logout() async {
    final current = _session ?? await _storage.read();

    try {
      await _keycloak.logout(current);
    } finally {
      _session = null;
      await _storage.clear();
    }
  }
}