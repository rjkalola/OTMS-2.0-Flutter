import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';

class CheckLogListResponse {
  bool? isSuccess;
  String? message;
  List<CheckLogInfo>? info;

  CheckLogListResponse({this.isSuccess, this.message, this.info});

  CheckLogListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
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
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
