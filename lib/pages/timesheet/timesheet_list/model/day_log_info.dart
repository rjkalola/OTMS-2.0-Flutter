class DayLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
  int? teamId;
  String? teamName;
  int? timesheetId;
  String? type;
  int? supervisorId;
  int? projectId;
  int? addressId;
  bool? isPricework;
  String? dateAdded;
  String? day;
  String? dayDateInt;
  String? startTime;
  String? endTime;
  String? startTimeFormat;
  String? endTimeFormat;
  String? location;
  String? latitude;
  String? longitude;
  String? totalMinutes;
  int? totalSeconds;
  String? perHourRate;
  String? totalAmount;
  int? status;

  DayLogInfo(
      {this.id,
        this.shiftId,
        this.shiftName,
        this.teamId,
        this.teamName,
        this.timesheetId,
        this.type,
        this.supervisorId,
        this.projectId,
        this.addressId,
        this.isPricework,
        this.dateAdded,
        this.day,
        this.dayDateInt,
        this.startTime,
        this.endTime,
        this.startTimeFormat,
        this.endTimeFormat,
        this.location,
        this.latitude,
        this.longitude,
        this.totalMinutes,
        this.totalSeconds,
        this.perHourRate,
        this.totalAmount,
        this.status});

  DayLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    timesheetId = json['timesheet_id'];
    type = json['type'];
    supervisorId = json['supervisor_id'];
    projectId = json['project_id'];
    addressId = json['address_id'];
    isPricework = json['is_pricework'];
    dateAdded = json['date_added'];
    day = json['day'];
    dayDateInt = json['day_date_int'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    startTimeFormat = json['start_time_format'];
    endTimeFormat = json['end_time_format'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    totalMinutes = json['total_minutes'];
    totalSeconds = json['total_seconds'];
    perHourRate = json['per_hour_rate'];
    totalAmount = json['total_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    data['timesheet_id'] = this.timesheetId;
    data['type'] = this.type;
    data['supervisor_id'] = this.supervisorId;
    data['project_id'] = this.projectId;
    data['address_id'] = this.addressId;
    data['is_pricework'] = this.isPricework;
    data['date_added'] = this.dateAdded;
    data['day'] = this.day;
    data['day_date_int'] = this.dayDateInt;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['start_time_format'] = this.startTimeFormat;
    data['end_time_format'] = this.endTimeFormat;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['total_minutes'] = this.totalMinutes;
    data['total_seconds'] = this.totalSeconds;
    data['per_hour_rate'] = this.perHourRate;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    return data;
  }
}