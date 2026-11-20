

import 'package:flutter_test/flutter_test.dart';
import 'package:ngo/core/config/text_config.dart';
import 'package:ngo/core/network/api_client.dart';
import 'package:ngo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ngo/features/auth/data/repositories/auth_repository_impl.dart';

void main(){

  late ApiClient apiClient;
  late AuthRemoteDataSourceImpl dataSource;
  late AuthRepositoryImpl repository;

  setUpAll((){
    apiClient = ApiClient();
    dataSource = AuthRemoteDataSourceImpl(apiClient);
    repository = AuthRepositoryImpl(dataSource);
  });

  if(!TextConfig.TestForNetworkError) {
    test("login with invalid credentials throw Exception", () async {
      expect(
            () async =>
        await repository.login(
          email: "enamul@gmail.com1",
          password: "Password@123",
        ),
        throwsException,
      );
    });

    test("User.fromJson should parse JSON correctly", () async {
      final user = await repository.login(
        email: "enamul@gmail.com",
        password: "Password@123",
      );
      expect(user.name, "Test User",);
      expect(user.email, "enamul@gmail.com",);
      expect(user.gender, "M",);
      expect(user.address, "Dhaka, Banglades",);
      expect(user.dob, "11/10/1998",);
      expect(user.message, "Login successful",);
    });

    test("login with valid credentials will be successful", () async {
      final user = await repository.login(
        email: "enamul@gmail.com",
        password: "Password@123",
      );
      expect(
        user.message,
        "Login successful",
      );
    });

    test("login with valid credentials will return same mail id", () async {
      final email = "enamul@gmail.com";
      final user = await repository.login(
        email: email,
        password: "Password@123",
      );
      expect(
        user.email,
        email,
        reason: "Because after successful login user info will fetch form database and return same email",
      );
    });
  }
}