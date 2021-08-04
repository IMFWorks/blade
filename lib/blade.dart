import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Blade {
  static const MethodChannel _channel =
      const MethodChannel('blade');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void hello() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'pushPage') {
        var response = {
          "status": 200
        };

        return json.encode(response);
      }

      return 'no response';
    });
  }
}

class EventResponse {
  int status = 200;
}

