import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenProtection {
  ScreenProtection._();

  static const MethodChannel _channel = MethodChannel(
    'lockpass/screen_protection',
  );

  static Future<void> enable() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod<void>('enable');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ScreenProtection.enable failed: $e');
      }
    }
  }

  static Future<void> disable() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod<void>('disable');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ScreenProtection.disable failed: $e');
      }
    }
  }
}
