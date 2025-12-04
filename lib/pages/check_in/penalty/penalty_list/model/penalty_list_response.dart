import 'package:belcka/pages/check_in/penalty/penalty_list/model/penalty_info.dart';

class PenaltyListResponse {
  bool? isSuccess;
  String? message;
  List<PenaltyInfo>? info;

  PenaltyListResponse({this.isSuccess, this.message, this.info});

  PenaltyListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <PenaltyInfo>[];
      json['info'].forEach((v) {
        info!.add(new PenaltyInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
