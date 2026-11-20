import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) =>
      dataSource.login(email: email, password: password);

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String address,
  }) =>
      dataSource.register(
        name: name,
        email: email,
        password: password,
        gender: gender,
        dob: dob,
        address: address,
      );
}
