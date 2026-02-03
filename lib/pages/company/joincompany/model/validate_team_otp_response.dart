class ValidateTeamOtpResponse {
  bool? isSuccess;
  String? message;
  Info? info;

  ValidateTeamOtpResponse({this.isSuccess, this.message, this.info});

  ValidateTeamOtpResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  int? companyId;
  String? otp;
  String? companyName,companyLogoUrl,companyLogoThumbUrl;

  Info({
    this.id,
    this.name,
    this.companyId,
    this.otp,
    this.companyName,
    this.companyLogoUrl,
    this.companyLogoThumbUrl
  });

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    otp = json['otp'];
    companyName = json['company_name'];
    companyLogoUrl = json['company_logo_url'];
    companyLogoThumbUrl = json['company_logo_thumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['otp'] = this.otp;
    data['company_name'] = this.companyName;
    data['company_logo_url'] = this.companyLogoUrl;
    data['company_logo_thumb_url'] = this.companyLogoThumbUrl;

    return data;
  }
}
