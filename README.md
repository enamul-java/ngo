# NGO Auth — Flutter Clean Architecture

## API

Base URL:
`http://localhost/ngo/api/v1/auth/`

Endpoints:
- `POST /register`
- `POST /login`

## Architecture

UI
→ Provider
→ Use Case
→ Repository
→ Remote Data Source
→ API Client
→ REST API

## Run

```bash
flutter pub get
flutter run
```

## IMPORTANT: localhost

`localhost` refers to the device/emulator itself.

### Android Emulator

Use:

```dart
static const String baseUrl =
    'http://10.0.2.2/ngo/api/v1/auth/';
```

### iOS Simulator

Usually:

```dart
static const String baseUrl =
    'http://localhost/ngo/api/v1/auth/';
```

### Physical device

Use your computer's LAN IP:

```dart
static const String baseUrl =
    'http://192.168.1.100/ngo/api/v1/auth/';
```

The phone and development computer must be reachable on the same network.

## Android local HTTP

For development, if Android blocks HTTP traffic, add this to the `<application>` element in:

`android/app/src/main/AndroidManifest.xml`

```xml
android:usesCleartextTraffic="true"
```

Use HTTPS in production.

## Error handling

The API `message` field is surfaced to the user.

Examples:
- `Email already registered`
- `Invalid email or password`

The server's `trace` is deliberately not shown to users.

## Registration date

The date picker sends:

`DD/MM/YYYY`

matching the supplied API contract.
