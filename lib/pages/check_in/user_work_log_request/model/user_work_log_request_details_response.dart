import 'package:belcka/pages/check_in/user_work_log_request/model/user_work_log_details_info.dart';

class UserWorkLogRequestDetailsResponse {
  bool? isSuccess;
  String? message;
  UserWorkLogDetailsInfo? info;

  UserWorkLogRequestDetailsResponse({this.isSuccess, this.message, this.info});

  UserWorkLogRequestDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? UserWorkLogDetailsInfo.fromJson(json['info']) : null;
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
