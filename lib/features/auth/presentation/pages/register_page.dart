import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _dob = TextEditingController();
  final _address = TextEditingController();

  String _gender = 'M';
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _dob.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _selectDob() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select date of birth',
    );

    if (picked != null) {
      _dob.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      gender: _gender,
      dob: _dob.text,
      address: _address.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(auth.user?.message ?? 'Registration successful'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  String? requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const AuthHeader(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Join Us',
                    subtitle: 'Create your NGO account',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthTextField(
                            controller: _name,
                            label: 'Full Name',
                            hint: 'Test User',
                            prefixIcon: Icons.person_outline,
                            validator: (v) => requiredField(v, 'Name'),
                          ),
                          const SizedBox(height: 15),
                          AuthTextField(
                            controller: _email,
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(v.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          AuthTextField(
                            controller: _password,
                            label: 'Password',
                            hint: 'At least 8 characters',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscure,
                            onToggleVisibility: () =>
                                setState(() => _obscure = !_obscure),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 8) {
                                return 'Use at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.wc_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'M',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'F',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'O',
                                child: Text('Other'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _gender = v);
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _dob,
                            readOnly: true,
                            onTap: _selectDob,
                            validator: (v) =>
                                requiredField(v, 'Date of birth'),
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              hintText: 'DD/MM/YYYY',
                              prefixIcon:
                                  Icon(Icons.calendar_month_outlined),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _address,
                            maxLines: 3,
                            validator: (v) => requiredField(v, 'Address'),
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              hintText: 'Dhaka, Bangladesh',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: 42),
                                child: Icon(Icons.location_on_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
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
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.07),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                auth.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        auth.isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Already have an account? Sign in'),
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
