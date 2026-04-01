import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductCategories {
  final int categoryId;
  final String categoryName;
  final List<ProductInfo> products;

  ProductCategories({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });

  factory ProductCategories.fromJson(Map<String, dynamic> json) {
    return ProductCategories(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      products: (json['products'] as List?)
          ?.map((e) => ProductInfo.fromJson(e))
          .toList() ??
          [],
    );
  }

  // copyWith added
  ProductCategories copyWith({
    int? categoryId,
    String? categoryName,
    List<ProductInfo>? products,
  }) {
    return ProductCategories(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      products: products ?? this.products,
    );
  }
}