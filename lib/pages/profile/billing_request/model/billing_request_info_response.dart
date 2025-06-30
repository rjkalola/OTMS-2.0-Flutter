import 'package:otm_inventory/pages/profile/billing_request/model/billing_request_info.dart';

class BillingRequestInfoResponse {
  bool? isSuccess;
  String? message;
  BillingRequestInfo? info;

  BillingRequestInfoResponse({this.isSuccess, this.message, this.info});

  BillingRequestInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new BillingRequestInfo.fromJson(json['info']) : null;
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