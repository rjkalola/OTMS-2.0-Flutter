import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class BuyerOrdersListResponse {
  bool? isSuccess;
  String? message;
  List<OrderInfo>? info;

  BuyerOrdersListResponse({this.isSuccess, this.message, this.info});

  BuyerOrdersListResponse.fromJson(Map<String, dynamic> json) {
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
