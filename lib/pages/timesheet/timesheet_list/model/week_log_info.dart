import 'package:belcka/pages/timesheet/timesheet_list/model/day_log_info.dart';

class WeekLogInfo {
  int? weekNumber;
  String? startDate;
  String? endDate;
  String? startDateMonth;
  String? endDateMonth;
  int? dayLogCount;
  List<DayLogInfo>? dayLogs;

  WeekLogInfo(
      {this.weekNumber,
        this.startDate,
        this.endDate,
        this.startDateMonth,
        this.endDateMonth,
        this.dayLogCount,
        this.dayLogs});

  WeekLogInfo.fromJson(Map<String, dynamic> json) {
    weekNumber = json['week_number'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startDateMonth = json['start_date_month'];
    endDateMonth = json['end_date_month'];
    dayLogCount = json['day_log_count'];
    if (json['day_logs'] != null) {
      dayLogs = <DayLogInfo>[];
      json['day_logs'].forEach((v) {
        dayLogs!.add(new DayLogInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['week_number'] = this.weekNumber;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_date_month'] = this.startDateMonth;
    data['end_date_month'] = this.endDateMonth;
    data['day_log_count'] = this.dayLogCount;
    if (this.dayLogs != null) {
      data['day_logs'] = this.dayLogs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}