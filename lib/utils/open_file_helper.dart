import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens local files without requiring broad media/storage manifest permissions.
///
/// On Android, paths outside the app sandbox are copied into app temp storage
/// first so [OpenFilex] can launch a viewer via FileProvider.
class OpenFileHelper {
  static Future<OpenResult> open(String filePath) async {
    if (!Platform.isAndroid || _isRemotePath(filePath)) {
      return OpenFilex.open(filePath);
    }

    final openablePath = await _resolveOpenablePath(filePath);
    return OpenFilex.open(openablePath);
  }

  static bool _isRemotePath(String filePath) =>
      filePath.startsWith('http://') || filePath.startsWith('https://');

  static Future<String> _resolveOpenablePath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return filePath;
    }

    if (await _isAppOwnedPath(file.path)) {
      return file.path;
    }

    final tempDir = await getTemporaryDirectory();
    final stagedPath = p.join(
      tempDir.path,
      'open_${DateTime.now().millisecondsSinceEpoch}_${p.basename(filePath)}',
    );
    await file.copy(stagedPath);
    return stagedPath;
  }

  static Future<bool> _isAppOwnedPath(String filePath) async {
    final normalized = p.normalize(filePath);
    final roots = <String>[
      p.normalize((await getTemporaryDirectory()).path),
      p.normalize((await getApplicationDocumentsDirectory()).path),
      p.normalize((await getApplicationSupportDirectory()).path),
    ];

    final externalDir = await getExternalStorageDirectory();
    if (externalDir != null) {
      roots.add(p.normalize(externalDir.path));
    }

    return roots.any((root) => normalized.startsWith(root));
  }
}
