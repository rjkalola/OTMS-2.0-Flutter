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
  }
}

class UserLocationsResponse {
  bool? isSuccess;
  String? message;
  List<UserLocationInfo>? info;

  UserLocationsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <UserLocationInfo>[];
      for (final v in json['info']) {
        info!.add(UserLocationInfo.fromJson(v));
      }
    }
  }
}

class TeamUsersGroup {
  String name;
  List<UserLocationInfo> users;

  TeamUsersGroup({required this.name, required this.users});
}
