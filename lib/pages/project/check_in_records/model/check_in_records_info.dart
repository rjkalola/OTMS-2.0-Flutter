import 'package:otm_inventory/pages/check_in/clock_in/model/check_log_info.dart';

class CheckInRecordsInfo {
  String? date;
  List<CheckLogInfo>? data;

  CheckInRecordsInfo({this.date, this.data});

  CheckInRecordsInfo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <CheckLogInfo>[];
      json['data'].forEach((v) {
        data!.add(new CheckLogInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}