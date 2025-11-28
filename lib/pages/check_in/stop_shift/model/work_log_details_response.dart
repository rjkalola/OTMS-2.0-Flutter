import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/work_log_request/model/work_log_details_info.dart';

class WorkLogDetailsResponse {
  bool? isSuccess;
  String? message;
  WorkLogInfo? info;
  String? currency;

  WorkLogDetailsResponse(
      {this.isSuccess, this.message, this.info, this.currency});

  WorkLogDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? WorkLogInfo.fromJson(json['info']) : null;
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    data['message'] = this.message;
    data['currency'] = this.currency;
    return data;
  }
}
