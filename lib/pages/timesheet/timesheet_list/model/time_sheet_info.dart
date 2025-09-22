import 'package:belcka/pages/timesheet/timesheet_list/model/day_log_info.dart';
import 'package:belcka/pages/timesheet/timesheet_list/model/week_log_info.dart';

class TimeSheetInfo {
  int? userId;
  String? tradeName;
  String? userName;
  String? userImage;
  String? userThumbImage;
  String? amount;
  int? status;
  String? statusMessage;
  int? weekNumber;
  String? startDate;
  String? endDate;
  String? startDateMonth;
  String? endDateMonth;
  int? actualWorkSeconds;
  int? totalBreakSeconds;
  int? payableWorkSeconds;
  bool? isExpanded;
  List<DayLogInfo>? dayLogs;
  List<WeekLogInfo>? weekLogs;

  TimeSheetInfo(
      {this.userId,
      this.tradeName,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.amount,
      this.status,
      this.statusMessage,
      this.weekNumber,
      this.startDate,
      this.endDate,
      this.startDateMonth,
      this.endDateMonth,
      this.actualWorkSeconds,
      this.totalBreakSeconds,
      this.payableWorkSeconds,
      this.isExpanded,
      this.dayLogs,
      this.weekLogs});

  TimeSheetInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    tradeName = json['trade_name'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    amount = json['amount'];
    status = json['status'];
    statusMessage = json['status_message'];
    weekNumber = json['week_number'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startDateMonth = json['start_date_month'];
    endDateMonth = json['end_date_month'];
    actualWorkSeconds = json['actual_work_seconds'];
    totalBreakSeconds = json['total_break_seconds'];
    payableWorkSeconds = json['payable_work_seconds'];
    isExpanded = json['isExpanded'];
    if (json['day_logs'] != null) {
      dayLogs = <DayLogInfo>[];
      json['day_logs'].forEach((v) {
        dayLogs!.add(new DayLogInfo.fromJson(v));
      });
    }
    if (json['week_logs'] != null) {
      weekLogs = <WeekLogInfo>[];
      json['week_logs'].forEach((v) {
        weekLogs!.add(new WeekLogInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['trade_name'] = this.tradeName;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['status_message'] = this.statusMessage;
    data['week_number'] = this.weekNumber;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_date_month'] = this.startDateMonth;
    data['end_date_month'] = this.endDateMonth;
    data['actual_work_seconds'] = this.actualWorkSeconds;
    data['total_break_seconds'] = this.totalBreakSeconds;
    data['payable_work_seconds'] = this.payableWorkSeconds;
    data['isExpanded'] = this.isExpanded;
    if (this.dayLogs != null) {
      data['day_logs'] = this.dayLogs!.map((v) => v.toJson()).toList();
    }
    if (this.weekLogs != null) {
      data['week_logs'] = this.weekLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
