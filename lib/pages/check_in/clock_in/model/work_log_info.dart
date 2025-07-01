class WorkLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
  bool? isPricework;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;
  bool? isRequestPending;

  WorkLogInfo(
      {this.id,
      this.shiftId,
      this.shiftName,
      this.isPricework,
      this.workStartTime,
      this.workEndTime,
      this.totalWorkSeconds,
      this.isRequestPending});

  WorkLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    isPricework = json['is_pricework'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
    isRequestPending = json['is_request_pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['is_pricework'] = this.isPricework;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    data['is_request_pending'] = this.isRequestPending;
    return data;
  }
}
