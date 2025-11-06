import 'package:flutter/services.dart';

class AppBadge {
  static const MethodChannel _channel = MethodChannel('app_badge_channel');

  static Future<void> update(int count) async {
    try {
      await _channel.invokeMethod('updateBadgeCount', {'count': count});
    } catch (e) {
      print('Failed to update badge: $e');
    }
  }

  static Future<void> remove() async {
    try {
      await _channel.invokeMethod('removeBadge');
    } catch (e) {
      print('Failed to remove badge: $e');
    }
  }
}