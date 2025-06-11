// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

BreakLogInfo breakLogInfoFromJson(String str) =>
    BreakLogInfo.fromJson(json.decode(str));

class BreakLogInfo {
  BreakLogInfo({
    this.start,
    this.end,
    this.shift_id,
    this.break_minutes,
    this.work_minutes,
  });

  String? start,end;
  int? shift_id,break_minutes,work_minutes;

  factory BreakLogInfo.fromJson(Map<String, dynamic> json) =>
      BreakLogInfo(
        start: json["start"],
        end: json["end"],
        shift_id: json["shift_id"],
        break_minutes: json["break_minutes"],
        work_minutes: json["work_minutes"],
      );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "shift_id": shift_id,
    "break_minutes": break_minutes,
    "work_minutes": work_minutes,
  };
}
