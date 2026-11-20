


import 'package:flutter/services.dart';

class NativeService {

  static const MethodChannel _channel =
  MethodChannel('com.ehaquesoft.ngo/native');

  static const EventChannel _eventChannel =
  EventChannel('com.ehaquesoft.ngo/events');

  static Stream<dynamic> get batteryStream {
    return _eventChannel.receiveBroadcastStream();
  }

  static Future<int?> getBatteryLevel() async{
    try{
      final result = await _channel.invokeMethod<int>('getBatteryLevel');
      print("getBatteryLevel result $result");
      return result;
    } on PlatformException catch (e){
      print('Failed: ${e.message}');
      return 0;
    }
  }

  static Future<String?> getDeviceInfo() async {
    try{
      var result = await _channel.invokeMethod<String>('getDeviceInfo');
      return result;
    } on PlatformException catch (e){
      print('getDeviceInfo Failed: ${e.message}');
      return '';
    }
  }

  static Future<String?> sendDataToNative() async {
    try {
      // Example A: Passing a single String value
      final String singleResult = await _channel.invokeMethod(
        'sendSingleValue',
        'Hello from Flutter!',
      );
      print("singleResult $singleResult");


      // Example B: Passing multiple values using a Map
      final Map<String, dynamic> arguments = {
        'userId': 12345,
        'username': 'Alex',
        'isPremium': true,
      };

      var multipleResult = await _channel.invokeMethod('sendMultipleValues', arguments);
      print("Multiple result $multipleResult");

      return singleResult +" "+ multipleResult;

    } on PlatformException catch (e) {
      print("Failed to invoke native method: '${e.message}'.");
    }
    return "";
  }
}