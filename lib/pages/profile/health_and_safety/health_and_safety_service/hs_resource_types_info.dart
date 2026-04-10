class HSResourceTypesInfo{
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String title;
  final String userImage;
  final String userThumbImage;

  HSResourceTypesInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.title,
    required this.userImage,
    required this.userThumbImage,
  });

  factory HSResourceTypesInfo.fromJson(Map<String, dynamic> json) {
    return HSResourceTypesInfo(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      userImage: json['user_image'] ?? '',
      userThumbImage: json['user_thumb_image'] ?? '',
    );
  }
}