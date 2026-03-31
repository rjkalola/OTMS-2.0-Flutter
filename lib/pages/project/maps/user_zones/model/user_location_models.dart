class UserLocationInfo {
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? userCode;
  String? userImage;
  String? userThumbImage;
  bool? isWorking;
  int? supervisorId;
  String? supervisorName;
  int? teamId;
  String? teamName;
  int? tradeId;
  String? tradeName;
  double? latitude;
  double? longitude;
  String? location;
  String? lastSeen;
  String? type;
  String? phone;
  String? extension;
  String? email;

  UserLocationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userName = json['user_name'];
    userCode = json['user_code'];
    userImage = json['user_image'];
    userThumbImage = json['user_thumb_image'];
    isWorking = json['is_working'];
    supervisorId = json['supervisor_id'];
    supervisorName = json['supervisor_name'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    latitude = double.tryParse((json['latitude'] ?? '').toString());
    longitude = double.tryParse((json['longitude'] ?? '').toString());
    location = json['location'];
    lastSeen = json['last_seen'];
    type = json['type'];
    phone = json['phone']?.toString() ?? json['phone_number']?.toString();
    extension =
        json['extension']?.toString() ?? json['phone_extension']?.toString();
    email = json['email']?.toString();
  }
}

class TeamUserLocationsGroup {
  int? teamId;
  String? teamName;
  List<UserLocationInfo> users;

  TeamUserLocationsGroup({
    this.teamId,
    this.teamName,
    this.users = const [],
  });

  TeamUserLocationsGroup.fromJson(Map<String, dynamic> json)
      : teamId = json['team_id'],
        teamName = json['team_name'],
        users = <UserLocationInfo>[] {
    if (json['users'] != null) {
      for (final e in json['users'] as List) {
        users.add(UserLocationInfo.fromJson(e as Map<String, dynamic>));
      }
    }
  }
}

class UserLocationsResponse {
  bool? isSuccess;
  String? message;
  List<TeamUserLocationsGroup>? info;

  UserLocationsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <TeamUserLocationsGroup>[];
      for (final v in json['info'] as List) {
        info!.add(TeamUserLocationsGroup.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

class TeamUsersGroup {
  String name;
  List<UserLocationInfo> users;

  TeamUsersGroup({required this.name, required this.users});
}
