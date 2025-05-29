class TradeInfo {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<TradeInfo>? trades;
  bool? status;

  TradeInfo(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.trades,
      this.status});

  TradeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['trades'] != null) {
      trades = <TradeInfo>[];
      json['trades'].forEach((v) {
        trades!.add(new TradeInfo.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.trades != null) {
      data['trades'] = this.trades!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}
