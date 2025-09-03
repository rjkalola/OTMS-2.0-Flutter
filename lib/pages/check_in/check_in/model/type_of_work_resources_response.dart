import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';

class TypeOfWorkResourcesResponse {
  bool? isSuccess;
  String? message;
  List<TypeOfWorkResourcesInfo>? info;

  TypeOfWorkResourcesResponse({this.isSuccess, this.message, this.info});

  TypeOfWorkResourcesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <TypeOfWorkResourcesInfo>[];
      json['info'].forEach((v) {
        info!.add(new TypeOfWorkResourcesInfo.fromJson(v));
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
