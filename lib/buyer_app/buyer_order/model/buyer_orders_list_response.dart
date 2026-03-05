import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class BuyerOrdersListResponse {
  bool? isSuccess;
  String? message;
  List<OrderInfo>? info;
  String? startDate, endDate;

  BuyerOrdersListResponse(
      {this.isSuccess, this.message, this.info, this.startDate, this.endDate});

  BuyerOrdersListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <OrderInfo>[];
      json['info'].forEach((v) {
        info!.add(new OrderInfo.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
