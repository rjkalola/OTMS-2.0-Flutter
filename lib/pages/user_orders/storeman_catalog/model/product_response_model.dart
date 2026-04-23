import 'package:belcka/pages/user_orders/storeman_catalog/model/product_categories.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductResponseModel {
  final bool isSuccess;
  final String message;
  final int cartProduct;
  final List<ProductCategories> info;
  final PaginationData? pagination;

  ProductResponseModel({
    required this.isSuccess,
    required this.message,
    required this.cartProduct,
    required this.info,
    this.pagination,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      cartProduct: json['cart_product'] ?? 0,
      info: (json['info'] as List?)?.map((e) => ProductCategories.fromJson(e)).toList() ?? [],
      pagination: json['data'] != null ? PaginationData.fromJson(json['data']) : null,
    );
  }
}

class PaginationData {
  final int totalItems;
  final int currentPage;
  final int totalPages;

  PaginationData({required this.totalItems, required this.currentPage, required this.totalPages});

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      totalItems: json['totalItems'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

