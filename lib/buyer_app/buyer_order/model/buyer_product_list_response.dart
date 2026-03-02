import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class BuyerProductListResponse {
  bool? isSuccess;
  String? message;
  List<ProductInfo>? info;

  BuyerProductListResponse({this.isSuccess, this.message, this.info});

  BuyerProductListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <ProductInfo>[];
      json['info'].forEach((v) {
        info!.add(new ProductInfo.fromJson(v));
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
