class BreakInfo {
  int? breakId;
  String? breakStartTime;
  String? breakEndTime;
  bool? isPaid;

  BreakInfo(
      {this.breakId, this.breakStartTime, this.breakEndTime, this.isPaid});

  BreakInfo.fromJson(Map<String, dynamic> json) {
    breakId = json['break_id'];
    breakStartTime = json['break_start_time'];
    breakEndTime = json['break_end_time'];
    isPaid = json['is_paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['break_id'] = this.breakId;
    data['break_start_time'] = this.breakStartTime;
    data['break_end_time'] = this.breakEndTime;
    data['is_paid'] = this.isPaid;
    return data;
  }
}
