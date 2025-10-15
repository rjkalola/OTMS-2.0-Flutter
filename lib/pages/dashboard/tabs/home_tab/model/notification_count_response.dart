class NotificationCountResponse {
  bool? isSuccess;
  String? message;
  int? feedCount;
  int? announcementCount;

  NotificationCountResponse(
      {this.isSuccess, this.message, this.feedCount, this.announcementCount});

  NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    feedCount = json['feed_count'];
    announcementCount = json['announcement_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['feed_count'] = this.feedCount;
    data['announcement_count'] = this.announcementCount;
    return data;
  }
}
