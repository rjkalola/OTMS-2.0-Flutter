import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';

class BuyerProceedOrderListResponse {
  bool? isSuccess;
  String? message;
  List<OrderInfo>? info;

  BuyerProceedOrderListResponse({this.isSuccess, this.message, this.info});

  BuyerProceedOrderListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <OrderInfo>[];
      json['info'].forEach((v) {
        info!.add(new OrderInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
