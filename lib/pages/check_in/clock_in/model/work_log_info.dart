import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/project/project_info/model/geofence_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/break_info.dart';

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

  // bool? isRequestPending;
  List<BreakInfo>? breakLog;
  LocationInfo? startWorkLocation;
  LocationInfo? stopWorkLocation;
  List<CheckLogInfo>? userChecklogs;
  int? userCheckLogsCount;
  bool? isExpanded;
  int? requestStatus;
  String? oldStartTime;
  String? oldEndTime;
  int? oldPayableWorkSeconds;
  int? penaltySeconds;
  String? allWorklogsAmount;
  int? allWorklogsSeconds;
  String? allExpenseAmount;
  int? allExpenseCount;
  String? allChecklogAmount;
  int? allChecklogCount;
  int? allPenaltySeconds;
  String? totalPenaltyAmount;
  String? totalDayEarnings;
  int? totalDaySeconds;
  String? currency;
  List<GeofenceInfo>? geofences;
  int? userId;
  String? userName;
  String? userImage;
  String? userImageThumb;

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
      // this.isRequestPending,
      this.breakLog,
      this.startWorkLocation,
      this.stopWorkLocation,
      this.userChecklogs,
      this.userCheckLogsCount,
      this.isExpanded,
      this.requestStatus,
      this.oldStartTime,
      this.oldEndTime,
      this.oldPayableWorkSeconds,
      this.allWorklogsAmount,
      this.allWorklogsSeconds,
      this.allExpenseAmount,
      this.allExpenseCount,
      this.allChecklogAmount,
      this.allChecklogCount,
      this.allPenaltySeconds,
      this.totalPenaltyAmount,
      this.totalDayEarnings,
      this.totalDaySeconds,
      this.penaltySeconds,
      this.geofences,
      this.currency,
      this.userId,
      this.userName,
      this.userImage,
      this.userImageThumb});

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
    // isRequestPending = json['is_request_pending'];
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
    isExpanded = json['isExpanded'];
    requestStatus = json['request_status'];
    oldStartTime = json['old_start_time'];
    oldEndTime = json['old_end_time'];
    oldPayableWorkSeconds = json['old_payable_work_seconds'];
    allWorklogsAmount = json['all_worklogs_amount'];
    allWorklogsSeconds = json['all_worklogs_seconds'];
    allExpenseAmount = json['all_expense_amount'];
    allExpenseCount = json['all_expense_count'];
    allChecklogAmount = json['all_checklog_amount'];
    allChecklogCount = json['all_checklog_count'];
    allPenaltySeconds = json['all_penalty_seconds'];
    totalPenaltyAmount = json['total_penalty_amount'];
    totalDayEarnings = json['total_day_earnings'];
    totalDaySeconds = json['total_day_seconds'];
    penaltySeconds = json['penalty_seconds'];
    if (json['geofences'] != null) {
      geofences = <GeofenceInfo>[];
      json['geofences'].forEach((v) {
        geofences!.add(new GeofenceInfo.fromJson(v));
      });
    }
    currency = json['currency'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userImageThumb = json['user_image_thumb'];
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
    // data['is_request_pending'] = this.isRequestPending;
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
    data['isExpanded'] = this.isExpanded;
    data['request_status'] = this.requestStatus;
    data['old_start_time'] = this.oldStartTime;
    data['old_end_time'] = this.oldEndTime;
    data['old_payable_work_seconds'] = this.oldPayableWorkSeconds;
    data['all_worklogs_amount'] = this.allWorklogsAmount;
    data['all_worklogs_seconds'] = this.allWorklogsSeconds;
    data['all_expense_amount'] = this.allExpenseAmount;
    data['all_expense_count'] = this.allExpenseCount;
    data['all_checklog_amount'] = this.allChecklogAmount;
    data['all_checklog_count'] = this.allChecklogCount;
    data['all_penalty_seconds'] = this.allPenaltySeconds;
    data['total_penalty_amount'] = this.totalPenaltyAmount;
    data['total_day_earnings'] = this.totalDayEarnings;
    data['total_day_seconds'] = this.totalDaySeconds;
    data['penalty_seconds'] = this.penaltySeconds;
    if (this.geofences != null) {
      data['geofences'] = this.geofences!.map((v) => v.toJson()).toList();
    }
    data['currency'] = this.currency;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_image_thumb'] = this.userImageThumb;

    return data;
  }
}
