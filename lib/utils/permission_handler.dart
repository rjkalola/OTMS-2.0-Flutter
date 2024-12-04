import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> isStoragePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();

    bool havePermission = false;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await info.androidInfo;
      debugPrint('releaseVersion : ${androidInfo.version.release}');
      final int androidVersion = int.parse(androidInfo.version.release);
      if (androidVersion >= 13) {
        havePermission = true;
      } else {
        final status = await Permission.storage.request();
        havePermission = status.isGranted;
      }
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }

    return havePermission;
  }
}
