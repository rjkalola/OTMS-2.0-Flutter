class UserOrdersCategoriesInfo {
  int? id;
  String? name;
  int? companyId;
  String? companyName;
  int? parentCategoryId;
  String? imageUrl;
  String? thumbUrl;
  bool? status;

  UserOrdersCategoriesInfo(
      {this.id,
        this.name,
        this.companyId,
        this.companyName,
        this.parentCategoryId,
        this.imageUrl,
        this.thumbUrl,
        this.status});

  UserOrdersCategoriesInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    parentCategoryId = json['parent_category_id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['parent_category_id'] = this.parentCategoryId;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['status'] = this.status;
    return data;
  }
}