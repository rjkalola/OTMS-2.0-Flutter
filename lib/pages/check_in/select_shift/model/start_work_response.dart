class StartWorkResponse {
  bool? isSuccess;
  String? message;
  int? userWorklogId;

  StartWorkResponse({this.isSuccess, this.message, this.userWorklogId});

  StartWorkResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userWorklogId = json['user_worklog_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['user_worklog_id'] = this.userWorklogId;
    return data;
  }
}
