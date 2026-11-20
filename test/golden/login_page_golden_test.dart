


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngo/core/network/api_client.dart';
import 'package:ngo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ngo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ngo/features/auth/domain/usecases/login.dart';
import 'package:ngo/features/auth/domain/usecases/register.dart';
import 'package:ngo/features/auth/presentation/pages/login_page.dart';
import 'package:ngo/features/auth/presentation/providers/auth_provider.dart';
import 'package:ngo/main.dart';
import 'package:provider/provider.dart';

void main(){

  final apiClient = ApiClient();
  final dataSource = AuthRemoteDataSourceImpl(apiClient);
  final repository = AuthRepositoryImpl(dataSource);

  testWidgets(
    'login page golden test',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: Login(repository),
            registerUseCase: Register(repository),
          ),
          child: const NgoAuthApp(),
        ),
      );

      expect(find.byType(LoginPage),findsOneWidget);

      await expectLater(
        find.byType(LoginPage),
        matchesGoldenFile(
          'goldens/login_page.png',
        ),
      );
    },
  );
}