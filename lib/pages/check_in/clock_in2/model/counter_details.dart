class CounterDetails {
  int totalWorkSeconds = 0, activeWorkSeconds = 0;
  String totalWorkTime = "";
  int? totalBreakSeconds = 0;
  String? totalBreakTime = "";
  int remainingBreakSeconds = 0;
  int remainingLeaveSeconds = 0;
  String remainingBreakTime = "";
  String remainingLeaveTime = "";
  bool isOnBreak = false, insideShiftTime = false, isOnLeave = false;

  CounterDetails({
    required this.totalWorkSeconds,
    required this.activeWorkSeconds,
    required this.totalWorkTime,
    this.totalBreakSeconds,
    this.totalBreakTime,
    required this.remainingBreakSeconds,
    required this.remainingLeaveSeconds,
    required this.remainingBreakTime,
    required this.remainingLeaveTime,
    required this.isOnBreak,
    required this.insideShiftTime,
    required this.isOnLeave,
  });

  CounterDetails.fromJson(Map<String, dynamic> json) {
    totalWorkSeconds = json['totalWorkSeconds'];
    activeWorkSeconds = json['activeWorkSeconds'];
    totalWorkTime = json['totalWorkTime'];
    totalBreakSeconds = json['totalBreakSeconds'];
    totalBreakTime = json['totalBreakTime'];
    remainingBreakSeconds = json['remainingBreakSeconds'];
    remainingLeaveSeconds = json['remainingLeaveSeconds'];
    remainingBreakTime = json['remainingBreakTime'];
    remainingLeaveTime = json['remainingLeaveTime'];
    isOnBreak = json['isOnBreak'];
    insideShiftTime = json['insideShiftTime'];
    isOnLeave = json['isOnLeave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalWorkSeconds'] = this.totalWorkSeconds;
    data['activeWorkSeconds'] = this.activeWorkSeconds;
    data['totalWorkTime'] = this.totalWorkTime;
    data['totalBreakSeconds'] = this.totalBreakSeconds;
    data['totalBreakTime'] = this.totalBreakTime;
    data['remainingBreakSeconds'] = this.remainingBreakSeconds;
    data['remainingLeaveSeconds'] = this.remainingLeaveSeconds;
    data['remainingBreakTime'] = this.remainingBreakTime;
    data['remainingLeaveTime'] = this.remainingLeaveTime;
    data['isOnBreak'] = this.isOnBreak;
    data['insideShiftTime'] = this.insideShiftTime;
    data['isOnLeave'] = this.isOnLeave;

    return data;
  }
}
