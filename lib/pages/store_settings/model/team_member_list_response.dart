import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class TeamMemberListResponse {
  bool? isSuccess;
  String? message;
  List<TeamMemberListItemInfo>? info;
  int? activeCompanyId;
  PaginationData? pagination;

  TeamMemberListResponse(
      {this.isSuccess, this.message, this.info, this.activeCompanyId, this.pagination});

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
    pagination=  json['data'] != null ? PaginationData.fromJson(json['data']) : null;
  }
}

class TeamMemberListItemInfo {
  int? teamId;
  String? name;
  int? teamMemberCount;
  int? workingMemberCount;
  int? maxMembers;
  List<TeamMemberUserInfo>? users;

  TeamMemberListItemInfo(
      {this.teamId,
      this.name,
      this.teamMemberCount,
      this.workingMemberCount,
      this.maxMembers,
      this.users});

  TeamMemberListItemInfo.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    name = json['name'];
    teamMemberCount = json['team_member_count'];
    workingMemberCount = json['working_member_count'];
    maxMembers = json['max_members'];
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
  int? teamId;
  int? projectId;
  int? tradeId;
  int? checkIns;
  String? name;
  String? image;
  String? teamName;
  String? projectName;
  String? tradeName;
  String? statusColor;
  String? lastWorkedDate;
  String? lastWorkedTime;
  bool? isShowStore;
  bool? isActive;
  bool? isWorking;
  bool? isOnBreak;
  dynamic currentBreak;

  TeamMemberUserInfo({
    this.id,
    this.teamId,
    this.projectId,
    this.tradeId,
    this.checkIns,
    this.name,
    this.image,
    this.teamName,
    this.projectName,
    this.tradeName,
    this.statusColor,
    this.lastWorkedDate,
    this.lastWorkedTime,
    this.isShowStore,
    this.isActive,
    this.isWorking,
    this.isOnBreak,
    this.currentBreak,
  });

  TeamMemberUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    projectId = json['project_id'];
    tradeId = json['trade_id'];
    checkIns = json['check_ins'];
    name = json['name'];
    image = json['image'];
    teamName = json['team_name'];
    projectName = json['project_name'];
    tradeName = json['trade_name'];
    statusColor = json['status_color'];
    lastWorkedDate = json['last_worked_date'];
    lastWorkedTime = json['last_worked_time'];
    isShowStore = json['is_show_store'];
    isActive = json['is_active'];
    isWorking = json['is_working'];
    isOnBreak = json['is_on_break'];
    currentBreak = json['current_break'];
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'is_show_store': isShowStore == true,
    };
  }
}
