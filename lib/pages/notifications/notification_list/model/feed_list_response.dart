import 'package:belcka/pages/notifications/notification_list/model/feed_info.dart';

class FeedListResponse {
  bool? isSuccess;
  String? message;
  List<FeedInfo>? info;

  FeedListResponse({this.isSuccess, this.message, this.info});

  FeedListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
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
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
