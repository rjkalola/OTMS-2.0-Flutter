class ModuleInfo {
  int? id;
  String? name,
      symbol,
      value,
      code,
      phoneExtension,
      flagImage,
      action,
      companyLogo;
  bool? check;

  ModuleInfo(
      {this.id,
      this.name,
      this.symbol,
      this.value,
      this.code,
      this.phoneExtension,
      this.flagImage,
      this.check,
      this.action,
      this.companyLogo});

  ModuleInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    value = json['value'];
    code = json['code'];
    phoneExtension = json['phone_extension'];
    flagImage = json['flag_image'];
    companyLogo = json['company_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['value'] = this.value;
    data['code'] = this.code;
    data['phone_extension'] = this.phoneExtension;
    data['flag_image'] = this.flagImage;
    data['company_logo'] = this.companyLogo;
    return data;
  }
}
