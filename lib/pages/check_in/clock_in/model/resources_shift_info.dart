class ResourcesShiftInfo {
  int? id;
  String? name;
  String? iconUrl;

  ResourcesShiftInfo({this.id, this.name, this.iconUrl});

  ResourcesShiftInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon_url'] = this.iconUrl;
    return data;
  }
}
