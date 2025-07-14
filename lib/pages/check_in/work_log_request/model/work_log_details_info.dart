class WorkLogDetailsInfo {
  int? id;
  int? requestLogId;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;
  int? totalBreakSeconds;
  int? payableWorkSeconds;
  int? totalRequestWorkSeconds;
  String? note;
  String? rejectReason;
  int? status;
  String? statusText;

  WorkLogDetailsInfo(
      {this.id,
        this.requestLogId,
        this.userId,
        this.userName,
        this.userImage,
        this.userThumbImage,
        this.workStartTime,
        this.workEndTime,
        this.totalWorkSeconds,
        this.totalBreakSeconds,
        this.payableWorkSeconds,
        this.totalRequestWorkSeconds,
        this.note,
        this.rejectReason,
        this.status,
        this.statusText});

  WorkLogDetailsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestLogId = json['request_log_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    payableWorkSeconds = json['payable_work_seconds'];
    totalRequestWorkSeconds = json['total_request_work_seconds'];
    note = json['note'];
    rejectReason = json['reject_reason'];
    status = json['status'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_log_id'] = this.requestLogId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    data['total_break_seconds'] = this.totalBreakSeconds;
    data['payable_work_seconds'] = this.payableWorkSeconds;
    data['total_request_work_seconds'] = this.totalRequestWorkSeconds;
    data['note'] = this.note;
    data['reject_reason'] = this.rejectReason;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    return data;
  }
}