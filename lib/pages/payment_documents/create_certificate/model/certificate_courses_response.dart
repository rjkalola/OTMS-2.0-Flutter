import 'package:belcka/web_services/response/module_info.dart';

class CertificateCoursesResponse {
  bool? isSuccess;
  String? message;
  List<ModuleInfo>? info;

  CertificateCoursesResponse({this.isSuccess, this.message, this.info});

  CertificateCoursesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <ModuleInfo>[];
      json['info'].forEach((v) {
        info!.add(ModuleInfo.fromJson(v));
      });
    }
  }
}
