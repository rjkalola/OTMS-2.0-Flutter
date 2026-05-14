class TeamMemberListResponse {
  bool? isSuccess;
  String? message;
  List<TeamMemberListItemInfo>? info;
  int? activeCompanyId;

  TeamMemberListResponse(
      {this.isSuccess, this.message, this.info, this.activeCompanyId});

  TeamMemberListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    activeCompanyId = json['active_company_id'];
    if (json['info'] != null) {
      info = <TeamMemberListItemInfo>[];
      json['info'].forEach((v) {
        info!.add(TeamMemberListItemInfo.fromJson(v));
      });
    }
  }
}

class TeamMemberListItemInfo {
  int? teamId;
  String? name;
  int? teamMemberCount;
  List<TeamMemberUserInfo>? users;

  TeamMemberListItemInfo(
      {this.teamId, this.name, this.teamMemberCount, this.users});

  TeamMemberListItemInfo.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    name = json['name'];
    teamMemberCount = json['team_member_count'];
    if (json['users'] != null) {
      users = <TeamMemberUserInfo>[];
      json['users'].forEach((v) {
        users!.add(TeamMemberUserInfo.fromJson(v));
      });
    }
  }
}

class TeamMemberUserInfo {
  int? id;
  String? name;
  String? image;
  bool? isShowStore;

  TeamMemberUserInfo({this.id, this.name, this.image, this.isShowStore});

  TeamMemberUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isShowStore = json['is_show_store'];
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'is_show_store': isShowStore == true,
    };
  }
}
