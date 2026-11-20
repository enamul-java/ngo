import '../entity/oauth_session.dart';

abstract interface class OAuthRepository {
  Future<OAuthSession?> login();

  Future<OAuthSession?> restoreSession();

  Future<OAuthSession?> refreshSession();

  Future<void> logout();
}