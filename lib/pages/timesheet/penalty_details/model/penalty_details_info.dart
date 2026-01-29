class PenaltyDetailsInfo {
  int? worklogId;
  int? penaltyId;
  String? startTime;
  String? endTime;
  String? payableHours;
  String? formattedStartTime;
  String? formattedEndTime;
  String? penaltyType;
  String? penaltyMinutes;

  PenaltyDetailsInfo(
      {this.worklogId,
      this.penaltyId,
      this.startTime,
      this.endTime,
      this.payableHours,
      this.formattedStartTime,
      this.formattedEndTime,
      this.penaltyType,
      this.penaltyMinutes});

  PenaltyDetailsInfo.fromJson(Map<String, dynamic> json) {
    worklogId = json['worklog_id'];
    penaltyId = json['penalty_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    payableHours = json['payable_hours'];
    formattedStartTime = json['formatted_start_time'];
    formattedEndTime = json['formatted_end_time'];
    penaltyType = json['penalty_type'];
    penaltyMinutes = json['penalty_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['worklog_id'] = this.worklogId;
    data['penalty_id'] = this.penaltyId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['payable_hours'] = this.payableHours;
    data['formatted_start_time'] = this.formattedStartTime;
    data['formatted_end_time'] = this.formattedEndTime;
    data['penalty_type'] = this.penaltyType;
    data['penalty_minutes'] = this.penaltyMinutes;
    return data;
  }
}
