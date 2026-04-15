class LeaveHistoryResponse {
  bool? isSuccess;
  String? message;
  List<LeaveHistoryInfo>? info;

  LeaveHistoryResponse({this.isSuccess, this.message, this.info});

  LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <LeaveHistoryInfo>[];
      json['info'].forEach((v) {
        info!.add(LeaveHistoryInfo.fromJson(v));
      });
    }
  }
}

class LeaveHistoryInfo {
  int? id;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? date;
  String? time;
  String? actionBy;
  String? typeName;
  String? message;

  LeaveHistoryInfo({
    this.id,
    this.userId,
    this.userName,
    this.userImage,
    this.userThumbImage,
    this.date,
    this.time,
    this.actionBy,
    this.typeName,
    this.message,
  });

  LeaveHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    date = json['date'];
    time = json['time'];
    actionBy = json['action_by'];
    typeName = json['type_name'];
    message = json['message'];
  }
}
