class JoinCompanyResponse {
  bool? isSuccess;
  String? message;
  Info? info;

  JoinCompanyResponse({this.isSuccess, this.message, this.info});

  JoinCompanyResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  int? userId;
  String? userName;
  int? companyId;
  String? companyName;
  String? companyEmail;
  String? userImage;
  String? userThumbImage;
  String? companyImage;
  String? companyThumbImage;

  Info(
      {this.userId,
        this.userName,
        this.companyId,
        this.companyName,
        this.companyEmail,
        this.userImage,
        this.userThumbImage,
        this.companyImage,
        this.companyThumbImage});

  Info.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyEmail = json['company_email'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    companyImage = json['company_image'];
    companyThumbImage = json['company_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['company_email'] = this.companyEmail;
    data['user_image'] = this.userImage;
    data['user_thumb_image'] = this.userThumbImage;
    data['company_image'] = this.companyImage;
    data['company_thumb_image'] = this.companyThumbImage;
    return data;
  }
}
