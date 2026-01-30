class MyRequestInfo {
  int? id;
  int? userId;
  String? date;
  int? status;
  String? rejectReason;
  String? message;
  String? userName;
  String? userImage;
  String? weekStart;
  String? weekEnd;
  String? startTime;
  String? endTime;
  String? note;
  String? statusText;
  int? requestType;
  String? typeName;
  int? leaveId;
  int? approvedBy;
  int? rejectedBy;
  int? penaltyId;

  MyRequestInfo(
      {this.id,
      this.userId,
      this.date,
      this.status,
      this.rejectReason,
      this.message,
      this.userName,
      this.userImage,
      this.weekStart,
      this.weekEnd,
      this.startTime,
      this.endTime,
      this.note,
      this.statusText,
      this.requestType,
      this.typeName,
      this.leaveId,
      this.approvedBy,
      this.rejectedBy,
      this.penaltyId});

  MyRequestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    message = json['message'];
    userName = json['user_name'];
    userImage = json['user_image'];
    weekStart = json['week_start'];
    weekEnd = json['week_end'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    note = json['note'];
    statusText = json['status_text'];
    requestType = json['request_type'];
    typeName = json['type_name'];
    leaveId = json['leave_id'];
    approvedBy = json['approved_by'];
    rejectedBy = json['rejected_by'];
    penaltyId = json['penalty_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['status'] = this.status;
    data['reject_reason'] = this.rejectReason;
    data['message'] = this.message;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['week_start'] = this.weekStart;
    data['week_end'] = this.weekEnd;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['note'] = this.note;
    data['status_text'] = this.statusText;
    data['request_type'] = this.requestType;
    data['type_name'] = this.typeName;
    data['leave_id'] = this.leaveId;
    data['approved_by'] = this.approvedBy;
    data['rejected_by'] = this.rejectedBy;
    data['penalty_id'] = this.penaltyId;
    return data;
  }
}
