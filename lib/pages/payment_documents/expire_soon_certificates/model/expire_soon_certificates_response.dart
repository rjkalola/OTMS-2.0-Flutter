import 'package:belcka/pages/payment_documents/expire_soon_certificates/model/expire_soon_section_info.dart';

class ExpireSoonCertificatesResponse {
  bool? isSuccess;
  String? message;
  List<ExpireSoonSectionInfo>? info;
  int? activeCompanyId;

  ExpireSoonCertificatesResponse({
    this.isSuccess,
    this.message,
    this.info,
    this.activeCompanyId,
  });

  ExpireSoonCertificatesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <ExpireSoonSectionInfo>[];
      json['info'].forEach((v) {
        info!.add(ExpireSoonSectionInfo.fromJson(v));
      });
    }
    activeCompanyId = json['active_company_id'];
  }
}
