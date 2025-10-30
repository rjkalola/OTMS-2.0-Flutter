class GeofenceInfo {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  double? radius;
  String? type;
  String? color;
  List<GeofenceCoordinates>? coordinates;

  GeofenceInfo(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.radius,
      this.type,
      this.color,
      this.coordinates});

  GeofenceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    // radius = json['radius'];
    radius = (json['radius'] is int)
        ? (json['radius'] as int).toDouble()
        : (json['radius'] is double)
        ? json['radius'] as double
        : 0.0;
    type = json['type'];
    color = json['color'];
    if (json['coordinates'] != null) {
      coordinates = <GeofenceCoordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(new GeofenceCoordinates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['type'] = this.type;
    data['color'] = this.color;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeofenceCoordinates {
  double? lat;
  double? lng;

  GeofenceCoordinates({this.lat, this.lng});

  GeofenceCoordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
