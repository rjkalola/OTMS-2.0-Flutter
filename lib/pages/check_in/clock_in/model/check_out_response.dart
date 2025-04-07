class CheckOutResponse {
  bool? isSuccess;
  String? message;
  int? userWorklogId;
  bool? outsideOfBoundary;

  CheckOutResponse(
      {this.isSuccess,
        this.message,
        this.userWorklogId,
        this.outsideOfBoundary});

  CheckOutResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    userWorklogId = json['user_worklog_id'];
    outsideOfBoundary = json['outside_of_boundary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['user_worklog_id'] = this.userWorklogId;
    data['outside_of_boundary'] = this.outsideOfBoundary;
    return data;
  }
}
