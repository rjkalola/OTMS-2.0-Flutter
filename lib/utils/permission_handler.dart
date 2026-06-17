import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> isStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 10+ uses scoped storage and system pickers; no broad storage
      // permission is required for one-time file selection or app-owned files.
      return true;
    }

    final status = await Permission.storage.request();
    final havePermission = status.isGranted;
    if (!havePermission) {
      await openAppSettings();
    }
    return havePermission;
  }
}
