class FormCreatedBy {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;

  FormCreatedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
  });

  FormCreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    image = json['createdBy_thumb_image'] ??
        json['createdBy_image'] ??
        json['image'];
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
