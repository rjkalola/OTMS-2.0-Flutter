import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductCartListResponse {
  bool? isSuccess;
  String? message;
  List<ProductInfo>? info;

  ProductCartListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];

    if (json['info'] is List) {
      info = (json['info'] as List)
          .map((v) => ProductInfo.fromJson(v))
          .toList();
    } else {
      info = [];
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
