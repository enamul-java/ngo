
import 'analytics_event.dart';

abstract interface class AppAnalytics {
  Future<void> logEvent(
      AnalyticsEvent event, {
        Map<String, Object>? parameters,
      });

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}
