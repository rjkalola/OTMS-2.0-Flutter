import 'package:path/path.dart' as p;

class FormUploadedFile {
  FormUploadedFile({
    required this.path,
    String? name,
  }) : name = name ?? p.basename(path);

  final String path;
  final String name;
}
