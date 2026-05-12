class HireHistoryResponse {
  bool? isSuccess;
  String? message;
  List<HireHistoryInfo>? info;

  HireHistoryResponse({this.isSuccess, this.message, this.info});

  HireHistoryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <HireHistoryInfo>[];
      json['info'].forEach((v) {
        info!.add(HireHistoryInfo.fromJson(v));
      });
    }
  }
}

class HireHistoryInfo {
  int? id;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? date;
  String? time;
  String? actionBy;
  String? typeName;
  String? leaveType;
  String? message;

  HireHistoryInfo({
    this.id,
    this.userId,
    this.userName,
    this.userImage,
    this.userThumbImage,
    this.date,
    this.time,
    this.actionBy,
    this.typeName,
    this.leaveType,
    this.message,
  });

  HireHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    date = json['date'];
    time = json['time'];
    actionBy = json['action_by'];
    typeName = json['type_name'];
    leaveType = json['leave_type'];
    message = json['message'];
  }
}
