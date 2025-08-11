import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';

class CheckLogDetailsResponse {
  bool? isSuccess;
  String? message;
  int? totalProgress;
  CheckLogInfo? info;

  CheckLogDetailsResponse(
      {this.isSuccess, this.message, this.totalProgress, this.info});

  CheckLogDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    totalProgress = json['total_progress'];
    info =
        json['info'] != null ? new CheckLogInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['total_progress'] = this.totalProgress;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
