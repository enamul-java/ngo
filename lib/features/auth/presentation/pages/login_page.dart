import 'dart:async';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:ngo/core/utils/validation.dart';
import 'package:provider/provider.dart';

import '../../../../core/channel/native_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/view/dashboard_page.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void setupCustomInAppUi() async {
    FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;
    await fiam.setCustomDisplayEnabled(true);

    fiam.onMessageDisplay.listen((InAppMessage message) async {

      await message.impress(); // Log the impression to Firebase

      print("FIAM Stream Called: ${message.campaignMetadata?.campaignName}");

      // Ensure the widget context is still active before showing a dialog
      //if (!mounted) return;

      // Show your custom Flutter Dialog
      /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message.campaignMetadata?.campaignName ?? 'Notification'),
            content: const Text('This is a completely custom Flutter UI!'),
            actions: [
              TextButton(
                onPressed: () {
                  message.dismiss(); // Log dismissal
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );*/
    },
    onError: (error) {
      print("FIAM Stream Error: $error");
    }
    );
  }

  @override
  void initState() {
    //setupCustomInAppUi();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: "enamul2@gmail.com");
  final _password = TextEditingController(text: "Password@123");

  //final _email = TextEditingController();
  //final _password = TextEditingController();

  bool _obscure = true;

  /*@override
  void initState() {
    super.initState();
  }*/

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      email: _email.text,
      password: _password.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Dashboard(),
        ),
      );
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.user?.message ?? 'Login successful'),
          behavior: SnackBarBehavior.floating,
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const AuthHeader(
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Welcome Back',
                    subtitle: 'Sign in to continue to your NGO account',
                  ),
                  const SizedBox(height: 32),
                  _Card(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthTextField(
                            controller: _email,
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              return Validation.emailValidation(v);
                            },
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            controller: _password,
                            label: 'Password',
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscure,
                            onToggleVisibility: () =>
                                setState(() => _obscure = !_obscure),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Password is required'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 54,
                            child: FilledButton(
                              onPressed: auth.isLoading ? null : _submit,
                              child: auth.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 16),
                            _ErrorBox(message: auth.errorMessage!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 20, // A fixed height is required for Marquee to render properly
                          child: Marquee(
                            text: 'Current Location: Dakkinkhan, Dhaka - 1230',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 20.0, // Gap before the text repeats itself
                            velocity: 30.0, // Pixels per second scrolling speed
                            pauseAfterRound: const Duration(seconds: 2), // Pause briefly before looping again
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        color: Colors.red,
                      ),
                    ],
                  ),*/
                  /*Wrap(
                     alignment: WrapAlignment.center, // Centers items horizontally
                     crossAxisAlignment: WrapCrossAlignment.center, // Aligns items vertically
                    */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //const Text("Don't have an account?"),
                      const Flexible(
                        child: Text(
                          "Don't have an account?",
                          overflow: TextOverflow.ellipsis, // Prevents layout breaking
                        ),
                      ),
                      TextButton(
                        onPressed: auth.isLoading
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Secure access to your NGO services',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;

  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              key: const Key("errText"),
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
