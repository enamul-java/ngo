

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/channel/native_service.dart';


class OpenNativeScreenForResult extends StatefulWidget {
  const OpenNativeScreenForResult({super.key});

  @override
  State<OpenNativeScreenForResult> createState() => _OpenNativeScreenForResultState();
}

class _OpenNativeScreenForResultState extends State<OpenNativeScreenForResult> {


  void sendDataToNative() async {
    var res = await NativeService.sendDataToNative();
    if(!mounted) return;
    print(res);
  }

  void showBatteryLevel() async {
    final batteryLevel = await NativeService.getBatteryLevel();
    if(!mounted) return;
    print("Battery Level ${batteryLevel}");
  }

  void shoeDeviceInfo() async{
    var deviceInfo = await NativeService.getDeviceInfo();
    if(!mounted) return;
    print("Device Info ${deviceInfo}");
  }

  static const MethodChannel _channel =
  MethodChannel('com.ehaquesoft.ngo/native');

  String _result = 'No result';

  @override
  void initState() {
    //showBatteryLevel();
    //shoeDeviceInfo();
    //sendDataToNative();
    super.initState();
  }

  Future<void> openNativeActivity() async {
    try {
      final result = await _channel.invokeMethod<String>(
        'openNativeActivity',
        {
          'message': 'Hello from Flutter',
        },
      );

      setState(() {
        _result = result ?? 'No result returned';
        _result = "Result 1: $result";
      });
    } on PlatformException catch (e) {
      setState(() {
        _result = 'Error 1: ${e.message}';
      });
    }
  }

  Future<void> openNativeActivity2() async {
    try {
      final result = await _channel.invokeMethod<String>(
        'openNativeActivity2',
        {
          'message': 'Hello from Flutter',
        },
      );

      setState(() {
        _result = result ?? 'No result returned';
        _result = "Result 2: $result";
      });
    } on PlatformException catch (e) {
      setState(() {
        _result = 'Error 2: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Channel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _result,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: openNativeActivity,
              child: const Text(
                'Open Native Activity',
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: openNativeActivity2,
              child: const Text(
                'Open Native Activity2',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


