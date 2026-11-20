import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String address,
  }) =>
      repository.register(
        name: name,
        email: email,
        password: password,
        gender: gender,
        dob: dob,
        address: address,
      );
}
