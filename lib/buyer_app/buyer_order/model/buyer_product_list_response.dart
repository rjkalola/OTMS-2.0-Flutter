import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';

class BuyerProductListResponse {
  bool? isSuccess;
  String? message;
  List<ProductInfo>? info;
  int? requested;
  int? upcoming;
  int? processing;
  int? delivered;
  int? partiallyDelivered;
  int? cancelled;

  BuyerProductListResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.requested,
    this.upcoming,
    this.processing,
    this.delivered,
    this.partiallyDelivered,
    this.cancelled,
  });

  BuyerProductListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    requested = (json['requested'] as num?)?.toInt();
    upcoming = (json['upcoming'] as num?)?.toInt();
    processing = (json['processing'] as num?)?.toInt();
    delivered = (json['delivered'] as num?)?.toInt();
    partiallyDelivered =
        (json['partially_delivered'] as num?)?.toInt();
    cancelled = (json['cancelled'] as num?)?.toInt();
    if (json['info'] != null) {
      info = <ProductInfo>[];
      json['info'].forEach((v) {
        info!.add(new ProductInfo.fromJson(v));
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
    data['requested'] = this.requested;
    data['upcoming'] = this.upcoming;
    data['processing'] = this.processing;
    data['delivered'] = this.delivered;
    data['partially_delivered'] = this.partiallyDelivered;
    data['cancelled'] = this.cancelled;
    return data;
  }
}
