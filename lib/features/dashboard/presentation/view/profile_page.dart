
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngo/features/auth/presentation/providers/auth_provider.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_text_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('Profile Details'),
          centerTitle: true,
        ),*/
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                     ProfileHeader(
                      icon: Icons.person,
                      title: provider.user?.name ?? "Unknown",
                      subtitle: 'Software Engineer',
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                          children: [
                            ProfileTextField(
                              label: 'Full Name',
                              text: provider.user?.name ?? "Unknown",
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: 15),
                            ProfileTextField(
                              label: 'Email',
                              text: provider.user?.email ?? "Unknown",
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 15),
                            ProfileTextField(
                              label: 'Gender',
                              text: (provider.user?.gender ?? "Unknown") == "M" ? "Male" : "Female",
                              prefixIcon: Icons.wc_outlined,
                            ),
                            const SizedBox(height: 15),
                            ProfileTextField(
                              label: 'Date of Birth',
                              text: provider.user?.dob ?? "Unknown",
                              prefixIcon: Icons.calendar_month,
                            ),
                            const SizedBox(height: 15),
                            ProfileTextField(
                              label: 'Address',
                              text: provider.user?.address ?? "Unknown",
                              prefixIcon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
