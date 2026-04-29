import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';

class AnnouncementListResponse {
  bool? isSuccess;
  String? message;
  int? unreadCount;
  List<AnnouncementInfo>? info;

  AnnouncementListResponse(
      {this.isSuccess, this.message, this.unreadCount, this.info});

  AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    unreadCount = json['unread_count'];
    if (json['info'] != null) {
      info = <AnnouncementInfo>[];
      json['info'].forEach((v) {
        info!.add(new AnnouncementInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['unread_count'] = this.unreadCount;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
