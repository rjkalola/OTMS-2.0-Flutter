class SubContractorDetailsResponse {
  bool? isSuccess;
  String? message;
  SubContractorInfo? info;

  SubContractorDetailsResponse({this.isSuccess, this.message, this.info});

  SubContractorDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? new SubContractorInfo.fromJson(json['info'])
        : null;
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

class SubContractorInfo {
  int? id;
  String? companyName;
  String? companyAdmin;
  String? email;
  String? phone;
  String? companyImageName;
  String? companyImage;
  String? companyThumbImage;

  SubContractorInfo(
      {this.id,
      this.companyName,
      this.companyAdmin,
      this.email,
      this.phone,
      this.companyImageName,
      this.companyImage,
      this.companyThumbImage});

  SubContractorInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyAdmin = json['company_admin'];
    email = json['email'];
    phone = json['phone'];
    companyImageName = json['company_image_name'];
    companyImage = json['company_image'];
    companyThumbImage = json['company_thumb_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['company_admin'] = this.companyAdmin;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['company_image_name'] = this.companyImageName;
    data['company_image'] = this.companyImage;
    data['company_thumb_image'] = this.companyThumbImage;
    return data;
  }
}
