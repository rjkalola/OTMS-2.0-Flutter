class UserBillingInfoValidationResponse {
  bool? isSuccess;
  String? message;
  bool? isBillingInfoCompleted;
  String? phone;
  String? extension;
  String? phoneWithExtension;

  UserBillingInfoValidationResponse(
      {this.isSuccess,
      this.message,
      this.isBillingInfoCompleted,
      this.phone,
      this.extension,
      this.phoneWithExtension});

  UserBillingInfoValidationResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    isBillingInfoCompleted = json['is_billing_info_completed'];
    phone = json['phone'];
    extension = json['extension'];
    phoneWithExtension = json['phone_with_extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['is_billing_info_completed'] = this.isBillingInfoCompleted;
    data['phone'] = this.phone;
    data['extension'] = this.extension;
    data['phone_with_extension'] = this.phoneWithExtension;
    return data;
  }
}
