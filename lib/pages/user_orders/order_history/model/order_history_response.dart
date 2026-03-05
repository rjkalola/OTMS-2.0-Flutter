import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';

class OrderHistoryResponse {
  final bool? isSuccess;
  final String? message;
  final List<OrderInfo>? info;

  OrderHistoryResponse({
    this.isSuccess,
    this.message,
    this.info,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      isSuccess: json['IsSuccess'],
      message: json['message'],
      info: json['info'] != null
          ? List<OrderInfo>.from(
          json['info'].map((x) => OrderInfo.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "IsSuccess": isSuccess,
      "message": message,
      "info": info?.map((x) => x.toJson()).toList(),
    };
  }
}