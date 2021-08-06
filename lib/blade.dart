import 'dart:async';
import 'dart:convert';

import 'package:blade/messenger/page_info.dart';
import 'package:flutter/services.dart';

class Blade {
  static const MethodChannel _channel = const MethodChannel('blade');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}



