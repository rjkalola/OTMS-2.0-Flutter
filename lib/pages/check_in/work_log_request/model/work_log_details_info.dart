import 'package:belcka/pages/check_in/clock_in/model/location_info.dart';
import 'package:belcka/pages/shifts/create_shift/model/break_info.dart';

class WorkLogDetailsInfo {
  int? id;
  int? requestLogId;
  int? userId;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? workStartTime;
  String? workEndTime;
  int? totalWorkSeconds;
  int? totalBreakSeconds;
  int? payableWorkSeconds;
  int? totalRequestWorkSeconds;
  String? note;
  String? rejectReason;
  int? status;
  String? statusText;
  List<BreakInfo>? breakLog;
  LocationInfo? startWorkLocation;
  LocationInfo? stopWorkLocation;

  WorkLogDetailsInfo(
      {this.id,
        this.requestLogId,
        this.userId,
        this.userName,
        this.userImage,
        this.userThumbImage,
        this.workStartTime,
        this.workEndTime,
        this.totalWorkSeconds,
        this.totalBreakSeconds,
        this.payableWorkSeconds,
        this.totalRequestWorkSeconds,
        this.note,
        this.rejectReason,
        this.status,
        this.statusText,
        this.breakLog,
        this.startWorkLocation,
        this.stopWorkLocation});

  WorkLogDetailsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestLogId = json['request_log_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    totalWorkSeconds = json['total_work_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    payableWorkSeconds = json['payable_work_seconds'];
    totalRequestWorkSeconds = json['total_request_work_seconds'];
    note = json['note'];
    rejectReason = json['reject_reason'];
    status = json['status'];
    statusText = json['status_text'];
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
    data['request_log_id'] = this.requestLogId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['total_work_seconds'] = this.totalWorkSeconds;
    data['total_break_seconds'] = this.totalBreakSeconds;
    data['payable_work_seconds'] = this.payableWorkSeconds;
    data['total_request_work_seconds'] = this.totalRequestWorkSeconds;
    data['note'] = this.note;
    data['reject_reason'] = this.rejectReason;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
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