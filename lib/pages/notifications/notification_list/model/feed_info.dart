class FeedInfo {
  int? id;
  int? companyId;
  String? companyName;
  int? userId;
  String? userName;
  String? userImageName;
  String? userImage;
  String? userThumbImage;
  String? companyImage;
  String? companyThumbImage;
  String? message;
  String? action;
  int? requestType;
  String? dateAdded;
  String? weekStart;
  String? weekEnd;
  int? feedType;
  int? unreadFeeds;

  FeedInfo(
      {this.id,
      this.companyId,
      this.companyName,
      this.userId,
      this.userName,
      this.userImageName,
      this.userImage,
      this.userThumbImage,
      this.companyImage,
      this.companyThumbImage,
      this.message,
      this.action,
      this.requestType,
      this.dateAdded,
      this.weekStart,
      this.weekEnd,
      this.feedType,
      this.unreadFeeds});

  FeedInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImageName = json['user_image_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    companyImage = json['company_image'];
    companyThumbImage = json['company_thumb_image'];
    message = json['message'];
    action = json['action'];
    requestType = json['request_type'];
    dateAdded = json['date_added'];
    weekStart = json['week_start'];
    weekEnd = json['week_end'];
    feedType = json['feed_type'];
    unreadFeeds = json['unread_feeds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image_name'] = this.userImageName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['company_image'] = this.companyImage;
    data['company_thumb_image'] = this.companyThumbImage;
    data['message'] = this.message;
    data['action'] = this.action;
    data['request_type'] = this.requestType;
    data['date_added'] = this.dateAdded;
    data['week_start'] = this.weekStart;
    data['week_end'] = this.weekEnd;
    data['feed_type'] = this.feedType;
    data['unread_feeds'] = this.unreadFeeds;
    return data;
  }
}
