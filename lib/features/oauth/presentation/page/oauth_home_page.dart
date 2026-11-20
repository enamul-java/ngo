

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/oauth_bloc.dart';
import '../bloc/oauth_bloc_event.dart';
import '../bloc/oauth_bloc_state.dart';

class OAuthHomePage extends StatelessWidget {
  const OAuthHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final state = context.read<OAuthBloc>().state;

    if (state is! AuthAuthenticated) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = state.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<OAuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 35,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              user.fullName.isNotEmpty
                  ? user.fullName
                  : user.username,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _userInfo('User ID', user.id),
            _userInfo('Username', user.username),
            _userInfo('Email', user.email),
            _userInfo('First Name', user.firstName),
            _userInfo('Last Name', user.lastName),
          ],
        ),
      ),
    );
  }

  Widget _userInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? 'Not provided' : value)),
        ],
      ),
    );
  }
}