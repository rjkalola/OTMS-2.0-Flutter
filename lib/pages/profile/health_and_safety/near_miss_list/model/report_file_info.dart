class ReportFileInfo {
  final int id;
  final int recordId;
  final int addedBy;
  final String type;
  final String extension;
  final String docType;
  final String imageUrl;
  final String imageThumbUrl;

  ReportFileInfo({
    required this.id,
    required this.recordId,
    required this.addedBy,
    required this.type,
    required this.extension,
    required this.docType,
    required this.imageUrl,
    required this.imageThumbUrl,
  });

  factory ReportFileInfo.fromJson(Map<String, dynamic> json) {
    return ReportFileInfo(
      id: json['id'] ?? 0,
      recordId: json['record_id'] ?? 0,
      addedBy: json['added_by'] ?? 0,
      type: json['type'] ?? '',
      extension: json['extension'] ?? '',
      docType: json['doc_type'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imageThumbUrl: json['image_thumb_url'] ?? '',
    );
  }
}