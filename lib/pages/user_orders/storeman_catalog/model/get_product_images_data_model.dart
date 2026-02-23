class GetProductImagesDataModel {
  int? id;
  String? imageUrl;
  String? thumbUrl;
  int? addedBy;
  String? userName;
  String? userImage;

  GetProductImagesDataModel(
      {this.id,
        this.imageUrl,
        this.thumbUrl,
        this.addedBy,
        this.userName,
        this.userImage});

  GetProductImagesDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
    addedBy = json['added_by'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['thumb_url'] = this.thumbUrl;
    data['added_by'] = this.addedBy;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    return data;
  }
}