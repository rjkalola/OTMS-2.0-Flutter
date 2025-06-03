class TeamInfo {
  int? id;
  String? name;
  int? teamMemberCount;
  String? supervisorName;
  String? supervisorImageName;
  String? supervisorImage;
  String? supervisorThumbImage;
  String? companyOtp;

  TeamInfo(
      {this.id,
      this.name,
      this.teamMemberCount,
      this.supervisorName,
      this.supervisorImageName,
      this.supervisorImage,
      this.supervisorThumbImage,
      this.companyOtp});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    teamMemberCount = json['team_member_count'];
    supervisorName = json['supervisor_name'];
    supervisorImageName = json['supervisor_image_name'];
    supervisorImage = json['supervisor_image'];
    supervisorThumbImage = json['supervisor_thumb_image'];
    companyOtp = json['company_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['team_member_count'] = this.teamMemberCount;
    data['supervisor_name'] = this.supervisorName;
    data['supervisor_image_name'] = this.supervisorImageName;
    data['supervisor_image'] = this.supervisorImage;
    data['supervisor_thumb_image'] = this.supervisorThumbImage;
    data['company_otp'] = this.companyOtp;
    return data;
  }
}
