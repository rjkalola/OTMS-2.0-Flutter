class StartWorkResponse {
  bool? isSuccess;
  String? message;
  int? userWorklogId;
  bool? isRateApproved;

  StartWorkResponse({
    this.isSuccess,
    this.message,
    this.userWorklogId,
    this.isRateApproved,
  });

  StartWorkResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userWorklogId = json['user_worklog_id'];
    isRateApproved = json['is_rate_approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['user_worklog_id'] = this.userWorklogId;
    data['is_rate_approved'] = this.isRateApproved;
    return data;
  }
}
