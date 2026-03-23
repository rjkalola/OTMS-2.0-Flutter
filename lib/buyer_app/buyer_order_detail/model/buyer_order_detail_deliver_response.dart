import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';

/// Response for proceed/cancel flows (copied from storeman order details model).
class BuyerOrderDetailDeliverResponse {
  bool? isSuccess;
  String? message;
  OrderInfo? info;

  BuyerOrderDetailDeliverResponse({this.isSuccess, this.message, this.info});

  BuyerOrderDetailDeliverResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? OrderInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['message'] = message;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}
