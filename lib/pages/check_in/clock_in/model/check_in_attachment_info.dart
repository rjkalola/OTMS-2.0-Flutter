class CheckInAttachmentInfo {
  int? id;
  String? recordId;
  String? recordType;
  String? image;
  bool? isBefore;
  String? imageUrl;
  String? thumbUrl;

  CheckInAttachmentInfo(
      {this.id,
      this.recordId,
      this.recordType,
      this.image,
      this.isBefore,
      this.imageUrl,
      this.thumbUrl});

  CheckInAttachmentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recordId = json['record_id'];
    recordType = json['record_type'];
    image = json['image'];
    isBefore = json['is_before'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['record_id'] = this.recordId;
    data['record_type'] = this.recordType;
    data['image'] = this.image;
    data['is_before'] = this.isBefore;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    return data;
  }
}
