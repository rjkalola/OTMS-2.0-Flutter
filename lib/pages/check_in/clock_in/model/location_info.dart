class LocationInfo {
  String? latitude;
  String? longitude;
  String? location;

  LocationInfo({this.latitude, this.longitude, this.location});

  LocationInfo.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    return data;
  }
}
