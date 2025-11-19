import 'package:belcka/pages/digital_id_card/model/digital_id_card_info.dart';

class DigitalIdCardResponse {
  bool? isSuccess;
  String? message;
  DigitalIdCardInfo? info;

  DigitalIdCardResponse({this.isSuccess, this.message, this.info});

  DigitalIdCardResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? new DigitalIdCardInfo.fromJson(json['info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
