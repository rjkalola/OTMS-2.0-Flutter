import 'package:belcka/pages/user_orders/hire_module/user_hire_products/model/hire_order_info.dart';

class HireOrdersListResponse {
  bool? isSuccess;
  String? message;
  int? all;
  int? requested;
  int? hired;
  int? serviced;
  int? returned;
  int? canceled;
  int? available;
  List<HireOrderInfo>? info;

  HireOrdersListResponse({
    this.isSuccess,
    this.message,
    this.all,
    this.requested,
    this.hired,
    this.serviced,
    this.returned,
    this.canceled,
    this.available,
    this.info,
  });

  HireOrdersListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    all = json['all'];
    requested = json['requested'];
    hired = json['hired'];
    serviced = json['serviced'];
    returned = json['returned'];
    canceled = json['canceled'];
    available = json['available'];
    if (json['info'] != null) {
      info = <HireOrderInfo>[];
      for (final v in json['info'] as List) {
        info!.add(HireOrderInfo.fromJson(v as Map<String, dynamic>));
      }
    } 
  }
}
