

import 'package:flutter_test/flutter_test.dart';
import 'package:ngo/core/utils/calculator.dart';

void main(){

    late Calculator calculator ;

    setUp(() {
      // setup before every test
      //calculator = Calculator();
      print("Set up called");
    });

    tearDown(() {
      // cleanup after every test
      print("Tear down called");
    });

    setUpAll(() {
      // runs once before all tests
      calculator = Calculator();
      print("Set up all called");
    });

    tearDownAll(() {
      // runs once after all tests
      print("Tear down all called");
    });

  test('should add two numbers', () {
    final result = calculator.add(10, 20);
    // assert(result == 30);
    expect(result, 30);
  });

  test('should subtract tow number', (){
    final result = calculator.subtract(20,10);
    expect(result, 10);
  });

  test('addition', (){
    expect(calculator.add(30, 20), 50);
  });
}