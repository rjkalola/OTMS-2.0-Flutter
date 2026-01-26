import 'package:belcka/pages/notifications/notification_list/model/feed_info.dart';

class FeedListResponse {
  bool? isSuccess;
  String? message;
  int? unreadCount;
  int? announcementCount;
  List<FeedInfo>? info;

  FeedListResponse(
      {this.isSuccess,
      this.message,
      this.unreadCount,
      this.announcementCount,
      this.info});

  FeedListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    unreadCount = json['unread_count'];
    announcementCount = json['announcement_count'];
    if (json['info'] != null) {
      info = <FeedInfo>[];
      json['info'].forEach((v) {
        info!.add(new FeedInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['unread_count'] = this.unreadCount;
    data['announcement_count'] = this.announcementCount;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
