class PublishTargetUser {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? userImage;
  String? userThumbImage;
  String? tradeName;

  PublishTargetUser({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.userImage,
    this.userThumbImage,
    this.tradeName,
  });

  PublishTargetUser.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    userImage = json['user_image']?.toString();
    userThumbImage = json['user_thumb_image']?.toString();
    tradeName = json['trade_name']?.toString();
  }

  String get displayName {
    final full = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    if (full.isNotEmpty) return full;
    return name ?? '';
  }
}

class PublishTargetSettings {
  String? publishMode;
  String? publishDate;
  String? publishTime;
  bool? notifyUsers;
  String? notificationMessage;
  bool? showOnFeed;
  String? feedBy;
  bool? sendReminder;
  String? reminderDate;
  String? reminderTime;
  bool? scheduleRemoval;
  String? removalDate;
  String? removalTime;

  PublishTargetSettings({
    this.publishMode,
    this.publishDate,
    this.publishTime,
    this.notifyUsers,
    this.notificationMessage,
    this.showOnFeed,
    this.feedBy,
    this.sendReminder,
    this.reminderDate,
    this.reminderTime,
    this.scheduleRemoval,
    this.removalDate,
    this.removalTime,
  });

  PublishTargetSettings.fromJson(Map<String, dynamic> json) {
    publishMode = json['publish_mode']?.toString();
    publishDate = json['publish_date']?.toString();
    publishTime = json['publish_time']?.toString();
    notifyUsers = json['notify_users'];
    notificationMessage = json['notification_message']?.toString();
    showOnFeed = json['show_on_feed'];
    feedBy = json['feed_by']?.toString();
    sendReminder = json['send_reminder'];
    reminderDate = json['reminder_date']?.toString();
    reminderTime = json['reminder_time']?.toString();
    scheduleRemoval = json['schedule_removal'];
    removalDate = json['removal_date']?.toString();
    removalTime = json['removal_time']?.toString();
  }
}

class PublishTargetModel {
  List<dynamic>? selectedTeams;
  List<PublishTargetUser>? selectedUsers;
  String? groupAssignmentMode;
  PublishTargetSettings? settings;

  PublishTargetModel({
    this.selectedTeams,
    this.selectedUsers,
    this.groupAssignmentMode,
    this.settings,
  });

  PublishTargetModel.fromJson(Map<String, dynamic> json) {
    selectedTeams = json['selected_teams'] is List
        ? List<dynamic>.from(json['selected_teams'])
        : null;
    groupAssignmentMode = json['group_assignment_mode']?.toString();

    if (json['selected_users'] != null) {
      selectedUsers = <PublishTargetUser>[];
      json['selected_users'].forEach((v) {
        selectedUsers!.add(PublishTargetUser.fromJson(v));
      });
    }

    settings = json['settings'] != null
        ? PublishTargetSettings.fromJson(json['settings'])
        : null;
  }
}
