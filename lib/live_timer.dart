import 'package:flutter/services.dart';

class LiveTimer {
  static const _channel = MethodChannel('live_timer');

  /// Start live counter from existing time
  static Future<void> start(int elapsedSeconds) async {
    await _channel.invokeMethod('start', {
      'elapsedSeconds': elapsedSeconds,
    });
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }
}
