class FormCreatedBy {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? tradeName;
  String? image;

  FormCreatedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.tradeName,
    this.image,
  });

  FormCreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    tradeName = json['trade_name']?.toString();
    image = json['createdBy_thumb_image'] ??
        json['createdBy_image'] ??
        json['user_thumb_image'] ??
        json['user_image'] ??
        json['image']?.toString();
  }

  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get initials {
    final first = (firstName ?? '').trim();
    final last = (lastName ?? '').trim();
    if (first.isEmpty && last.isEmpty) return '';
    if (first.isEmpty) return last.substring(0, 1).toUpperCase();
    if (last.isEmpty) return first.substring(0, 1).toUpperCase();
    return '${first.substring(0, 1)}${last.substring(0, 1)}'.toUpperCase();
  }
}
