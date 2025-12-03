import 'package:belcka/pages/project/project_info/model/geofence_info.dart';

class CheckOutsideBoundaryResponse {
  bool? isSuccess;
  String? message;
  bool? outSideBoundary;
  List<GeofenceInfo>? geofences;

  CheckOutsideBoundaryResponse({
    this.isSuccess,
    this.message,
    this.outSideBoundary,
    this.geofences,
  });

  CheckOutsideBoundaryResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    outSideBoundary = json['outside_boundary'];
    if (json['geofences'] != null) {
      geofences = <GeofenceInfo>[];
      json['geofences'].forEach((v) {
        geofences!.add(new GeofenceInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['outside_boundary'] = this.outSideBoundary;
    if (this.geofences != null) {
      data['geofences'] = this.geofences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
