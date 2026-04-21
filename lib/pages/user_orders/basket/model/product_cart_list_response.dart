import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductCartListResponse {
  bool? isSuccess;
  String? message;
  List<ProductInfo>? info;
  int? cartProduct;

  ProductCartListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProduct = json['cart_product'];

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
    data['cart_product'] = cartProduct;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
