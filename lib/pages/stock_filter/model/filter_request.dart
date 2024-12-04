class FilterRequest {
  String? supplier, supplier_key, category, category_key, category_name;

  FilterRequest({
    this.supplier,
    this.supplier_key,
    this.category,
    this.category_key,
    this.category_name,
  });

  FilterRequest.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier'];
    category = json['category'];
    supplier_key = json['supplier_key'];
    category_key = json['category_key'];
    category_name = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier'] = supplier;
    data['supplier_key'] = supplier_key;
    data['category'] = category;
    data['category_key'] = category_key;
    data['category_name'] = category_name;
    return data;
  }
}
