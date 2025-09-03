import 'package:belcka/pages/check_in/clock_in2/model/shift_location_details.dart';

class CheckInResponse {
  bool? isSuccess;
  String? message;
  int? checklogId;
  List<ShiftLocationDetails>? locations;

  CheckInResponse(
      {this.isSuccess, this.message, this.checklogId, this.locations});

  CheckInResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    checklogId = json['checklog_id'];
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
    data['checklog_id'] = this.checklogId;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
