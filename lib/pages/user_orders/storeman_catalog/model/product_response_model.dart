import 'package:belcka/pages/user_orders/storeman_catalog/model/product_categories.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductResponseModel {
  final bool isSuccess;
  final String message;
  final int cartProduct;
  final List<ProductCategories> info;

  ProductResponseModel({
    required this.isSuccess,
    required this.message,
    required this.cartProduct,
    required this.info,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      cartProduct: json['cart_product'] ?? 0,
      info: (json['info'] as List?)
          ?.map((e) => ProductCategories.fromJson(e))
          .toList() ??
          [],
    );
  }
}
