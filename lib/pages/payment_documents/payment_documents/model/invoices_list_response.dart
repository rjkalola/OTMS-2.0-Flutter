import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_date_info.dart';

class InvoicesListResponse {
  bool? isSuccess;
  String? message;
  List<InvoiceDateInfo>? info;

  InvoicesListResponse({this.isSuccess, this.message, this.info});

  InvoicesListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <InvoiceDateInfo>[];
      json['info'].forEach((v) {
        info!.add(new InvoiceDateInfo.fromJson(v));
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

