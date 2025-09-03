import 'package:belcka/pages/company/company_signup/model/company_info.dart';

class CompanyListResponse {
  bool? isSuccess;
  String? message;
  List<CompanyInfo>? info;

  CompanyListResponse({this.isSuccess, this.message, this.info});

  CompanyListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <CompanyInfo>[];
      json['info'].forEach((v) {
        info!.add(new CompanyInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
