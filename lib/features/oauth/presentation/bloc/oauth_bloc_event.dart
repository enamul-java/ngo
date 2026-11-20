
import 'package:flutter_bloc/flutter_bloc.dart';


sealed class OAuthEvent {}

final class AuthStarted extends OAuthEvent {}

final class LoginRequested extends OAuthEvent {}

final class LogoutRequested extends OAuthEvent {}
