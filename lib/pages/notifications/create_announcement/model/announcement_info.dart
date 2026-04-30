import 'package:belcka/pages/common/model/file_info.dart';

class AnnouncementInfo {
  int? id;
  int? announcementId;
  String? name;
  int? userId;
  String? userName;
  int? companyId;
  String? companyName;
  String? type;
  String? senderImage;
  String? senderThumbImage;
  String? senderName;
  List<FilesInfo>? documents;
  String? date;
  int? unreadCount;
  String? unreadIds;
  bool? isRead;
  List<AnnouncementFeedInfo>? feeds;

  AnnouncementInfo(
      {this.id,
      this.announcementId,
      this.name,
      this.userId,
      this.userName,
      this.companyId,
      this.companyName,
      this.type,
      this.senderImage,
      this.senderThumbImage,
      this.senderName,
      this.documents,
      this.date,
      this.unreadCount,
      this.unreadIds,
      this.isRead,
      this.feeds});

  AnnouncementInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    announcementId = json['announcement_id'];
    name = json['name'];
    userId = json['user_id'];
    userName = json['user_name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    type = json['type'];
    senderImage = json['sender_image'];
    senderThumbImage = json['sender_thumb_image'];
    senderName = json['sender_name'];
    if (json['documents'] != null) {
      documents = <FilesInfo>[];
      json['documents'].forEach((v) {
        documents!.add(new FilesInfo.fromJson(v));
      });
    }
    date = json['date'];
    unreadCount = json['unread_count'];
    unreadIds = json['unread_ids'];
    isRead = json['is_read'];
    if (json['feeds'] != null) {
      feeds = <AnnouncementFeedInfo>[];
      json['feeds'].forEach((v) {
        feeds!.add(AnnouncementFeedInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['announcement_id'] = this.announcementId;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['type'] = this.type;
    data['sender_image'] = this.senderImage;
    data['sender_thumb_image'] = this.senderThumbImage;
    data['sender_name'] = this.senderName;
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['unread_count'] = this.unreadCount;
    data['unread_ids'] = this.unreadIds;
    data['is_read'] = this.isRead;
    if (this.feeds != null) {
      data['feeds'] = this.feeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnouncementFeedInfo {
  int? id;
  int? announcementId;
  int? userId;
  String? action;
  String? code;
  String? userName;
  String? userImage;
  String? userThumbImage;

  AnnouncementFeedInfo(
      {this.id,
      this.announcementId,
      this.userId,
      this.action,
      this.code,
      this.userName,
      this.userImage,
      this.userThumbImage});

  AnnouncementFeedInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    announcementId = json['announcement_id'] ;
    userId = json['user_id'];
    action = json['action'];
    action ??= json['emoji'];
    code = json['code'];
    code ??= json['emoji_code'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['announcement_id'] = announcementId;
    data['user_id'] = userId;
    data['action'] = action;
    data['code'] = code;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    data['user_thumb_image'] = userThumbImage;
    return data;
  }
}
