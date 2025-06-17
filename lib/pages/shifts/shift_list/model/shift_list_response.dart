import 'package:otm_inventory/pages/shifts/create_shift/model/shift_info.dart';

class ShiftListResponse {
  bool? isSuccess;
  String? message;
  List<ShiftInfo>? info;

  ShiftListResponse({this.isSuccess, this.message, this.info});

  ShiftListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <ShiftInfo>[];
      json['info'].forEach((v) {
        info!.add(new ShiftInfo.fromJson(v));
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
