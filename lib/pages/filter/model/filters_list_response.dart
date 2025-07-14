import 'dart:ui';

import 'package:otm_inventory/pages/filter/model/filter_section_model.dart';

class FiltersListResponse {
  bool? isSuccess;
  String? message;
  List<FilterSection>? info;

  FiltersListResponse({this.isSuccess, this.message, this.info});

  FiltersListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['info'] != null) {
      info = <FilterSection>[];
      json['info'].forEach((v) {
        info!.add(new FilterSection.fromJson(v));
      });
    }
  }
}