import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_info.dart';

class InvoiceDateInfo {
  String? date;
  List<InvoiceInfo>? data;

  InvoiceDateInfo({this.date, this.data});

  InvoiceDateInfo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <InvoiceInfo>[];
      json['data'].forEach((v) {
        data!.add(InvoiceInfo.fromJson(v));
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
