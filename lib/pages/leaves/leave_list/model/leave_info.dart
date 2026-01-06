class LeaveInfo {
  int? id;
  int? leaveId;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? startDate;
  String? endDate;
  bool? isAlldayLeave;
  String? leaveName;
  String? leaveType;
  String? startTime;
  String? endTime;
  String? totalTimeOfDays;
  String? managerNote;
  bool? isRequested;
  int? requestStatus;

  LeaveInfo(
      {this.id,
      this.leaveId,
      this.userId,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.startDate,
      this.endDate,
      this.isAlldayLeave,
      this.leaveName,
      this.leaveType,
      this.startTime,
      this.endTime,
      this.totalTimeOfDays,
      this.managerNote,
      this.isRequested,
      this.requestStatus});

  LeaveInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveId = json['leave_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isAlldayLeave = json['is_allday_leave'];
    leaveName = json['leave_name'];
    leaveType = json['leave_type'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalTimeOfDays = json['total_time_of_days'];
    managerNote = json['manager_note'];
    isRequested = json['is_requested'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leave_id'] = this.leaveId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['is_allday_leave'] = this.isAlldayLeave;
    data['leave_name'] = this.leaveName;
    data['leave_type'] = this.leaveType;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['total_time_of_days'] = this.totalTimeOfDays;
    data['manager_note'] = this.managerNote;
    data['is_requested'] = this.isRequested;
    data['request_status'] = this.requestStatus;

    return data;
  }
}
