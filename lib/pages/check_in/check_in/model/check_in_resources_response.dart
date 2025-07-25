import 'package:otm_inventory/web_services/response/module_info.dart';

class CheckInResourcesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? addresses;
  List<ModuleInfo>? trades;
  List<ModuleInfo>? typeOfWorks;

  CheckInResourcesResponse(
      {this.isSuccess,
      this.message,
      this.addresses,
      this.trades,
      this.typeOfWorks});

  CheckInResourcesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['addresses'] != null) {
      addresses = <ModuleInfo>[];
      json['addresses'].forEach((v) {
        addresses!.add(new ModuleInfo.fromJson(v));
      });
    }
    if (json['trades'] != null) {
      trades = <ModuleInfo>[];
      json['trades'].forEach((v) {
        trades!.add(new ModuleInfo.fromJson(v));
      });
    }
    if (json['typeOfWorks'] != null) {
      typeOfWorks = <ModuleInfo>[];
      json['typeOfWorks'].forEach((v) {
        typeOfWorks!.add(new ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    if (this.trades != null) {
      data['trades'] = this.trades!.map((v) => v.toJson()).toList();
    }
    if (this.typeOfWorks != null) {
      data['typeOfWorks'] = this.typeOfWorks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
