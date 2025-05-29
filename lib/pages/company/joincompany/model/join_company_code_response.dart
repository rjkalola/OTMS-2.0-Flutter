import 'package:otm_inventory/web_services/response/module_info.dart';

class JoinCompanyCodeResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? trades;
  int? companyId;
  String? companyName;
  String? companyLogo;

  JoinCompanyCodeResponse(
      {this.isSuccess,
      this.message,
      this.trades,
      this.companyId,
      this.companyName,
      this.companyLogo});

  JoinCompanyCodeResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    if (json['trades'] != null) {
      trades = <ModuleInfo>[];
      json['trades'].forEach((v) {
        trades!.add(new ModuleInfo.fromJson(v));
      });
    }
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyLogo = json['company_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.trades != null) {
      data['trades'] = this.trades!.map((v) => v.toJson()).toList();
    }
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['company_logo'] = this.companyLogo;
    return data;
  }
}
