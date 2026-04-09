class LocationInfo {
  String? latitude;
  String? longitude;
  String? location;
  double? radius;

  LocationInfo({this.latitude, this.longitude, this.location, this.radius});

  LocationInfo.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    // radius = json['radius'];
    radius = (json['radius'] is int)
        ? (json['radius'] as int).toDouble()
        : (json['radius'] is double)
            ? json['radius'] as double
            : 0.0;
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
