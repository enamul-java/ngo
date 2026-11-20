import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/notifications/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'di.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/presentation/pages/login_keyloak.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/moon_alert/presentation/screen/moon_alert_home.dart';
import 'features/navigation_drawer/presentation/page/dashboard_page.dart';
import 'features/oauth/presentation/bloc/oauth_bloc.dart';
import 'features/oauth/presentation/bloc/oauth_bloc_event.dart';
import 'features/oauth/presentation/page/oauth_app_page.dart';
import 'features/survey/presentation/cubit/health_surrey_cubit.dart';
import 'features/survey/presentation/pages/suerveys_page.dart';
import 'firebase_options.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:ngo/core/config/keycloak_config.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //-----------> Firebase Config <--------------
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FirebaseAnalytics.instance
      .setAnalyticsCollectionEnabled(true);

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Enable Developer Mode for In-App Messaging during development
  if (kDebugMode) {
    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
    // Note: The native Android SDK automatically enables developer mode
    // when running a standard debug APK build connected to ADB.
  }
  //-----------> Firebase Config <--------------

  //-----------> keyloak oauth login <--------------
  //-----------> keyloak oauth login <--------------

  final apiClient = ApiClient();
  final dataSource = AuthRemoteDataSourceImpl(apiClient);
  final repository = AuthRepositoryImpl(dataSource);

  await configureDependencies();

  // Wait until the database and all dependent data sources are fully ready
  await getIt.allReady();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(
        loginUseCase: Login(repository),
        registerUseCase: Register(repository),
      ),
      //child: const ExpenseDashboardApp(),
      //child: const NgoAuthApp(),
      //child: const LoginKeycloak(),
      child: const OAuthApp(),
    ),
  );
}

class NgoAuthApp extends StatelessWidget {
  const NgoAuthApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NGO Auth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      //home: const OpenNativeScreenForResult(),
      home: const LoginPage(),
      //home: const MunAlertApp(),
      /*home: BlocProvider(
        create: (_) => getIt<HealthSurveyCubit>()
          ..fetchSurveys(page: 0, size: 20),
        child: const HealthSurveyPage(),
      ),*/
    );
  }
}
