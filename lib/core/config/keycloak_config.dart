
// Supplied with --dart-define so this file can be run against a real server
// without editing it:
//
//   flutter run -d windows \
//     --dart-define=KC_BASE_URL=http://localhost:8080 \
//     --dart-define=KC_REALM=winche-demo \
//     --dart-define=KC_CLIENT_ID=flutter-app \
//     --dart-define=KC_DESKTOP_REDIRECT=http://localhost:8765/callback
//
// Optional:
//
//   --dart-define=KC_REQUIRED_REALM_ROLE=staff
//       Admit only principals holding this realm role. Others are turned away
//       at login (KeycloakAccessDeniedException) or, for a restored or
//       refreshed session, land on the access-denied screen.
//   --dart-define=KC_SERVICE_ACCOUNT=true
//   --dart-define=KC_CLIENT_SECRET=backend-sa-secret
//       Sign in as the client's own service account (client-credentials
//       grant, no browser). KC_CLIENT_ID must then name a confidential client
//       with service accounts enabled. KC_CLIENT_SECRET is also passed to a
//       confidential client in browser-login mode.
//
// See example/README.md for a local Keycloak with a realm set up for all of
// these.
/*import 'package:keycloak_client/keycloak_client.dart';

const _baseUrl = String.fromEnvironment(
  'KC_BASE_URL',
  defaultValue: 'http://192.168.0.126:8080',
);
const _realm = String.fromEnvironment('KC_REALM', defaultValue: 'demo-realm');
const _clientId = String.fromEnvironment(
  'KC_CLIENT_ID',
  defaultValue: 'ngo-app-client',
);
const _clientSecret = String.fromEnvironment('KC_CLIENT_SECRET',
    //defaultValue: ''
    defaultValue: '2eSdgRZFy5u0x4Rv7R3on4M8iZPt3mBw9haZuO1YqBHlZIDpUulrvwCIjBLm07Ve1LIXNJ3bPRUjFcGx48Vt5g'
);
const _serviceAccount = bool.fromEnvironment('KC_SERVICE_ACCOUNT',
    defaultValue: true
);
const _requiredRealmRole = String.fromEnvironment('KC_REQUIRED_REALM_ROLE',
    defaultValue: 'uma_authorization'
);

/// Where Keycloak sends the browser back to.
///
/// Desktop defaults to a hosted page that bounces to the loopback listener,
/// because Keycloak rejects some loopback redirect URIs. Point it straight at
/// the loopback when your realm allows it, as the local test realm does.
const _desktopRedirect = String.fromEnvironment(
  'KC_DESKTOP_REDIRECT',
  defaultValue: 'https://winchetechnologies.co.uk/tools/oauth_redirect',
);
const _webRedirect = String.fromEnvironment(
  'KC_WEB_REDIRECT',
  defaultValue: 'https://winchetechnologies.co.uk/tools/oauth_redirect',
);

/// The KeycloakClient constructor rejects a service account without a secret;
/// checked up front so the app can say so instead of failing to start.
const _missingSecret = _serviceAccount && _clientSecret == '';

bool get missingSecret => _missingSecret;
bool get serviceAccount => _serviceAccount;
String get requiredRealmRole => _requiredRealmRole;

final client = KeycloakClient(
  clientConfig: ClientConfig(
    baseUrl: _baseUrl,
    realm: _realm,
    clientId: _clientId,
    clientSecret: _clientSecret == '' ? null : _clientSecret,
    grantType: _serviceAccount
        ? GrantType.clientCredentials
        : GrantType.authorizationCode,
    requiredRealmRoles: {if (_requiredRealmRole != '') _requiredRealmRole},
    refreshTimeout: const Duration(seconds: 3),
  ),
  desktopConfig: const DesktopConfig(redirectUri: _desktopRedirect),
  webConfig: const WebConfig(redirectUri: _webRedirect),
);
*/