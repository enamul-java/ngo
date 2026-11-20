

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../bloc/oauth_bloc.dart';
import '../bloc/oauth_bloc_event.dart';
import '../bloc/oauth_bloc_state.dart';
import 'oauth_home_page.dart';
import 'oauth_login_page.dart';


class OAuthApp extends StatelessWidget {
  const OAuthApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: BlocProvider(
        create: (_) => getIt<OAuthBloc>()..add(AuthStarted()),
        child: const OAuthGateWayApp(),
      ),
    );
  }
}

class OAuthGateWayApp extends StatelessWidget {
  const OAuthGateWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keycloak Authentication',
      home: BlocBuilder<OAuthBloc, OAuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return const OAuthHomePage();
          }

          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return const OAuthLoginPage();
        },
      ),
    );
  }
}



