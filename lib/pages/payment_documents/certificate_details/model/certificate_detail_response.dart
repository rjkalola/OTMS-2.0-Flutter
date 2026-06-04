import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';

class CertificateDetailResponse {
  bool? isSuccess;
  String? message;
  CertificateInfo? info;
  int? activeCompanyId;

  CertificateDetailResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  CertificateDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null
        ? CertificateInfo.fromJson(json['info'])
        : null;
    activeCompanyId = json['active_company_id'];
  }
}
