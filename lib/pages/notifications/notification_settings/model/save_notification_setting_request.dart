class SaveNotificationSettingRequest {
  int? notificationId;
  int? isPush, isFeed;

  SaveNotificationSettingRequest({
    this.notificationId,
    this.isPush,
    this.isFeed,
  });

  SaveNotificationSettingRequest.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    isPush = json['is_push'];
    isFeed = json['is_feed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['is_push'] = this.isPush;
    data['is_feed'] = this.isFeed;
    return data;
  }
}
