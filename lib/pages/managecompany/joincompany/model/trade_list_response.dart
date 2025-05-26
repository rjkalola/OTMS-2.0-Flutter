import 'package:otm_inventory/web_services/response/module_info.dart';

class TradeListResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? info;

  TradeListResponse({this.isSuccess, this.message, this.info});

  TradeListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['company_trades'] != null) {
      info = <ModuleInfo>[];
      json['company_trades'].forEach((v) {
        info!.add(new ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['company_trades'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
