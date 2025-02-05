class VerifyPhoneResponse {
  bool? isSuccess;
  String? message;
  bool? passwordExist;
  bool? imageExist;

  VerifyPhoneResponse(
      {this.isSuccess, this.message, this.passwordExist, this.imageExist});

  VerifyPhoneResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    passwordExist = json['password_exist'];
    imageExist = json['image_exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['password_exist'] = this.passwordExist;
    data['image_exist'] = this.imageExist;
    return data;
  }
}
