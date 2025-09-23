class UserPayRateResponse{
  bool? isSuccess;
  String? message;
  UserPayRateInfo? info;

  UserPayRateResponse({this.isSuccess, this.message, this.info});

  UserPayRateResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new UserPayRateInfo.fromJson(json['info']) : null;
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

class UserPayRateInfo {
  bool? showPayRate;

  UserPayRateInfo({this.showPayRate});

  UserPayRateInfo.fromJson(Map<String, dynamic> json) {
    showPayRate = json['show_pay_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_pay_rate'] = this.showPayRate;
    return data;
  }
}