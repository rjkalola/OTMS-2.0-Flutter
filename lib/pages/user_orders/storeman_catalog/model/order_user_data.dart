class OrderUserData {
  int? id;
  String? userName;
  String? imageUrl;
  String? thumbUrl;

  OrderUserData({
    this.id,
    this.userName,
    this.imageUrl,
    this.thumbUrl,
  });

  OrderUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    imageUrl = json['image_url'];
    thumbUrl = json['thumb_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'image_url': imageUrl,
      'thumb_url': thumbUrl,
    };
  }
}
