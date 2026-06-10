import 'dart:ui';

import 'package:belcka/pages/my_requests/model/my_request_info.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_response_model.dart';

class MyRequestListResponse {
  bool? isSuccess;
  String? message;
  List<MyRequestInfo>? requests;
  PaginationData? pagination;

  MyRequestListResponse({this.isSuccess, this.message, this.requests, this.pagination});

  MyRequestListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['requests'] != null) {
      requests = <MyRequestInfo>[];
      json['requests'].forEach((v) {
        requests!.add(new MyRequestInfo.fromJson(v));
      });
    }
    pagination=  json['data'] != null ? PaginationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

