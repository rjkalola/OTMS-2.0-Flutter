import 'package:belcka/pages/dashboard/tabs/home_tab/model/form_submission_status_info.dart';

class FormSubmissionStatusResponse {
  bool? isSuccess;
  String? message;
  FormSubmissionStatusInfo? info;
  int? activeCompanyId;

  FormSubmissionStatusResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  FormSubmissionStatusResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? FormSubmissionStatusInfo.fromJson(
            json['info'] as Map<String, dynamic>,
          )
        : null;
    activeCompanyId = json['active_company_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'IsSuccess': isSuccess,
      'message': message,
      'info': info?.toJson(),
      'active_company_id': activeCompanyId,
    };
  }
}
