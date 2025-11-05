import 'package:belcka/pages/project/address_list/model/address_info.dart';

class AddressListResponse {
  bool? isSuccess;
  String? message;
  int? all;
  int? latest;
  int? pending;
  int? completed;
  List<AddressInfo>? info;

  AddressListResponse(
      {this.isSuccess,
      this.message,
      this.all,
      this.latest,
      this.pending,
      this.completed,
      this.info});

  AddressListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    all = json['all'];
    latest = json['new'];
    pending = json['pending'];
    completed = json['completed'];
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
    data['all'] = this.all;
    data['new'] = this.latest;
    data['pending'] = this.pending;
    data['completed'] = this.completed;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
