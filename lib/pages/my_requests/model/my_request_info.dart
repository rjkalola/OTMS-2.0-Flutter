class MyRequestInfo{
  int? id;
  int? userId;
  String? date;
  String? status;
  String? approvedBy;
  String? rejectedBy;
  String? approvedAt;
  String? rejectedAt;
  String? rejectReason;
  String? message;
  String? requestedUser;
  String? requestedUserImage;
  String? requestedUserThumbImage;
  int? editedUserId;
  String? editedUserName;
  String? editedUserImage;
  String? editedUserThumbImage;
  Null? weekStart;
  Null? weekEnd;
  Null? startTime;
  Null? endTime;
  String? note;

  MyRequestInfo(
      {this.id,
        this.userId,
        this.date,
        this.status,
        this.approvedBy,
        this.rejectedBy,
        this.approvedAt,
        this.rejectedAt,
        this.rejectReason,
        this.message,
        this.requestedUser,
        this.requestedUserImage,
        this.requestedUserThumbImage,
        this.editedUserId,
        this.editedUserName,
        this.editedUserImage,
        this.editedUserThumbImage,
        this.weekStart,
        this.weekEnd,
        this.startTime,
        this.endTime,
        this.note});

  MyRequestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    status = json['status'];
    approvedBy = json['approved_by'];
    rejectedBy = json['rejected_by'];
    approvedAt = json['approved_at'];
    rejectedAt = json['rejected_at'];
    rejectReason = json['reject_reason'];
    message = json['message'];
    requestedUser = json['requested_user'];
    requestedUserImage = json['requested_user_image'];
    requestedUserThumbImage = json['requested_user_thumb_image'];
    editedUserId = json['edited_user_id'];
    editedUserName = json['edited_user_name'];
    editedUserImage = json['edited_user_image'];
    editedUserThumbImage = json['edited_user_thumb_image'];
    weekStart = json['week_start'];
    weekEnd = json['week_end'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['status'] = this.status;
    data['approved_by'] = this.approvedBy;
    data['rejected_by'] = this.rejectedBy;
    data['approved_at'] = this.approvedAt;
    data['rejected_at'] = this.rejectedAt;
    data['reject_reason'] = this.rejectReason;
    data['message'] = this.message;
    data['requested_user'] = this.requestedUser;
    data['requested_user_image'] = this.requestedUserImage;
    data['requested_user_thumb_image'] = this.requestedUserThumbImage;
    data['edited_user_id'] = this.editedUserId;
    data['edited_user_name'] = this.editedUserName;
    data['edited_user_image'] = this.editedUserImage;
    data['edited_user_thumb_image'] = this.editedUserThumbImage;
    data['week_start'] = this.weekStart;
    data['week_end'] = this.weekEnd;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['note'] = this.note;
    return data;
  }
}