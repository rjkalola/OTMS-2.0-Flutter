
import 'package:belcka/pages/filter/model/filter_info.dart';

class FiltersListResponse {
  bool? isSuccess;
  String? message;
  List<FilterInfo>? info;

  FiltersListResponse({this.isSuccess, this.message, this.info});

  FiltersListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <FilterInfo>[];
      json['info'].forEach((v) {
        info!.add(new FilterInfo.fromJson(v));
      });
    }
  }
}