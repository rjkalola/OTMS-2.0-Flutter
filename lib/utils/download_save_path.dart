import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _downloadsChannel = MethodChannel('com.app.belcka/downloads');

String _safeFileName(String fileName) =>
    fileName.replaceAll(RegExp(r'[/\\]'), '_');

/// Writable path for Dio while downloading (app temp on Android).
Future<String> resolveDownloadStagingPath(String fileName) async {
  final safeName = _safeFileName(fileName);
  if (Platform.isAndroid) {
    final dir = await getTemporaryDirectory();
    return p.join(dir.path, safeName);
  }
  return resolveDownloadSavePath(fileName);
}

/// Final save location on iOS / desktop (unchanged behaviour).
Future<String> resolveDownloadSavePath(String fileName) async {
  final safeName = _safeFileName(fileName);
  if (Platform.isIOS) {
    final downloads = await getDownloadsDirectory();
    if (downloads != null) {
      return p.join(downloads.path, safeName);
    }
  }
  final dir = await getApplicationDocumentsDirectory();
  return p.join(dir.path, safeName);
}

/// Copies the staged file into the public Downloads folder on Android.
/// Returns a filesystem path for UI display and [OpenFilex].
Future<String> finalizeDownloadSave({
  required String stagingPath,
  required String fileName,
}) async {
  if (!Platform.isAndroid) {
    return stagingPath;
  }

  final safeName = _safeFileName(fileName);
  final savedPath = await _downloadsChannel.invokeMethod<String>(
    'saveToDownloads',
    {'sourcePath': stagingPath, 'fileName': safeName},
  );

  if (savedPath == null || savedPath.isEmpty) {
    throw Exception('Failed to save file to Downloads');
  }

  try {
    final staging = File(stagingPath);
    if (await staging.exists()) {
      await staging.delete();
    }
  } catch (_) {}

  return savedPath;
}
