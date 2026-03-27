import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class ProductSetInfo {
  final int id;
  final int companyId;
  final String name;
  final int items;
  final String currency;
  final List<ProductInfo> products;

  ProductSetInfo({
    required this.id,
    required this.companyId,
    required this.name,
    required this.items,
    required this.currency,
    required this.products,
  });

  factory ProductSetInfo.fromJson(Map<String, dynamic> json) {
    return ProductSetInfo(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      name: json['name'] ?? '',
      items: json['items'] ?? 0,
      currency: json['currency'] ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => ProductInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'items': items,
      'currency': currency,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}