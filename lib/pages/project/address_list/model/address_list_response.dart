import 'package:belcka/pages/project/address_list/model/address_info.dart';

class AddressListResponse {
  bool? isSuccess;
  String? message;
  List<AddressInfo>? info;

  AddressListResponse({this.isSuccess, this.message, this.info});

  AddressListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <AddressInfo>[];
      json['info'].forEach((v) {
        info!.add(new AddressInfo.fromJson(v));
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
