class LocationInfo {
  String? latitude;
  String? longitude;
  String? location;
  int? radius;

  LocationInfo({this.latitude, this.longitude, this.location, this.radius});

  LocationInfo.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    data['radius'] = this.radius;
    return data;
  }
}
