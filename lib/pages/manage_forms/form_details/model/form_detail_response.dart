import 'package:belcka/pages/manage_forms/form_details/model/form_detail_info.dart';

class FormDetailResponse {
  bool? isSuccess;
  String? message;
  FormDetailInfo? info;

  FormDetailResponse({this.isSuccess, this.message, this.info});

  FormDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? FormDetailInfo.fromJson(json['info'])
        : null;
  }
}
