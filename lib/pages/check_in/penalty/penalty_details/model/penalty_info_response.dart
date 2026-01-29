import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';

class PenaltyInfoResponse {
  bool? isSuccess;
  String? message;
  String? worklogDate;
  String? worklogDay;
  PenaltyInfo? info;

  PenaltyInfoResponse(
      {this.isSuccess,
      this.message,
      this.worklogDate,
      this.worklogDay,
      this.info});

  PenaltyInfoResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    worklogDate = json['worklog_date'];
    worklogDay = json['worklog_day'];
    info = json['info'] != null ? PenaltyInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['worklog_date'] = this.worklogDate;
    data['worklog_day'] = this.worklogDay;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
