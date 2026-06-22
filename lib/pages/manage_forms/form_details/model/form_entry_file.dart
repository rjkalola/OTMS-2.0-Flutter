class FormEntryFile {
  String? url;
  int? size;
  String? docType;
  String? extension;
  String? fileName;
  String? mimeType;
  String? thumbUrl;
  String? originalName;

  FormEntryFile({
    this.url,
    this.size,
    this.docType,
    this.extension,
    this.fileName,
    this.mimeType,
    this.thumbUrl,
    this.originalName,
  });

  FormEntryFile.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    size = json['size'];
    docType = json['doc_type']?.toString();
    extension = json['extension']?.toString();
    fileName = json['file_name']?.toString();
    mimeType = json['mime_type']?.toString();
    thumbUrl = json['thumb_url']?.toString();
    originalName = json['original_name']?.toString();
  }

  String get displayName {
    final name = originalName ?? fileName ?? '';
    return name.trim();
  }

  String get previewUrl {
    final thumb = thumbUrl?.trim();
    if (thumb != null && thumb.isNotEmpty) return thumb;
    return url ?? '';
  }

  bool get isImage {
    final type = (docType ?? mimeType ?? extension ?? '').toLowerCase();
    return type.contains('image') ||
        type.endsWith('jpg') ||
        type.endsWith('jpeg') ||
        type.endsWith('png') ||
        type.endsWith('gif') ||
        type.endsWith('webp');
  }

  bool get isVideo {
    final type = (docType ?? mimeType ?? extension ?? '').toLowerCase();
    return type.contains('video') || type.endsWith('mp4');
  }

  bool get isAudio {
    final type = (docType ?? mimeType ?? extension ?? '').toLowerCase();
    return type.contains('audio') || type.endsWith('m4a');
  }
}
