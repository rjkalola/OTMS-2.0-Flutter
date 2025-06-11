class RequestCountResponse {
  bool? isSuccess;
  String? message;
  int? pendingTaskCount;
  int? pendingApprovalCount;
  int? pendingCount;

  RequestCountResponse(
      {this.isSuccess,
      this.message,
      this.pendingTaskCount,
      this.pendingApprovalCount,
      this.pendingCount});

  RequestCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    pendingTaskCount = json['pending_task_count'];
    pendingApprovalCount = json['pending_approval_count'];
    pendingCount = json['pendingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['pending_task_count'] = this.pendingTaskCount;
    data['pending_approval_count'] = this.pendingApprovalCount;
    data['pendingCount'] = this.pendingCount;
    return data;
  }
}
