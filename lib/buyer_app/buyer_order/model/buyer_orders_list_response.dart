import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class BuyerOrdersListResponse {
  bool? isSuccess;
  String? message;
  List<OrderInfo>? info;
  String? startDate, endDate;
  int? upcoming, processing, delivered;
  int? newOrders, preparing, ready, collected;

  BuyerOrdersListResponse(
      {this.isSuccess,
      this.message,
      this.info,
      this.startDate,
      this.endDate,
      this.upcoming,
      this.processing,
      this.delivered,
      this.newOrders,
      this.preparing,
      this.ready,
      this.collected});

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
    upcoming = json['upcoming'];
    processing = json['processing'];
    delivered = json['delivered'];
    newOrders = json['new'];
    preparing = json['preparing'];
    ready = json['ready'];
    collected = json['collected'];
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
    data['upcoming'] = this.upcoming;
    data['processing'] = this.processing;
    data['delivered'] = this.delivered;
    data['new'] = this.newOrders;
    data['preparing'] = this.preparing;
    data['ready'] = this.ready;
    data['collected'] = this.collected;
    return data;
  }
}
