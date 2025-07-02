class CounterDetails {
  int totalWorkSeconds = 0;
  String totalWorkTime = "";
  int? totalBreakSeconds = 0;
  String? totalBreakTime = "";
  int remainingBreakSeconds = 0;
  String remainingBreakTime = "";
  bool isOnBreak = false;

  CounterDetails(
      {required this.totalWorkSeconds,
      required this.totalWorkTime,
      this.totalBreakSeconds,
      this.totalBreakTime,
      required this.remainingBreakSeconds,
      required this.remainingBreakTime,
      required this.isOnBreak});

  CounterDetails.fromJson(Map<String, dynamic> json) {
    totalWorkSeconds = json['totalWorkSeconds'];
    totalWorkTime = json['totalWorkTime'];
    totalBreakSeconds = json['totalBreakSeconds'];
    totalBreakTime = json['totalBreakTime'];
    remainingBreakSeconds = json['remainingBreakSeconds'];
    remainingBreakTime = json['remainingBreakTime'];
    isOnBreak = json['isOnBreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalWorkSeconds'] = this.totalWorkSeconds;
    data['totalWorkTime'] = this.totalWorkTime;
    data['totalBreakSeconds'] = this.totalBreakSeconds;
    data['totalBreakTime'] = this.totalBreakTime;
    data['remainingBreakSeconds'] = this.remainingBreakSeconds;
    data['remainingBreakTime'] = this.remainingBreakTime;

    data['isOnBreak'] = this.isOnBreak;
    return data;
  }
}
