import 'package:otm_inventory/pages/teams/team_list/model/team_info.dart';

class TeamListResponse {
  bool? isSuccess;
  String? message;
  List<TeamInfo>? info;

  TeamListResponse({this.isSuccess, this.message, this.info});

  TeamListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <TeamInfo>[];
      json['info'].forEach((v) {
        info!.add(new TeamInfo.fromJson(v));
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
