

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngo/features/oauth/data/model/auth_user_profile.dart';

import '../../../../core/firebase_analytics/analytics_event.dart';
import '../../../../core/firebase_analytics/app_analytics.dart';
import '../../domian/repository/oauth_repository.dart';
import 'oauth_bloc_event.dart';
import 'oauth_bloc_state.dart';

class OAuthBloc extends Bloc<OAuthEvent, OAuthState> {

  OAuthBloc(this._repository, this._analytics) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  final OAuthRepository _repository;
  final AppAnalytics _analytics;

  // Analytics must never prevent the authentication flow.
  Future<void> _track(
      AnalyticsEvent event, {
        Map<String, Object>? parameters,
      }) async {
    try {
      debugPrint("EventLog: $event");
      await _analytics.logEvent(
        event,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('EventLog: $event. Error: $e');
      // Send the error to your internal diagnostics system
      // if appropriate. Never expose sensitive data.
    }
  }

  Future<void> _onStarted(
      AuthStarted event,
      Emitter<OAuthState> emit,
      ) async {
    emit(AuthLoading());

    await _track(
      AnalyticsEvent.sessionRestore,
      parameters: {'method': '_onStarted'},
    );

    try {
      final session = await _repository.restoreSession();

      if (session == null) {
        await _track(
          AnalyticsEvent.sessionRestoreFail,
          parameters: {
            'method': '_onStarted',
            'reason': 'Session is null.'
          },
        );
        emit(AuthUnauthenticated());
      } else {
        await _track(
          AnalyticsEvent.sessionRestoreSuccess,
          parameters: {
            'method': '_onStarted',
            'result': 'Successful'
          },
        );
        emit(AuthAuthenticated(session,session.userProfile!));
      }
    } catch (_) {
      await _track(
        AnalyticsEvent.sessionRestoreFail,
        parameters: {
          'method': '_onStarted',
          'reason': 'Unable to restore the session.'
        },
      );
      emit(AuthFailure('Unable to restore the session.'));
    }
  }

  Future<void> _onLogin(
      LoginRequested event,
      Emitter<OAuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final session = await _repository.login();

      if (session == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(session, session.userProfile!));
      }
    } catch (_) {
      emit(AuthFailure(
        'Login failed. Check your connection and try again.',
      ));
    }
  }

  Future<void> _onLogout(
      LogoutRequested event,
      Emitter<OAuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await _repository.logout();
      emit(AuthUnauthenticated());
    } catch (_) {
      // Repository should clear local tokens even if remote
      // logout fails. Surface the failure without exposing data.
      emit(AuthFailure('Logout could not be completed.'));
    }
  }
}