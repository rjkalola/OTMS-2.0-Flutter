import 'package:belcka/buyer_app/categories/catalogue_list/model/category_info.dart';

class CategoryListResponse {
  bool? isSuccess;
  String? message;
  int? cartProductCount;
  List<CategoryInfo>? info;

  CategoryListResponse(
      {this.isSuccess, this.message, this.cartProductCount, this.info});

  CategoryListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    cartProductCount = json['cart_product_count'];
    if (json['info'] != null) {
      info = <CategoryInfo>[];
      json['info'].forEach((v) {
        info!.add(new CategoryInfo.fromJson(v));
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
