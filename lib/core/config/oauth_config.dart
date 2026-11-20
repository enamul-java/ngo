
class OAuthConfig {
  OAuthConfig._();

  // Use a hostname reachable by the device.
  // Android emulator: often http://10.0.2.2:8080
  // Physical device: use your computer's LAN IP or a
  // reachable HTTPS development hostname.
  static const issuer =
      'http://192.168.0.115:8080/realms/mobileapps';

  static const clientId = 'ngo-app-client';

  static const redirectUri =
      'com.ehaquesoft.ngo:/oauth2redirect';

  static const postLogoutRedirectUri =
      'com.ehaquesoft.ngo:/oauth2redirect';

  static const apiBaseUrl =
      'http://192.168.0.115:8084';

  static const scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
  ];
}