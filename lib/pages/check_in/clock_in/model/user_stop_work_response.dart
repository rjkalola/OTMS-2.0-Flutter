class UserStopWorkResponse {
  bool? isSuccess;
  String? message;
  String? penaltyMessage;
  int? activeCompanyId;

  UserStopWorkResponse({
    this.isSuccess,
    this.message,
    this.penaltyMessage,
    this.activeCompanyId,
  });

  UserStopWorkResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'] ?? json['IsSuccess'];
    message = json['message'];
    penaltyMessage = json['penalty_message'];
    activeCompanyId = json['active_company_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'penalty_message': penaltyMessage,
      'active_company_id': activeCompanyId,
    };
  }
}
