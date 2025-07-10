import 'package:otm_inventory/pages/check_in/clock_in/model/location_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';

class WorkLogInfo {
  int? id;
  int? shiftId;
  String? shiftName;
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

  WorkLogInfo(
      {this.id,
      this.shiftId,
      this.shiftName,
      this.isPricework,
      this.workStartTime,
      this.workEndTime,
      this.totalWorkSeconds,
      this.totalBreaklogSeconds,
      this.payableWorkSeconds,
      this.isRequestPending,
      this.breakLog,
      this.startWorkLocation,
      this.stopWorkLocation});

  WorkLogInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
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
    return data;
  }
}
