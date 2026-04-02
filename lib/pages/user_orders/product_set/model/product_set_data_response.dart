import 'package:belcka/pages/user_orders/product_set/model/product_set_data_info.dart';

class ProductSetDataResponse {
  final bool isSuccess;
  final String message;
  final List<ProductSetDataInfo> info;

  ProductSetDataResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory ProductSetDataResponse.fromJson(Map<String, dynamic> json) {
    return ProductSetDataResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => ProductSetDataInfo.fromJson(e))
          .toList() ??
          [],
    );
  }
}