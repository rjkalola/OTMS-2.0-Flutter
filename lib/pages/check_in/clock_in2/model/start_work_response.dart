import 'package:otm_inventory/pages/check_in/clock_in2/model/shift_location_details.dart';

class StartWorkResponse {
  bool? isSuccess;
  String? message;
  int? timelogId;
  List<ShiftLocationDetails>? locations;

  StartWorkResponse(
      {this.isSuccess, this.message, this.timelogId, this.locations});

  StartWorkResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    timelogId = json['timelog_id'];
    if (json['locations'] != null) {
      locations = <ShiftLocationDetails>[];
      json['locations'].forEach((v) {
        locations!.add(new ShiftLocationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['timelog_id'] = this.timelogId;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
