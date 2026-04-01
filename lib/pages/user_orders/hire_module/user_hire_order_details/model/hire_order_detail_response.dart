import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';

class HireOrderDetailResponse {
  bool? isSuccess;
  String? message;
  HireOrderInfo? info;

  HireOrderDetailResponse({this.isSuccess, this.message, this.info});

  HireOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = HireOrderInfo.fromJson(json['info'] as Map<String, dynamic>);
    }
  }
}
