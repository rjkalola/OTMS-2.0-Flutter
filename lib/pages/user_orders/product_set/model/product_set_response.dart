import 'package:belcka/pages/user_orders/product_set/model/product_set_info.dart';

class ProductSetResponse {
  final bool isSuccess;
  final String message;
  final List<ProductSetInfo> info;

  ProductSetResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory ProductSetResponse.fromJson(Map<String, dynamic> json) {
    return ProductSetResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: (json['info'] as List<dynamic>? ?? [])
          .map((e) => ProductSetInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsSuccess': isSuccess,
      'message': message,
      'info': info.map((e) => e.toJson()).toList(),
    };
  }
}