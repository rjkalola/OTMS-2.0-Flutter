import 'package:otm_inventory/pages/notification_settings/model/notification_category_info.dart';

class NotificationSettingsResponse {
  bool? isSuccess;
  String? message;
  List<NotificationCategoryInfo>? info;

  NotificationSettingsResponse({this.isSuccess, this.message, this.info});

  NotificationSettingsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <NotificationCategoryInfo>[];
      json['info'].forEach((v) {
        info!.add(new NotificationCategoryInfo.fromJson(v));
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
