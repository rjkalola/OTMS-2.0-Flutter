import 'filter_info.dart';

class StockFilterResponse {
  bool? isSuccess;
  String? message;
  List<FilterInfo>? info;

  StockFilterResponse({this.isSuccess, this.message, this.info});

  StockFilterResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    if (json['info'] != null) {
      info = <FilterInfo>[];
      json['info'].forEach((v) {
        info!.add(FilterInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    if (info != null) {
      data['info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
