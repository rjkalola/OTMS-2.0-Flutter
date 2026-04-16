class ModuleInfo {
  int? id, companyId, projectId, tradeId, productsCount, count;
  String? name,
      symbol,
      value,
      code,
      phoneExtension,
      flagImage,
      action,
      companyLogo,
      icon,
      textColor,
      randomColor,
      type,
      imageUrl,
      thumbUrl;
  bool? check, isTransportCategory;

  ModuleInfo(
      {this.id,
      this.projectId,
      this.companyId,
      this.tradeId,
      this.name,
      this.symbol,
      this.value,
      this.code,
      this.phoneExtension,
      this.flagImage,
      this.check,
      this.action,
      this.companyLogo,
      this.icon,
      this.textColor,
      this.randomColor,
      this.type,
      this.imageUrl,
      this.thumbUrl,
      this.productsCount,
      this.count,
      this.isTransportCategory});

  ModuleInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    companyId = json['company_id'];
    tradeId = json['trade_id'];
    name = json['name'];
    symbol = json['symbol'];
    value = json['value'];
    code = json['code'];
    phoneExtension = json['phone_extension'];
    flagImage = json['flag_image'];
    companyLogo = json['company_logo'];
    icon = json['icon'];
    textColor = json['textColor'];
    randomColor = json['randomColor'];
    type = json['type'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    productsCount = json['products_count'];
    count = json['count'];
    isTransportCategory = json['is_transport_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['company_id'] = this.companyId;
    data['trade_id'] = this.tradeId;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['value'] = this.value;
    data['code'] = this.code;
    data['phone_extension'] = this.phoneExtension;
    data['flag_image'] = this.flagImage;
    data['company_logo'] = this.companyLogo;
    data['icon'] = this.icon;
    data['textColor'] = this.textColor;
    data['randomColor'] = this.randomColor;
    data['type'] = this.type;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['products_count'] = this.productsCount;
    data['count'] = this.count;
    data['is_transport_category'] = this.isTransportCategory;

    return data;
  }
}
