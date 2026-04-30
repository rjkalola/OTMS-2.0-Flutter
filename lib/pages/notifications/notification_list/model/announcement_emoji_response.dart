import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';

class AnnouncementEmojiResponse {
  bool? isSuccess;
  String? message;
  AnnouncementFeedInfo? info;

  AnnouncementEmojiResponse({this.isSuccess, this.message, this.info});

  AnnouncementEmojiResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? new AnnouncementFeedInfo.fromJson(json['info'])
        : null;
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
