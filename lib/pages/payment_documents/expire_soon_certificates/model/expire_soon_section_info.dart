import 'package:belcka/pages/payment_documents/certificates_list/model/certificate_info.dart';

class ExpireSoonSectionInfo {
  String? title;
  int? count;
  List<CertificateInfo>? data;

  ExpireSoonSectionInfo({
    this.title,
    this.count,
    this.data,
  });

  ExpireSoonSectionInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'];
    if (json['data'] != null) {
      data = <CertificateInfo>[];
      json['data'].forEach((v) {
        data!.add(CertificateInfo.fromJson(v));
      });
    }
  }
}
