class WorkLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;

  WorkLogInfo(
      {this.id,
      this.shiftId,
      this.shiftName,
      this.workStartTime,
      this.workEndTime,
      this.totalWorkSeconds});

  WorkLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    return data;
  }
}
