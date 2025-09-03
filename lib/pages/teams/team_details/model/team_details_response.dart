import 'package:belcka/pages/teams/team_list/model/team_info.dart';

class TeamDetailsResponse {
  bool? isSuccess;
  String? message;
  TeamInfo? info;

  TeamDetailsResponse({this.isSuccess, this.message, this.info});

  TeamDetailsResponse.fromJson(Map<String, dynamic> json) {
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
