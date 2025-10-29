import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';

class AddressDocumentsResponse {
  bool? isSuccess;
  List<TypeOfWorkResourcesInfo>? info;

  AddressDocumentsResponse({this.isSuccess, this.info});

  AddressDocumentsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['info'] != null) {
      info = <TypeOfWorkResourcesInfo>[];
      json['info'].forEach((v) {
        info!.add(new TypeOfWorkResourcesInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
