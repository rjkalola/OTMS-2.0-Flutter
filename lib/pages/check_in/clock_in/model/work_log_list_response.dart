import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/shift_info.dart';

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
  List<LeaveInfo>? userLeaves;
  int? shiftId;
  String? shiftName;
  int? projectId;
  String? projectName;

  WorkLogListResponse(
      {this.isSuccess,
      this.message,
      this.userIsWorking,
      this.totalWorkingSeconds,
      this.totalBreakSeconds,
      this.totalPayableWorkingSeconds,
      this.shiftInfo,
      this.workStartDate,
      this.workLogInfo,
      this.userLeaves,
      this.shiftId,
      this.shiftName,
      this.projectId,
      this.projectName});

  WorkLogListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userIsWorking = json['user_is_working'];
    totalWorkingSeconds = json['total_working_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    totalPayableWorkingSeconds = json['total_payable_working_seconds'];
    shiftInfo = json['shift_info'] != null
        ? ShiftInfo.fromJson(json['shift_info'])
        : null;
    workStartDate = json['work_start_date'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    if (json['my_worklogs'] != null) {
      workLogInfo = <WorkLogInfo>[];
      json['my_worklogs'].forEach((v) {
        workLogInfo!.add(new WorkLogInfo.fromJson(v));
      });
    }
    if (json['user_leaves'] != null) {
      userLeaves = <LeaveInfo>[];
      json['user_leaves'].forEach((v) {
        userLeaves!.add(new LeaveInfo.fromJson(v));
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
    if (this.userLeaves != null) {
      data['user_leaves'] = this.userLeaves!.map((v) => v.toJson()).toList();
    }
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    return data;
  }
}
