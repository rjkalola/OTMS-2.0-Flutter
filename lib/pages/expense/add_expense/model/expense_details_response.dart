import 'package:belcka/pages/expense/add_expense/model/expense_info.dart';

class ExpenseDetailsResponse {
  bool? isSuccess;
  String? message;
  ExpenseInfo? info;

  ExpenseDetailsResponse({this.isSuccess, this.message, this.info});

  ExpenseDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    info = json['info'] != null ? new ExpenseInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
