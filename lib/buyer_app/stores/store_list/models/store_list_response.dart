import 'package:belcka/buyer_app/stores/store_list/models/store_info.dart';

class StoreListResponse {
  bool? isSuccess;
  String? message;
  List<StoreInfo>? info;

  StoreListResponse({this.isSuccess, this.message, this.info});

  StoreListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <StoreInfo>[];
      json['info'].forEach((v) {
        info!.add(new StoreInfo.fromJson(v));
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


