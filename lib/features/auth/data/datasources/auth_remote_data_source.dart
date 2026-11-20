import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String address,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final json = await apiClient.post('login', {
      'email': email,
      'password': password,
    });
    print(json);
    return UserModel.fromJson(json);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String address,
  }) async {
    final json = await apiClient.post('register', {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'dob': dob,
      'address': address,
    });
    return UserModel.fromJson(json);
  }
}
