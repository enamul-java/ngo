import 'package:flutter/foundation.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthProvider extends ChangeNotifier {
  final Login loginUseCase;
  final Register registerUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  AuthStatus status = AuthStatus.initial;
  User? user;
  String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;


  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _loading();

    try {
      user = await loginUseCase(
        email: email.trim(),
        password: password,
      );
      status = AuthStatus.success;
      errorMessage = null;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      print("Network Error"+e.message);
      _error(e.message);
    } catch (_) {
      _error('Something went wrong. Please try again.');
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String address,
  }) async {
    _loading();

    try {
      user = await registerUseCase(
        name: name.trim(),
        email: email.trim(),
        password: password,
        gender: gender,
        dob: dob,
        address: address.trim(),
      );
      status = AuthStatus.success;
      errorMessage = null;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _error(e.message);
    } catch (_) {
      _error('Something went wrong. Please try again.');
    }
    return false;
  }

  void _loading() {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
  }

  void _error(String message) {
    status = AuthStatus.failure;
    errorMessage = message;
    notifyListeners();
  }
}
