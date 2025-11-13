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

  Info({
    this.id,
    this.name,
    this.companyId,
    this.otp,
  });

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['otp'] = this.otp;
    return data;
  }
}
