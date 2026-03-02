import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';

class BuyerOrderDetailsResponse {
  bool? isSuccess;
  String? message;
  OrderInfo? info;

  BuyerOrderDetailsResponse({this.isSuccess, this.message, this.info});

  BuyerOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? OrderInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
