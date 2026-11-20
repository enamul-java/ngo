import 'package:ngo/features/oauth/data/model/auth_user_profile.dart';

class OAuthSession {
  const OAuthSession({
    required this.accessToken,
    required this.expiresAt,
    this.refreshToken,
    this.idToken,
    this.userProfile
  });

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? expiresAt;
  final AuthUserProfile? userProfile;

  bool get isExpired {
    final expiry = expiresAt;
    if (expiry == null) return true;

    // Refresh slightly before actual expiry.
    return DateTime.now().isAfter(
      expiry.subtract(const Duration(seconds: 30)),
    );
  }
}