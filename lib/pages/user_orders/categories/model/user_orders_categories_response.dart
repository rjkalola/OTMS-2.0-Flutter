import 'package:belcka/pages/user_orders/categories/model/user_orders_categories_info.dart';

class UserOrdersCategoriesResponse {
  bool? isSuccess;
  String? message;
  int? cartProductCount;
  List<UserOrdersCategoriesInfo>? info;

  UserOrdersCategoriesResponse(
      {this.isSuccess, this.message, this.cartProductCount, this.info});

  UserOrdersCategoriesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProductCount = json['cart_product_count'];
    if (json['info'] != null) {
      info = <UserOrdersCategoriesInfo>[];
      json['info'].forEach((v) {
        info!.add(new UserOrdersCategoriesInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['cart_product_count'] = this.cartProductCount;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

