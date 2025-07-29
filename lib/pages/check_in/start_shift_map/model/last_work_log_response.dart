class LastWorkLog {
  bool? isSuccess;
  String? message;
  int? shiftId;
  String? shiftName;
  int? projectId;
  String? projectName;

  LastWorkLog(
      {this.isSuccess,
      this.message,
      this.shiftId,
      this.shiftName,
      this.projectId,
      this.projectName});

  LastWorkLog.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    return data;
  }
}
