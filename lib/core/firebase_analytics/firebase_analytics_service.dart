
import 'package:firebase_analytics/firebase_analytics.dart';

import 'app_analytics.dart';
import 'analytics_event.dart';

class FirebaseAnalyticsService implements AppAnalytics {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  static const Map<AnalyticsEvent, String> _eventNames = {
    AnalyticsEvent.sessionRestore: 'session_restore',
    AnalyticsEvent.sessionRestoreFail: 'session_restore_fail',
    AnalyticsEvent.sessionRestoreSuccess: 'session_restore_success',
    AnalyticsEvent.loginAttempt: 'login_attempt',
    AnalyticsEvent.loginSuccess: 'login_success',
    AnalyticsEvent.loginFailure: 'login_failure',
    AnalyticsEvent.screenViewed: 'screen_view',
    AnalyticsEvent.paymentInitiated: 'payment_initiated',
    AnalyticsEvent.paymentSuccess: 'payment_success',
    AnalyticsEvent.paymentFailure: 'payment_failure',
    AnalyticsEvent.featureUsed: 'feature_used',
  };

  @override
  Future<void> logEvent(
      AnalyticsEvent event, {
        Map<String, Object>? parameters,
      }) async {
    await _analytics.logEvent(
      name: _eventNames[event]!,
      parameters: parameters,
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(
      name: name,
      value: value,
    );
  }
}
