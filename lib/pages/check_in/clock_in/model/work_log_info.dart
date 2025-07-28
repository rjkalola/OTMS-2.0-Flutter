import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';

class WorkLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
  int? projectId;
  String? projectName;
  bool? isPricework;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;
  int? totalBreaklogSeconds;
  int? payableWorkSeconds;
  bool? isRequestPending;
  List<BreakInfo>? breakLog;
  LocationInfo? startWorkLocation;
  LocationInfo? stopWorkLocation;
  List<CheckLogInfo>? userChecklogs;
  int? userCheckLogsCount;

  WorkLogInfo(
      {this.id,
      this.shiftId,
      this.shiftName,
      this.projectId,
      this.projectName,
      this.isPricework,
      this.workStartTime,
      this.workEndTime,
      this.totalWorkSeconds,
      this.totalBreaklogSeconds,
      this.payableWorkSeconds,
      this.isRequestPending,
      this.breakLog,
      this.startWorkLocation,
      this.stopWorkLocation,
      this.userChecklogs,
      this.userCheckLogsCount});

  WorkLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    isPricework = json['is_pricework'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
    totalBreaklogSeconds = json['total_breaklog_seconds'];
    payableWorkSeconds = json['payable_work_seconds'];
    isRequestPending = json['is_request_pending'];
    if (json['break_log'] != null) {
      breakLog = <BreakInfo>[];
      json['break_log'].forEach((v) {
        breakLog!.add(new BreakInfo.fromJson(v));
      });
    }
    startWorkLocation = json['start_work_location'] != null
        ? new LocationInfo.fromJson(json['start_work_location'])
        : null;
    stopWorkLocation = json['stop_work_location'] != null
        ? new LocationInfo.fromJson(json['stop_work_location'])
        : null;
    if (json['user_checklogs'] != null) {
      userChecklogs = <CheckLogInfo>[];
      json['user_checklogs'].forEach((v) {
        userChecklogs!.add(new CheckLogInfo.fromJson(v));
      });
    }
    userCheckLogsCount = json['user_checklogs_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['is_pricework'] = this.isPricework;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    data['total_breaklog_seconds'] = this.totalBreaklogSeconds;
    data['payable_work_seconds'] = this.payableWorkSeconds;
    data['is_request_pending'] = this.isRequestPending;
    if (this.breakLog != null) {
      data['break_log'] = this.breakLog!.map((v) => v.toJson()).toList();
    }
    if (this.startWorkLocation != null) {
      data['start_work_location'] = this.startWorkLocation!.toJson();
    }
    if (this.stopWorkLocation != null) {
      data['stop_work_location'] = this.stopWorkLocation!.toJson();
    }
    if (this.userChecklogs != null) {
      data['user_checklogs'] =
          this.userChecklogs!.map((v) => v.toJson()).toList();
    }
    data['user_checklogs_count'] = this.userCheckLogsCount;
    return data;
  }
}
