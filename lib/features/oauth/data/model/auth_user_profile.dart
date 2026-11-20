

class AuthUserProfile {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;

  const AuthUserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  factory AuthUserProfile.fromJson(Map<String, dynamic> json) {
    return AuthUserProfile(
      id: json['sub'] as String? ?? '',
      username: json['preferred_username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['given_name'] as String? ?? '',
      lastName: json['family_name'] as String? ?? '',
      fullName: json['name'] as String? ?? '',
    );
  }
}