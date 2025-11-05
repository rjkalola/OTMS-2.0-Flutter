import 'package:belcka/pages/project/address_list/model/address_info.dart';

class AddressDetailsResponse {
  bool? isSuccess;
  String? message;
  AddressInfo? info;

  AddressDetailsResponse({this.isSuccess, this.message, this.info});

  AddressDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? new AddressInfo.fromJson(json['info'])
        : null;
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
