import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class TeamListResponse {
  bool? isSuccess;
  String? message;
  List<TeamInfo>? info;
  PaginationData? pagination;

  TeamListResponse({this.isSuccess, this.message, this.info,this.pagination});

  TeamListResponse.fromJson(Map<String, dynamic> json) {

    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <TeamInfo>[];
      json['info'].forEach((v) {
        info!.add(new TeamInfo.fromJson(v));
      });
    }
    pagination=  json['data'] != null ? PaginationData.fromJson(json['data']) : null;
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
