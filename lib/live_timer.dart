import 'dart:io';

import 'package:flutter/services.dart';

// class LiveTimer {
//   static const _channel = MethodChannel('live_timer');
//
//   /// Start live counter from existing time
//   static Future<void> start(int elapsedSeconds) async {
//     if (Platform.isAndroid) {
//       await _channel.invokeMethod('start', {
//         'elapsedSeconds': elapsedSeconds,
//       });
//     }
//   }
//
//   static Future<void> stop() async {
//     if (Platform.isAndroid) {
//       await _channel.invokeMethod('stop');
//     }
//   }
// }

class LiveTimer {
  static const _channel = MethodChannel('live_timer');

  static Future<void> start(int elapsedSeconds) async {
    if (Platform.isAndroid) {
      // await _channel.invokeMethod('start', {
      //   'elapsedSeconds': elapsedSeconds,
      // });
    }
  }

  static Future<void> pause() async {
    if (Platform.isAndroid) {
      // await _channel.invokeMethod('pause');
    }
  }

  static Future<void> stop() async {
    if (Platform.isAndroid) {
      // await _channel.invokeMethod('stop');
    }
  }
}
