import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';

class WorkLogListResponse {
  bool? isSuccess;
  String? message;
  bool? userIsWorking;
  int? totalWorkingSeconds;
  int? totalBreakSeconds;
  int? totalPayableWorkingSeconds;
  ShiftInfo? shiftInfo;
  String? workStartDate;
  List<WorkLogInfo>? workLogInfo;

  WorkLogListResponse(
      {this.isSuccess,
        this.message,
        this.userIsWorking,
        this.totalWorkingSeconds,
        this.totalBreakSeconds,
        this.totalPayableWorkingSeconds,
        this.shiftInfo,
        this.workStartDate,
        this.workLogInfo});

  WorkLogListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userIsWorking = json['user_is_working'];
    totalWorkingSeconds = json['total_working_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    totalPayableWorkingSeconds = json['total_payable_working_seconds'];
    shiftInfo = json['shift_info'] != null ? ShiftInfo.fromJson(json['shift_info']) : null;
    workStartDate = json['work_start_date'];
    if (json['my_worklogs'] != null) {
      workLogInfo = <WorkLogInfo>[];
      json['my_worklogs'].forEach((v) {
        workLogInfo!.add(new WorkLogInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['user_is_working'] = this.userIsWorking;
    data['total_working_seconds'] = this.totalWorkingSeconds;
    data['total_break_seconds'] = this.totalBreakSeconds;
    data['total_payable_working_seconds'] = this.totalPayableWorkingSeconds;
    if (this.shiftInfo != null) {
      data['shift_info'] = this.shiftInfo!.toJson();
    }
    data['work_start_date'] = this.workStartDate;
    if (this.workLogInfo != null) {
      data['my_worklogs'] = this.workLogInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}