import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';

class BuyerOrderDetailDeliverResponse {
  bool? isSuccess;
  String? message;
  OrderInfo? info;
  int? status;

  BuyerOrderDetailDeliverResponse(
      {this.isSuccess, this.message, this.info, this.status});

  BuyerOrderDetailDeliverResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? OrderInfo.fromJson(json['info']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['message'] = message;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    data['status'] = status;
    return data;
  }
}
