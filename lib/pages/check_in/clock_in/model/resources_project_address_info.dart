class ResourcesProjectAddressInfo {
  int? id;
  String? name;
  int? projectId;
  int? filterValue;
  String? filterKey;

  ResourcesProjectAddressInfo(
      {this.id, this.name, this.projectId, this.filterValue, this.filterKey});

  ResourcesProjectAddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    projectId = json['project_id'];
    filterValue = json['filter_value'];
    filterKey = json['filter_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['project_id'] = this.projectId;
    data['filter_value'] = this.filterValue;
    data['filter_key'] = this.filterKey;
    return data;
  }
}
