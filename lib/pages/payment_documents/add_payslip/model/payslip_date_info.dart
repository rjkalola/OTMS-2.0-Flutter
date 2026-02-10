import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_info.dart';
import 'package:belcka/pages/payment_documents/add_payslip/model/payslip_info.dart';

class PayslipDateInfo {
  String? date;
  List<PayslipInfo>? data;

  PayslipDateInfo({this.date, this.data});

  PayslipDateInfo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <PayslipInfo>[];
      json['data'].forEach((v) {
        data!.add(PayslipInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
