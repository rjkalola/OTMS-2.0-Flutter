import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';
import 'package:belcka/pages/expense/add_expense/model/expense_info.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';

class DayLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
  int? teamId;
  String? teamName;
  String? tradeName;
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
  int? actualWorkSeconds;
  int? totalBreakSeconds;
  int? payableWorkSeconds;
  String? perHourRate;
  String? totalAmount;
  String? payableAmount;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? userCheckLogsCount;
  String? priceWorkTotalAmount;
  int? requestStatus;
  LeaveInfo? leaveInfo;
  ExpenseInfo? expenseInfo;
  PenaltyInfo? penaltyInfo;
  bool? isCheck;

  DayLogInfo({
    this.id,
    this.shiftId,
    this.shiftName,
    this.teamId,
    this.teamName,
    this.tradeName,
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
    this.actualWorkSeconds,
    this.totalBreakSeconds,
    this.payableWorkSeconds,
    this.perHourRate,
    this.totalAmount,
    this.payableAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userCheckLogsCount,
    this.priceWorkTotalAmount,
    this.requestStatus,
    this.leaveInfo,
    this.expenseInfo,
    this.penaltyInfo,
    this.isCheck,
  });

  DayLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    tradeName = json['trade_name'];
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
    actualWorkSeconds = json['actual_work_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    payableWorkSeconds = json['payable_work_seconds'];
    perHourRate = json['per_hour_rate'];
    totalAmount = json['total_amount'];
    payableAmount = json['payable_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userCheckLogsCount = json['user_checklogs_count'];
    priceWorkTotalAmount = json['pricework_total_amount'];
    requestStatus = json['request_status'];
    leaveInfo = json['leave_info'] != null
        ? LeaveInfo.fromJson(json['leave_info'])
        : null;
    expenseInfo = json['expense_info'] != null
        ? ExpenseInfo.fromJson(json['expense_info'])
        : null;
    penaltyInfo = json['penalty_info'] != null
        ? PenaltyInfo.fromJson(json['penalty_info'])
        : null;
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    data['trade_name'] = this.tradeName;
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
    data['actual_work_seconds'] = this.actualWorkSeconds;
    data['total_break_seconds'] = this.totalBreakSeconds;
    data['payable_work_seconds'] = this.payableWorkSeconds;
    data['per_hour_rate'] = this.perHourRate;
    data['total_amount'] = this.totalAmount;
    data['payable_amount'] = this.payableAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_checklogs_count'] = this.userCheckLogsCount;
    data['pricework_total_amount'] = this.priceWorkTotalAmount;
    data['request_status'] = this.requestStatus;
    if (this.leaveInfo != null) {
      data['leave_info'] = this.leaveInfo!.toJson();
    }
    if (this.expenseInfo != null) {
      data['expense_info'] = this.expenseInfo!.toJson();
    }
    if (this.penaltyInfo != null) {
      data['penalty_info'] = this.penaltyInfo!.toJson();
    }

    data['isCheck'] = this.isCheck;
    return data;
  }
}
