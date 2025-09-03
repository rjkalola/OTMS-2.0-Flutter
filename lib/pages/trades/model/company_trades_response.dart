import 'package:belcka/pages/trades/model/trade_info.dart';

class CompanyTradesResponse {
  bool? isSuccess;
  String? message;
  List<TradeInfo>? companyTrades;

  CompanyTradesResponse({this.isSuccess, this.message, this.companyTrades});

  CompanyTradesResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    if (json['company_trades'] != null) {
      companyTrades = <TradeInfo>[];
      json['company_trades'].forEach((v) {
        companyTrades!.add(new TradeInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.companyTrades != null) {
      data['company_trades'] =
          this.companyTrades!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
