import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

/// Response for [ApiConstants.hireOrdersGetProducts] (hire lines as [ProductInfo]).
class HireProductsListResponse {
  bool? isSuccess;
  String? message;
  int? all;
  int? requested;
  int? hired;
  int? serviced;
  int? damaged;
  int? canceled;
  int? available;
  List<ProductInfo>? info;

  HireProductsListResponse({
    this.isSuccess,
    this.message,
    this.all,
    this.requested,
    this.hired,
    this.serviced,
    this.damaged,
    this.canceled,
    this.available,
    this.info,
  });

  HireProductsListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    all = json['all'];
    requested = json['requested'];
    hired = json['hired'];
    serviced = json['serviced'];
    damaged = json['damaged'];
    canceled = json['canceled'];
    available = json['available'];
    if (json['info'] != null) {
      info = <ProductInfo>[];
      for (final v in json['info'] as List) {
        info!.add(ProductInfo.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}
