import 'package:belcka/pages/user_orders/basket/model/product_cart_list_info.dart';

class ProductCartListResponse {
  bool? isSuccess;
  String? message;
  List<ProductCartListInfo>? info;

  ProductCartListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];

    if (json['info'] is List) {
      info = (json['info'] as List)
          .map((v) => ProductCartListInfo.fromJson(v))
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
