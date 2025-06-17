class BreakInfo {
  int? breakId;
  String? breakStartTime;
  String? breakEndTime;

  BreakInfo({this.breakId, this.breakStartTime, this.breakEndTime});

  BreakInfo.fromJson(Map<String, dynamic> json) {
    breakId = json['break_id'];
    breakStartTime = json['break_start_time'];
    breakEndTime = json['break_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['break_id'] = this.breakId;
    data['break_start_time'] = this.breakStartTime;
    data['break_end_time'] = this.breakEndTime;
    return data;
  }
}
