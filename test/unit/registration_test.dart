


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
    test('try registration with existence mail will throw exception', () {
      expect(
            () async =>
        await repository.register(
          name: "Enamul",
          email: "enamul@gmail.com",
          password: "Password@123",
          gender: "Male",
          dob: "2000-01-01",
          address: "Dhaka",
        ),
        throwsException,
      );
    });

    test('try registration with existence mail will throw exception', () {
      expect(
            () async =>
        await repository.register(
          name: "Enamul",
          email: "enamul@gmail.com",
          password: "Password@123",
          gender: "Male",
          dob: "2000-01-01",
          address: "Dhaka",
        ),
        throwsA(
          predicate(
                (e) => e.toString().contains('Email already registered'),
          ),
        ),
      );
    });
  }
}