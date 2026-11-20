

import '../../data/model/auth_user_profile.dart';
import '../../domian/entity/oauth_session.dart';

sealed class OAuthState {}

final class AuthInitial extends OAuthState {}

final class AuthLoading extends OAuthState {}

final class AuthAuthenticated extends OAuthState {
  AuthAuthenticated(this.session, this.user);

  final OAuthSession session;
  final AuthUserProfile user;
}

final class AuthUnauthenticated extends OAuthState {
}

final class AuthFailure extends OAuthState {
  AuthFailure(this.message);

  final String message;
}
