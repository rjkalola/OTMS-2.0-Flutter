class WeekDayInfo {
  String? name;
  bool? status;

  WeekDayInfo({this.name, this.status});

  WeekDayInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }

  WeekDayInfo copyWeekDayInfo({WeekDayInfo? info}) {
    return WeekDayInfo(
      name: info?.name ?? this.name,
      status: info?.status ?? this.status,
    );
  }
}
