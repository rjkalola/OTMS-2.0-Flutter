import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';

class CertificatesListResponse {
  bool? isSuccess;
  String? message;
  List<CertificateInfo>? info;
  int? activeCompanyId;

  CertificatesListResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  CertificatesListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <CertificateInfo>[];
      json['info'].forEach((v) {
        info!.add(CertificateInfo.fromJson(v));
      });
    }
    activeCompanyId = json['active_company_id'];
  }
}
