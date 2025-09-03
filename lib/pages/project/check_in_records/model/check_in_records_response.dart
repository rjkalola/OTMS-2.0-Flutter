import 'package:belcka/pages/project/check_in_records/model/check_in_records_info.dart';

class CheckInRecordsResponse {
  bool? isSuccess;
  String? message;
  int? addressId;
  String? addressName;
  int? projectId;
  String? projectName;
  List<CheckInRecordsInfo>? info;

  CheckInRecordsResponse(
      {this.isSuccess,
      this.message,
      this.addressId,
      this.addressName,
      this.projectId,
      this.projectName,
      this.info});

  CheckInRecordsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    if (json['info'] != null) {
      info = <CheckInRecordsInfo>[];
      json['info'].forEach((v) {
        info!.add(new CheckInRecordsInfo.fromJson(v));
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
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
