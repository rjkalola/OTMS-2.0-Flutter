import 'package:belcka/pages/user_orders/order_details/model/order_details_info.dart';

class OrderDetailsResponse {
  bool? isSuccess;
  String? message;
  List<OrderDetailsInfo>? info;

  OrderDetailsResponse({this.isSuccess, this.message, this.info});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <OrderDetailsInfo>[];
      json['info'].forEach((v) {
        info!.add(OrderDetailsInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['IsSuccess'] = isSuccess;
    data['message'] = message;
    if (info != null) {
      data['info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}