import 'package:otm_inventory/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:otm_inventory/pages/check_in/work_log_request/model/work_log_details_info.dart';

class WorkLogRequestDetailsResponse {
  bool? isSuccess;
  String? message;
  WorkLogDetailsInfo? info;

  WorkLogRequestDetailsResponse({this.isSuccess, this.message, this.info});

  WorkLogRequestDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? WorkLogDetailsInfo.fromJson(json['info']) : null;
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
