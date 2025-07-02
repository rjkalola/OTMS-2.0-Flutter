class WorkLogDetailsInfo {
  int? id;
  int? requestLogId;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;
  String? note;
  int? status;
  String? statusText;

  WorkLogDetailsInfo(
      {this.id,
        this.requestLogId,
        this.workStartTime,
        this.workEndTime,
        this.totalWorkSeconds,
        this.note,
        this.status,
        this.statusText});

  WorkLogDetailsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestLogId = json['request_log_id'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
    note = json['note'];
    status = json['status'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_log_id'] = this.requestLogId;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    data['note'] = this.note;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    return data;
  }
}