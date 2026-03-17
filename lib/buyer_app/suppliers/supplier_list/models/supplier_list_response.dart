import 'package:belcka/buyer_app/suppliers/supplier_list/models/supplier_info.dart';

class SupplierListResponse {
  bool? isSuccess;
  String? message;
  List<SupplierInfo>? info;

  SupplierListResponse({this.isSuccess, this.message, this.info});

  SupplierListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <SupplierInfo>[];
      json['info'].forEach((v) {
        info!.add(new SupplierInfo.fromJson(v));
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


