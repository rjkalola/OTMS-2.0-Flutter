class AnnouncementEmojiResponse {
  bool? isSuccess;
  String? message;
  EmojiInfo? info;

  AnnouncementEmojiResponse({this.isSuccess, this.message, this.info});

  AnnouncementEmojiResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new EmojiInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class EmojiInfo {
  int? id;
  int? announcementId;
  int? companyId;
  int? userId;
  String? emoji;
  String? emojiCode;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  EmojiInfo(
      {this.id,
        this.announcementId,
        this.companyId,
        this.userId,
        this.emoji,
        this.emojiCode,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  EmojiInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    announcementId = json['announcement_id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    emoji = json['emoji'];
    emojiCode = json['emoji_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['announcement_id'] = this.announcementId;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['emoji'] = this.emoji;
    data['emoji_code'] = this.emojiCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
