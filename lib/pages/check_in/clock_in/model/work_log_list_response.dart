import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';

class WorkLogListResponse {
  bool? isSuccess;
  String? message;
  bool? userIsWorking;
  int? totalWorkingHours;
  String? workStartDate;
  ShiftInfo? shiftInfo;
  List<WorkLogInfo>? workLogInfo;

  WorkLogListResponse(
      {this.isSuccess,
      this.message,
      this.userIsWorking,
      this.totalWorkingHours,
      this.workStartDate,
      this.shiftInfo,
      this.workLogInfo});

  WorkLogListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userIsWorking = json['user_is_working'];
    totalWorkingHours = json['total_working_hours'];
    workStartDate = json['work_start_date'];
    shiftInfo = json['shift_info'] != null
        ? new ShiftInfo.fromJson(json['shift_info'])
        : null;
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
    data['total_working_hours'] = this.totalWorkingHours;
    data['work_start_date'] = this.workStartDate;
    if (this.shiftInfo != null) {
      data['shift_info'] = this.shiftInfo!.toJson();
    }
    if (this.workLogInfo != null) {
      data['my_worklogs'] = this.workLogInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekDays {
  String? name;
  bool? status;

  WeekDays({this.name, this.status});

  WeekDays.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
