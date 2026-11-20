
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../firebase_options.dart';

/// Handles FCM messages when the app is in the background.
///
/// Must be a top-level function, not a class method.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('Background message ID: ${message.messageId}');
  debugPrint('Background message data: ${message.data}');
}

class NotificationService {
  NotificationService({
    this.onNotificationTap,
  });

  final void Function(Map<String, dynamic> data)? onNotificationTap;

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Important notifications from the application.',
    importance: Importance.high,
  );

  bool _initialized = false;

  /// Initialize local notifications, permissions, FCM listeners,
  /// and retrieve the device registration token.
  Future<String?> initialize() async {
    if (_initialized) {
      return _messaging.getToken();
    }

    await _initializeLocalNotifications();
    await _requestPermission();

    // Configure iOS foreground behavior.
    // Foreground notifications are displayed through the local
    // notification plugin to avoid duplicate banners.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    _registerMessageListeners();

    // Handle a notification that launched a terminated app.
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
    }

    // Retrieve the current FCM registration token.
    final token = await _messaging.getToken();

    debugPrint('FCM Token: $token');

    // Listen for token rotation.
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');

      // TODO: Send the updated token to your backend.
    });

    _initialized = true;

    return token;
  }

  /// Initialize the local notification plugin and Android channel.
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Request permission to display notifications.
  Future<AuthorizationStatus> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      'Notification permission: ${settings.authorizationStatus}',
    );

    // Also request permission through the local notification plugin.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus;
  }

  /// Register foreground and notification-tap listeners.
  void _registerMessageListeners() {
    // App is open and receives an FCM message.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground message received: ${message.messageId}');

      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');

      await showNotification(message);
    });

    // App was in the background and the user tapped a notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        _handleNotificationTap(message.data);
      },
    );
  }

  /// Display an FCM message as a local notification.
  Future<void> showNotification(RemoteMessage message) async {
    final title = message.notification?.title ??
        message.data['title']?.toString();

    final body = message.notification?.body ??
        message.data['body']?.toString();

    if ((title == null || title.isEmpty) &&
        (body == null || body.isEmpty)) {
      debugPrint('No notification title or body to display.');
      return;
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      id: message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title ?? 'New Notification',
      body: body ?? '',
      notificationDetails: notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle a local notification tap.
  void _onLocalNotificationTap(
      NotificationResponse response,
      ) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);

      if (decoded is Map) {
        _handleNotificationTap(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (error) {
      debugPrint('Unable to parse notification payload: $error');
    }
  }

  /// Handle notification navigation or business logic.
  void _handleNotificationTap(Map<String, dynamic> data) {
    debugPrint('Notification tapped: $data');

    onNotificationTap?.call(data);

    // Example payload:
    // {
    //   "type": "order",
    //   "orderId": "1001"
    // }
    //
    // Use onNotificationTap to navigate to the appropriate screen.
  }

  /// Subscribe the device to an FCM topic.
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe the device from an FCM topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  /// Retrieve the current FCM registration token.
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Delete the current FCM token, for example during logout.
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}
