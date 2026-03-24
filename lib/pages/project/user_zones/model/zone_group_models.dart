class UserZoneCoordinate {
  double? lat;
  double? lng;

  UserZoneCoordinate({this.lat, this.lng});

  UserZoneCoordinate.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
  }
}

class UserZoneInfo {
  int? id;
  String? name;
  int? projectId;
  String? projectName;
  double? latitude;
  double? longitude;
  String? type;
  String? color;
  List<UserZoneCoordinate>? coordinates;
  double? radius;

  UserZoneInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    type = json['type']?.toString();
    color = json['color']?.toString();
    radius = (json['radius'] as num?)?.toDouble();

    if (json['coordinates'] is List) {
      coordinates = (json['coordinates'] as List)
          .whereType<Map>()
          .map((e) => UserZoneCoordinate.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }
}

class UserZoneGroupInfo {
  int? id;
  String? name;
  int? companyId;
  bool? isUnassigned;
  List<UserZoneInfo>? zones;

  UserZoneGroupInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    isUnassigned = json['is_unassigned'];
    if (json['zones'] != null) {
      zones = <UserZoneInfo>[];
      for (final v in json['zones']) {
        zones!.add(UserZoneInfo.fromJson(v));
      }
    }
  }
}

class UserZoneGroupsResponse {
  bool? isSuccess;
  String? message;
  List<UserZoneGroupInfo>? info;

  UserZoneGroupsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <UserZoneGroupInfo>[];
      for (final v in json['info']) {
        info!.add(UserZoneGroupInfo.fromJson(v));
      }
    }
  }
}
