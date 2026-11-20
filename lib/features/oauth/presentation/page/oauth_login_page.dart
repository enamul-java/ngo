import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/oauth_bloc.dart';
import '../bloc/oauth_bloc_event.dart';
import '../bloc/oauth_bloc_state.dart';


class OAuthLoginPage extends StatelessWidget {
  const OAuthLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keycloak Login')),
      body: Center(
        child: BlocBuilder<OAuthBloc, OAuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
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
            /*Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state is AuthFailure)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    context.read<OAuthBloc>().add(LoginRequested());
                  },
                  child: const Text('Login with Keycloak'),
                ),
              ],
            );*/
          },
        ),
      ),
    );
  }
}