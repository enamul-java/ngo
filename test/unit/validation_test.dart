


import 'package:flutter_test/flutter_test.dart';
import 'package:ngo/core/utils/validation.dart';

void main(){
  late Validation validation;

  setUpAll((){
    validation = Validation();
  });

  test('should throw exception for age below 18', (){
    expect(
      () => validation.validateAge(15),
      throwsException,
    );
  });

  test('should return true for age >= 18', (){
    expect(
      validation.validateAge2(15),
      isFalse,
      reason: 'Age is valid',
      skip: false,
    );
  });

  test('should throw correct exception', () {
    expect(
          () => validation.validateAge(15),
      throwsA(
        predicate(
              (e) => e.toString().contains('18 or older'),
        ),
      ),
    );
  });
}

/**
 * in test directory
 * inside main method
 * setUp or setUpAll for initialize object
 * tearDown or tearDownAll for clean up
 * use test function to test
 * call actual method and expect to match the result
 * test('name or description', (){
 *   final actualRes = actualMethod();
 *   expect(actualRes, expectedRes, 'Reason of the test', skip or not);
 * });
 * test Exception expect( () => actualMethod(), throwsException);
 * or expect(()=> actualMethod(), throwA( predicate((e) => e.toString().contains('error message'))));
 * **/