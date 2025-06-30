import 'package:otm_inventory/pages/profile/billing_info/model/billing_ifo.dart';

class BillingInfoResponse {
  bool? isSuccess;
  String? message;
  BillingInfo? info;

  BillingInfoResponse({this.isSuccess, this.message, this.info});

  BillingInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new BillingInfo.fromJson(json['info']) : null;
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

