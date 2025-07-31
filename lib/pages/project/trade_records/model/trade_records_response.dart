import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';

class TradeRecordsResponse {
  bool? isSuccess;
  String? message;
  int? addressId;
  String? addressName;
  int? projectId;
  String? projectName;
  String? weekStartDate;
  String? weekEndDate;
  List<CheckLogInfo>? info;

  TradeRecordsResponse(
      {this.isSuccess,
      this.message,
      this.addressId,
      this.addressName,
      this.projectId,
      this.projectName,
      this.weekStartDate,
      this.weekEndDate,
      this.info});

  TradeRecordsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    weekStartDate = json['week_start_date'];
    weekEndDate = json['week_end_date'];
    if (json['info'] != null) {
      info = <CheckLogInfo>[];
      json['info'].forEach((v) {
        info!.add(new CheckLogInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['project_id'] = this.projectId;
    data['project_name'] = this.projectName;
    data['week_start_date'] = this.weekStartDate;
    data['week_end_date'] = this.weekEndDate;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
