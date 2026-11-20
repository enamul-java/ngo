

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:ngo/core/network/dio/auth_interceptor.dart';
import 'package:ngo/features/notification/data/datasource/remote_notification_datasource.dart';
import 'package:ngo/features/notification/data/repository/notification_repo_impl.dart';
import 'package:ngo/features/notification/domain/usecase/fetch_notification_usecase.dart';

import 'core/db/app_database.dart';
import 'core/firebase_analytics/app_analytics.dart';
import 'core/firebase_analytics/firebase_analytics_service.dart';
import 'core/network/api_config.dart';
import 'core/network/dio/api_token_provider.dart';
import 'core/network/dio/repository_api_token_provider.dart';
import 'core/security/secure_token_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/notification/data/datasource/local_notification_datasource.dart';
import 'features/notification/domain/repository/notification_repo.dart';
import 'features/notification/presentation/getx/notification_controller.dart';
import 'features/oauth/data/datasource/keycloak_auth_datasource.dart';
import 'features/oauth/data/repository/oauth_repository_impl.dart';
import 'features/oauth/domian/repository/oauth_repository.dart';
import 'features/oauth/presentation/bloc/oauth_bloc.dart';
import 'features/survey/data/datasource/local_survey_data_source.dart';
import 'features/survey/data/datasource/remote_survey_datasource.dart';
import 'features/survey/data/repository/survey_repository_impl.dart';
import 'features/survey/domain/repository/survey_repository.dart';
import 'features/survey/domain/usecase/load_latest_survey.dart';
import 'features/survey/domain/usecase/save_draft.dart';
import 'features/survey/domain/usecase/submit_survey.dart';
import 'features/survey/domain/usecase/surveys_usecase.dart';
import 'features/survey/domain/usecase/sync_pending_surveys.dart';
import 'features/survey/presentation/cubit/add_health_survey_cubit.dart';
import 'features/survey/presentation/cubit/health_surrey_cubit.dart';

final GetIt getIt = GetIt.instance;

//Network Config  ---------------------------------->>>>
Future<void> configureDependencies() async {

  //Firebase Analytics
  getIt.registerLazySingleton<FirebaseAnalytics>(
        () => FirebaseAnalytics.instance,
  );

  getIt.registerLazySingleton<AppAnalytics>(
        () => FirebaseAnalyticsService(
      getIt<FirebaseAnalytics>(),
    ),
  );

  //FlutterAppAuth
  getIt.registerLazySingleton<FlutterAppAuth>(
        () => FlutterAppAuth(),
  );
  //KeycloakAuthDataSource
  getIt.registerLazySingleton<KeycloakAuthDataSource>(
        () => KeycloakAuthDataSource(getIt<FlutterAppAuth>()),
  );

  //FlutterSecureStorage
  getIt.registerLazySingleton<FlutterSecureStorage>(
          () => FlutterSecureStorage()
  );
  //TokenStorage
  getIt.registerLazySingleton<TokenStorage>(
      () => TokenStorage(getIt<FlutterSecureStorage>())
  );

  //AuthRepositoryImpl
  getIt.registerLazySingleton<OAuthRepositoryImpl>(
    () => OAuthRepositoryImpl(getIt<KeycloakAuthDataSource>(), getIt<TokenStorage>()),
  );

  getIt.registerFactory(() => OAuthBloc(
     getIt<OAuthRepositoryImpl>(),
     getIt<AppAnalytics>(),
  ));

  /*getIt.registerLazySingleton<Dio>(() =>
      Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      )));*/

  getIt.registerLazySingleton<ApiTokenProvider>(
        () => RepositoryApiTokenProvider(getIt<OAuthRepositoryImpl>()),
  );
  //Register dio interceptors
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    ));

    dio.interceptors.add(
      AuthInterceptor(dio, getIt<ApiTokenProvider>()),
    );
    return dio;
  });

  // 1. Register AppDatabase asynchronously
  getIt.registerSingletonAsync<AppDatabase>(() => AppDatabase.init());


  //Datasource  ---------------------------------->>>>
  getIt.registerLazySingleton<RemoteSurveyDataSource>(
        () => RemoteSurveyDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<LocalSurveyDataSource>(
        () => LocalSurveyDataSource(),
  );

  //Repository Dependency  ---------------------------------->>>>
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<SurveyRepository>(
          () => SurveyRepositoryImpl(
              getIt<RemoteSurveyDataSource>(),
              getIt<LocalSurveyDataSource>(),
              getIt<Connectivity>()
          )
  );

  //Use Cases  ---------------------------------->>>>
  getIt.registerLazySingleton<SurveyListUsecase>(
          () => SurveyListUsecase(getIt<SurveyRepository>())
  );
  getIt.registerLazySingleton(() => LoadLatestSurvey(getIt<SurveyRepository>()));
  getIt.registerLazySingleton(() => SaveDraft(getIt<SurveyRepository>()));
  getIt.registerLazySingleton(() => SubmitSurvey(getIt<SurveyRepository>()));
  getIt.registerLazySingleton(() => SyncPendingSurveys(getIt<SurveyRepository>()),);


  //Cubits ---------------------------------->>>>
  getIt.registerFactory(() => AddSurveyCubit(
    loadLatestSurvey: getIt<LoadLatestSurvey>(),
    saveDraft: getIt<SaveDraft>(),
    submitSurvey: getIt<SubmitSurvey>(),
    syncPendingSurveys: getIt<SyncPendingSurveys>(),
  ));

  getIt.registerFactory(() => HealthSurveyCubit(
    surveyListUseCase: getIt<SurveyListUsecase>(),
  ));

  //Notification Feature ---------------------------------->>>>
  getIt.registerLazySingleton<LocalNotificationDatasource>(
        () => LocalNotificationDatasource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<RemoteNotificationDatasource>(
        () => RemoteNotificationDatasource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationRepoImple>(
        () => NotificationRepoImple(
            getIt<Connectivity>(),
            getIt<LocalNotificationDatasource>(),
            getIt<RemoteNotificationDatasource>()
        ),
  );
  getIt.registerLazySingleton<FetchNotificationUsecase>(
        () => FetchNotificationUsecase(getIt<NotificationRepoImple>()),
  );

  getIt.registerFactory(() => NotificationController(
    getIt<FetchNotificationUsecase>(),
  ));

}