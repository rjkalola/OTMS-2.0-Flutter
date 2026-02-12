import 'package:belcka/pages/payment_documents/payment_documents/model/payments_info.dart';

class PaymentsListResponse {
  bool? isSuccess;
  String? message;
  List<PaymentsInfo>? info;

  PaymentsListResponse({this.isSuccess, this.message, this.info});

  PaymentsListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <PaymentsInfo>[];
      json['info'].forEach((v) {
        info!.add(new PaymentsInfo.fromJson(v));
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
