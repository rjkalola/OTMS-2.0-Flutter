class TypeOfWorkResourcesInfo {
  int? id;
  String? name;
  int? companyId;
  String? companyName;
  int? tradeId;
  String? tradeName;
  String? startDate;
  String? duration;
  bool? isPricework;
  String? rate;
  String? repeatableJob;
  String? units;

  TypeOfWorkResourcesInfo(
      {this.id,
        this.name,
        this.companyId,
        this.companyName,
        this.tradeId,
        this.tradeName,
        this.startDate,
        this.duration,
        this.isPricework,
        this.rate,
        this.repeatableJob,
        this.units});

  TypeOfWorkResourcesInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    tradeId = json['trade_id'];
    tradeName = json['trade_name'];
    startDate = json['start_date'];
    duration = json['duration'];
    isPricework = json['is_pricework'];
    rate = json['rate'];
    repeatableJob = json['repeatable_job'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['trade_id'] = this.tradeId;
    data['trade_name'] = this.tradeName;
    data['start_date'] = this.startDate;
    data['duration'] = this.duration;
    data['is_pricework'] = this.isPricework;
    data['rate'] = this.rate;
    data['repeatable_job'] = this.repeatableJob;
    data['units'] = this.units;
    return data;
  }
}
