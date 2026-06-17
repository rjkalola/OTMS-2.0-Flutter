class FormSubmissionStatusResponse {
  bool? isSuccess;
  String? message;
  bool? userCanStartWork;
  int? activeCompanyId;

  FormSubmissionStatusResponse({
    this.isSuccess,
    this.message,
    this.userCanStartWork,
    this.activeCompanyId,
  });

  FormSubmissionStatusResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    userCanStartWork = json['user_can_start_work'];
    activeCompanyId = json['active_company_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'IsSuccess': isSuccess,
      'message': message,
      'user_can_start_work': userCanStartWork,
      'active_company_id': activeCompanyId,
    };
  }
}
