import 'package:otm_inventory/pages/notification_settings/model/notification_setting_info.dart';

class NotificationCategoryInfo {
  int? id;
  String? name;
  List<NotificationSettingInfo>? notifications;
  bool? isExpanded;

  NotificationCategoryInfo(
      {this.id, this.name, this.notifications, this.isExpanded});

  NotificationCategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['notifications'] != null) {
      notifications = <NotificationSettingInfo>[];
      json['notifications'].forEach((v) {
        notifications!.add(new NotificationSettingInfo.fromJson(v));
      });
    }
    isExpanded = json['isExpanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['isExpanded'] = this.isExpanded;
    return data;
  }
}
