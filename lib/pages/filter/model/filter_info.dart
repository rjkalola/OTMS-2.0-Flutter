class FilterInfo {
  int? id;
  String? name, key, thumb_image;
  bool? selected;
  List<FilterInfo>? data;

  FilterInfo(
      {this.id,
      this.name,
      this.key,
      this.thumb_image,
      this.data,
      this.selected});

  FilterInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
    thumb_image = json['thumb_image'];
    if (json['data'] != null) {
      data = <FilterInfo>[];
      json['data'].forEach((v) {
        data!.add(FilterInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['key'] = key;
    data['thumb_image'] = thumb_image;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
