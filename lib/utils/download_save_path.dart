import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Writable path for downloads. Android 10+ cannot write to the public
/// `/storage/emulated/0/Download/` folder without legacy/MANAGE_EXTERNAL_STORAGE;
/// this uses app-accessible directories from [path_provider] instead.
Future<String> resolveDownloadSavePath(String fileName) async {
  final safeName = fileName.replaceAll(RegExp(r'[/\\]'), '_');
  if (Platform.isAndroid) {
    final downloads = await getDownloadsDirectory();
    if (downloads != null) {
      return p.join(downloads.path, safeName);
    }
    final external = await getExternalStorageDirectory();
    if (external != null) {
      return p.join(external.path, safeName);
    }
  }
  final dir = await getApplicationDocumentsDirectory();
  return p.join(dir.path, safeName);
}
