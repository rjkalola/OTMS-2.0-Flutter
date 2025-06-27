import 'package:otm_inventory/pages/timesheet/timesheet_list/model/day_log_info.dart';

class TimeSheetInfo {
  int? id;
  int? companyId;
  int? userId;
  String? tradeName;
  String? userName;
  String? userImage;
  String? userThumbImage;
  int? totalHours;
  String? amount;
  int? status;
  String? statusMessage;
  List<DayLogInfo>? dayLogs;
  int? weekNumber;
  String? startDate;
  String? endDate;
  String? startDateMonth;
  String? endDateMonth;
  String? createdAt;
  String? updatedAt;
  bool? isExpanded;

  TimeSheetInfo(
      {this.id,
      this.companyId,
      this.userId,
      this.tradeName,
      this.userName,
      this.userImage,
      this.userThumbImage,
      this.totalHours,
      this.amount,
      this.status,
      this.statusMessage,
      this.dayLogs,
      this.weekNumber,
      this.startDate,
      this.endDate,
      this.startDateMonth,
      this.endDateMonth,
      this.createdAt,
      this.updatedAt,
      this.isExpanded});

  TimeSheetInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    tradeName = json['trade_name'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    totalHours = json['total_hours'];
    amount = json['amount'];
    status = json['status'];
    statusMessage = json['status_message'];
    if (json['day_logs'] != null) {
      dayLogs = <DayLogInfo>[];
      json['day_logs'].forEach((v) {
        dayLogs!.add(new DayLogInfo.fromJson(v));
      });
    }
    weekNumber = json['week_number'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startDateMonth = json['start_date_month'];
    endDateMonth = json['end_date_month'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isExpanded = json['isExpanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['trade_name'] = this.tradeName;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['total_hours'] = this.totalHours;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['status_message'] = this.statusMessage;
    if (this.dayLogs != null) {
      data['day_logs'] = this.dayLogs!.map((v) => v.toJson()).toList();
    }
    data['week_number'] = this.weekNumber;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_date_month'] = this.startDateMonth;
    data['end_date_month'] = this.endDateMonth;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['isExpanded'] = this.isExpanded;

    return data;
  }
}
