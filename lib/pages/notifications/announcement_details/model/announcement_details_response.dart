import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';

class AnnouncementDetailsResponse {
  bool? isSuccess;
  String? message;
  AnnouncementInfo? info;

  AnnouncementDetailsResponse({this.isSuccess, this.message, this.info});

  AnnouncementDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info =
        json['info'] != null ? AnnouncementInfo.fromJson(json['info']) : null;
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
