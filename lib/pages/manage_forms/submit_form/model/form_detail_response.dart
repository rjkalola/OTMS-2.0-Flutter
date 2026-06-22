import 'package:belcka/pages/manage_forms/submit_form/model/form_detail_info.dart';

class FormDetailResponse {
  bool? isSuccess;
  String? message;
  FormDetailInfo? info;
  int? activeCompanyId;

  FormDetailResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  FormDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    activeCompanyId = json['active_company_id'];
    info = json['info'] != null
        ? FormDetailInfo.fromJson(json['info'])
        : null;
  }
}
