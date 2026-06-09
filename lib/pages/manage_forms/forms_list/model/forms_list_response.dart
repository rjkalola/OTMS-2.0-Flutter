import 'package:belcka/pages/manage_forms/forms_list/model/form_info.dart';

class FormsListResponse {
  bool? isSuccess;
  String? message;
  FormsListInfo? info;

  FormsListResponse({this.isSuccess, this.message, this.info});

  FormsListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    final infoJson = json['info'];
    if (infoJson is List) {
      info = FormsListInfo.fromList(infoJson);
    } else if (infoJson is Map<String, dynamic>) {
      info = FormsListInfo.fromJson(infoJson);
    }
  }
}

class FormsListInfo {
  List<FormInfo>? data;
  FormsListPagination? pagination;
  FormsListCounts? counts;

  FormsListInfo({this.data, this.pagination, this.counts});

  FormsListInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FormInfo>[];
      json['data'].forEach((v) {
        data!.add(FormInfo.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? FormsListPagination.fromJson(json['pagination'])
        : null;
    counts =
        json['counts'] != null ? FormsListCounts.fromJson(json['counts']) : null;
  }

  factory FormsListInfo.fromList(List<dynamic> list) {
    return FormsListInfo(
      data: list
          .map((v) => FormInfo.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FormsListPagination {
  int? total;

  FormsListPagination({this.total});

  FormsListPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }
}

class FormsListCounts {
  int? active;
  int? archived;

  FormsListCounts({this.active, this.archived});

  FormsListCounts.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    archived = json['archived'];
  }
}
