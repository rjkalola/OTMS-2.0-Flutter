import 'dart:convert';

PieChartInfo pieChartInfoFromJson(String str) =>
    PieChartInfo.fromJson(json.decode(str));

class PieChartInfo {
  PieChartInfo({
    this.milliseconds,
    this.type,
    this.hour,
    this.angle,
  });

  int? milliseconds, type;
  double? hour, angle;

  factory PieChartInfo.fromJson(Map<String, dynamic> json) => PieChartInfo(
        milliseconds: json["milliseconds"],
        type: json["type"],
        hour: json["hour"],
        angle: json["angle"],
      );

  Map<String, dynamic> toJson() => {
        "milliseconds": milliseconds,
        "type": type,
        "hour": hour,
        "angle": angle,
      };
}
