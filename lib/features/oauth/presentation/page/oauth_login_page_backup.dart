

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../di.dart';
import '../bloc/oauth_bloc.dart';
import '../bloc/oauth_bloc_event.dart';
import '../bloc/oauth_bloc_state.dart';


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
        child: const OAuthLoginPage(),
      ),
    );
  }
}


class OAuthLoginPage extends StatelessWidget {
  const OAuthLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NGO App')),
      body: Center(
        child: BlocBuilder<OAuthBloc, OAuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }

            if (state is AuthAuthenticated) {
              return const OAuthHomePage();
              //Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const OAuthHomePage()));
              /*return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text('You are authenticated'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<OAuthBloc>()
                        .add(LogoutRequested()),
                    child: const Text('Logout'),
                  ),
                ],
              );*/
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 12),
                const Text('Sign in with Keycloak'),
                const SizedBox(height: 16),
                if (state is AuthFailure)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => context
                      .read<OAuthBloc>()
                      .add(LoginRequested()),
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OAuthHomePage extends StatelessWidget {
  const OAuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NGO Dashboard')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text('Welcome to NGO Dashboard'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context
                  .read<OAuthBloc>()
                  .add(LogoutRequested()),
              child: const Text('Logout'),
            ),
          ],
        )

        /*BlocBuilder<OAuthBloc, OAuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }

            if (state is AuthAuthenticated) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text('You are authenticated'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<OAuthBloc>()
                        .add(LogoutRequested()),
                    child: const Text('Logout'),
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 12),
                const Text('Sign in with Keycloak'),
                const SizedBox(height: 16),
                if (state is AuthFailure)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => context
                      .read<OAuthBloc>()
                      .add(LoginRequested()),
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),*/
      ),
    );
  }
}