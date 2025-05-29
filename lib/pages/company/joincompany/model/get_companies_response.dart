import 'package:otm_inventory/web_services/response/module_info.dart';

class GetCompaniesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? info;

  GetCompaniesResponse({this.isSuccess, this.message, this.info});

  GetCompaniesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    if (json['info'] != null) {
      info = <ModuleInfo>[];
      json['info'].forEach((v) {
        info!.add(ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    if (info != null) {
      data['info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
