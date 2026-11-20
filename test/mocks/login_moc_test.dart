

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngo/features/auth/domain/entities/user.dart';

import 'repository/moc_auth_repository.dart';

void main(){

  late MocAuthRepository repository;
  setUpAll((){
    repository = MocAuthRepository();
  });

  test('should login with valid credentials', () async {

    User user = User(
        id: 1,
        name: 'Enamul',
        email: 'enamul@gmail.com',
        gender: 'M',
        dob: '11/10/1986',
        address: 'Dhaka, Bangladesh',
        message: 'Login Successful'
    );

    User user2 = User(
        id: 1,
        name: 'Enamul',
        email: 'enamul@gmail.com',
        gender: 'M',
        dob: '11/10/1986',
        address: 'Dhaka, Bangladesh',
        message: 'Invalid credentials'
    );

    when(
          () => repository.login(email: 'enamul@gmail.com', password: 'Password@123'),
    ).thenAnswer(
          (_) async => user,
    );

    when(
          () => repository.login(
              email: 'enamul@gmail.com',
              password: 'Password@1234'
          ),
    ).thenAnswer(
          (_) async => user2,
    );

    final result = await repository.login(email: "enamul@gmail.com", password: "Password@123");

    expect(
      result.name,
      'Enamul',
    );



    final result2 = await repository.login(email: "enamul@gmail.com", password: "Password@1234");

    expect(
      result2.message,
      'Invalid credentials',
    );

    verify(
          () => repository.login(email: "enamul@gmail.com", password: "Password@123"),
    ).called(1);

  });
}