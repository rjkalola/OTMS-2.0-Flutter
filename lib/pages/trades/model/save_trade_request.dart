class SaveTradeRequest {
  int? tradeId;
  int? status;

  SaveTradeRequest({
    this.tradeId,
    this.status,
  });

  SaveTradeRequest.fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_id'] = this.tradeId;
    data['status'] = this.status;
    return data;
  }
}
