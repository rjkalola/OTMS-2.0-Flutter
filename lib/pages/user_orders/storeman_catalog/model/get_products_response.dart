import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class GetProductsResponse {
  bool? isSuccess;
  String? message;
  int? cartProduct;
  List<ProductInfo>? info;
  PaginationData? pagination;

  GetProductsResponse({
    this.isSuccess,
    this.message,
    this.cartProduct,
    this.info,
    this.pagination,
  });

  GetProductsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProduct = json['cart_product'];
    if (json['info'] != null) {
      info = <ProductInfo>[];
      json['info'].forEach((v) {
        info!.add(new ProductInfo.fromJson(v));
      });
    }
    pagination =
        json['data'] != null ? PaginationData.fromJson(json['data']) : null;
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
