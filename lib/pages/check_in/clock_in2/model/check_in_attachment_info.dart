class CheckInAttachmentInfo {
  int? id;
  String? imageUrl;
  String? thumbUrl;

  CheckInAttachmentInfo({this.id, this.imageUrl, this.thumbUrl});

  CheckInAttachmentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    return data;
  }
}
