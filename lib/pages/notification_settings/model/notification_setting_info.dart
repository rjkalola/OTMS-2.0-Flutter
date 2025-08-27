class NotificationSettingInfo {
  int? id;
  String? name;
  int? tradeCategoryId;
  bool? isPush;
  bool? isFeed;

  NotificationSettingInfo(
      {this.id, this.name, this.tradeCategoryId, this.isPush, this.isFeed});

  NotificationSettingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tradeCategoryId = json['trade_category_id'];
    isPush = json['is_push'];
    isFeed = json['is_feed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['trade_category_id'] = this.tradeCategoryId;
    data['is_push'] = this.isPush;
    data['is_feed'] = this.isFeed;
    return data;
  }
}
