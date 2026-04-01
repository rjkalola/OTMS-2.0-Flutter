import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';

/// Response for [ApiConstants.hireOrdersUpdateStatus] (same shape as buyer deliver flow).
class HireOrderUpdateStatusResponse {
  bool? isSuccess;
  String? message;
  HireOrderInfo? info;

  HireOrderUpdateStatusResponse({this.isSuccess, this.message, this.info});

  HireOrderUpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? HireOrderInfo.fromJson(json['info'] as Map<String, dynamic>)
        : null;
  }
}
