class AttachmentItemModel {
  final int id;
  final String extension;
  final String docType; // "video", "image", "pdf"
  final String imageUrl;
  final String thumbUrl;

  AttachmentItemModel({
    required this.id,
    required this.extension,
    required this.docType,
    required this.imageUrl,
    required this.thumbUrl,
  });

  factory AttachmentItemModel.fromJson(Map<String, dynamic> json) {
    return AttachmentItemModel(
      id: json['id'],
      extension: json['extension'],
      docType: json['doc_type'],
      imageUrl: json['image_url'],
      thumbUrl: json['image_thumb_url'],
    );
  }

  // Get filename from URL
  String get fileName => imageUrl.split('/').last;
}