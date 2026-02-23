import 'package:belcka/pages/user_orders/storeman_catalog/model/get_products_info_model.dart';

class GetProductsResponse {
  bool? isSuccess;
  String? message;
  int? cartProduct;
  List<GetProductsInfoModel>? info;

  GetProductsResponse(
      {this.isSuccess, this.message, this.cartProduct, this.info});

  GetProductsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProduct = json['cart_product'];
    if (json['info'] != null) {
      info = <GetProductsInfoModel>[];
      json['info'].forEach((v) {
        info!.add(new GetProductsInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['cart_product'] = this.cartProduct;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
