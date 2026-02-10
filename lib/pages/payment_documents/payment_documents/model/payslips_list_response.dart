import 'package:belcka/pages/payment_documents/add_payslip/model/payslip_date_info.dart';

class PayslipsListResponse {
  bool? isSuccess;
  String? message;
  List<PayslipDateInfo>? info;

  PayslipsListResponse({this.isSuccess, this.message, this.info});

  PayslipsListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <PayslipDateInfo>[];
      json['info'].forEach((v) {
        info!.add(new PayslipDateInfo.fromJson(v));
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

