import 'package:belcka/pages/common/model/user_info.dart';

class TeamInfo {
  int? id;
  String? name;
  int? maxMembers;
  int? supervisorId;
  int? teamMemberCount;
  String? supervisorName;
  String? supervisorTrade;
  String? supervisorPhoneWithExtension;
  String? supervisorImageName;
  String? supervisorImage;
  String? supervisorThumbImage;
  bool? isSubcontractor;
  String? subcontractorCompanyName;
  int? subcontractorCompanyId;
  bool? isCheckIn;
  List<UserInfo>? teamMembers;
  List<TradeMaxLimit>? tradeMaxLimits;

  TeamInfo(
      {this.id,
      this.name,
      this.maxMembers,
      this.supervisorId,
      this.teamMemberCount,
      this.supervisorName,
      this.supervisorTrade,
      this.supervisorPhoneWithExtension,
      this.supervisorImageName,
      this.supervisorImage,
      this.supervisorThumbImage,
      this.teamMembers,
      this.isSubcontractor,
      this.subcontractorCompanyName,
      this.subcontractorCompanyId,
      this.isCheckIn,
      this.tradeMaxLimits});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maxMembers = json['max_members'];
    supervisorId = json['supervisor_id'];
    teamMemberCount = json['team_member_count'];
    supervisorName = json['supervisor_name'];
    supervisorTrade = json['supervisor_trade'];
    supervisorImageName = json['supervisor_image_name'];
    supervisorPhoneWithExtension = json['supervisor_phone_with_extension'];
    supervisorImage = json['supervisor_image'];
    supervisorThumbImage = json['supervisor_thumb_image'];
    isSubcontractor = json['is_subcontractor'];
    subcontractorCompanyName = json['subcontractor_company_name'];
    subcontractorCompanyId = json['subcontractor_company_id'];
    isCheckIn = json['is_check_in'];

    if (json['team_members'] != null) {
      teamMembers = <UserInfo>[];
      json['team_members'].forEach((v) {
        teamMembers!.add(new UserInfo.fromJson(v));
      });
    }

    if (json['trade_max_limits'] != null) {
      tradeMaxLimits = <TradeMaxLimit>[];
      json['trade_max_limits'].forEach((v) {
        tradeMaxLimits!.add(new TradeMaxLimit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['max_members'] = this.maxMembers;
    data['supervisor_id'] = this.supervisorId;
    data['team_member_count'] = this.teamMemberCount;
    data['supervisor_name'] = this.supervisorName;
    data['supervisor_trade'] = this.supervisorTrade;
    data['supervisor_phone_with_extension'] = this.supervisorPhoneWithExtension;
    data['supervisor_image_name'] = this.supervisorImageName;
    data['supervisor_image'] = this.supervisorImage;
    data['supervisor_thumb_image'] = this.supervisorThumbImage;
    data['is_subcontractor'] = this.isSubcontractor;
    data['subcontractor_company_name'] = this.subcontractorCompanyName;
    data['subcontractor_company_id'] = this.subcontractorCompanyId;
    data['is_check_in'] = this.isCheckIn;

    if (this.teamMembers != null) {
      data['team_members'] = this.teamMembers!.map((v) => v.toJson()).toList();
    }

    if (this.tradeMaxLimits != null) {
      data['trade_max_limits'] =
          this.tradeMaxLimits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TradeMaxLimit {
  int? tradeId;
  String? tradeName;
  int? maxMembers;

  TradeMaxLimit({this.tradeId, this.tradeName, this.maxMembers});

  TradeMaxLimit.fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    maxMembers = json['max_members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['max_members'] = this.maxMembers;
    return data;
  }
}
