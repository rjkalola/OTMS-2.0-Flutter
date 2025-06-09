import 'package:otm_inventory/pages/common/model/user_info.dart';

class TeamInfo {
  int? id;
  String? name;
  int? supervisorId;
  String? supervisorName;
  String? supervisorTrade;
  String? supervisorPhoneWithExtension;
  String? supervisorImageName;
  String? supervisorImage;
  String? supervisorThumbImage;
  List<UserInfo>? teamMembers;

  TeamInfo(
      {this.id,
      this.name,
      this.supervisorId,
      this.supervisorName,
      this.supervisorTrade,
      this.supervisorPhoneWithExtension,
      this.supervisorImageName,
      this.supervisorImage,
      this.supervisorThumbImage,
      this.teamMembers});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    supervisorId = json['supervisor_id'];
    supervisorName = json['supervisor_name'];
    supervisorTrade = json['supervisor_trade'];
    supervisorImageName = json['supervisor_image_name'];
    supervisorPhoneWithExtension = json['supervisor_phone_with_extension'];
    supervisorImage = json['supervisor_image'];
    supervisorThumbImage = json['supervisor_thumb_image'];
    if (json['team_members'] != null) {
      teamMembers = <UserInfo>[];
      json['team_members'].forEach((v) {
        teamMembers!.add(new UserInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['supervisor_id'] = this.supervisorId;
    data['supervisor_name'] = this.supervisorName;
    data['supervisor_trade'] = this.supervisorTrade;
    data['supervisor_phone_with_extension'] = this.supervisorPhoneWithExtension;
    data['supervisor_image_name'] = this.supervisorImageName;
    data['supervisor_image'] = this.supervisorImage;
    data['supervisor_thumb_image'] = this.supervisorThumbImage;
    if (this.teamMembers != null) {
      data['team_members'] = this.teamMembers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
