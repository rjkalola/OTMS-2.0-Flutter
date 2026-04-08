class HealthAndSafetyResourceModel {
  final bool isSuccess;
  final String message;
  final List<User> users;
  final List<dynamic> teams;
  final List<dynamic> hazards;
  final List<dynamic> incidentTypes;
  final List<dynamic> threatLevels;

  HealthAndSafetyResourceModel({
    required this.isSuccess,
    required this.message,
    required this.users,
    required this.teams,
    required this.hazards,
    required this.incidentTypes,
    required this.threatLevels,
  });

  factory HealthAndSafetyResourceModel.fromJson(Map<String, dynamic> json) {
    return HealthAndSafetyResourceModel(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      users: (json['users'] as List?)?.map((i) => User.fromJson(i)).toList() ?? [],
      teams: json['teams'] ?? [],
      hazards: json['hazards'] ?? [],
      incidentTypes: json['incident_types'] ?? [],
      threatLevels: json['threat_levels'] ?? [],
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String userImage;
  final String userThumbImage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.userImage,
    required this.userThumbImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      name: json['name'] ?? '',
      userImage: json['user_image'] ?? '',
      userThumbImage: json['user_thumb_image'] ?? '',
    );
  }
}