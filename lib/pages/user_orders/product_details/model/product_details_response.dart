import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductDetailsResponse {
  bool? isSuccess;
  String? message;
  int? cartProduct;
  ProductInfo? info;

  ProductDetailsResponse({this.isSuccess, this.message, this.info});

  ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProduct = json['cart_product'];
    info = json['info'] != null ? ProductInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['cart_product'] = this.cartProduct;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
