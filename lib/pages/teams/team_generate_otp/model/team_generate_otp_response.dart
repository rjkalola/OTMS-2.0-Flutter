import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';

class TeamGenerateOtpResponse {
  bool? isSuccess;
  String? message;
  TeamInfo? info;

  TeamGenerateOtpResponse({this.isSuccess, this.message, this.info});

  TeamGenerateOtpResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? TeamInfo.fromJson(json['info']) : null;
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
