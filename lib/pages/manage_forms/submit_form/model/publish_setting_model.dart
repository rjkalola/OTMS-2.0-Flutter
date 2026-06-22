class PublishSettingModel {
  int? id;
  int? formId;
  String? selectedTeamIds;
  String? selectedTeams;
  String? selectedUserIds;
  String? selectedUsers;
  String? groupAssignmentMode;
  int? totalGroups;
  int? totalUsers;
  int? totalAssignees;
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
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PublishSettingModel({
    this.id,
    this.formId,
    this.selectedTeamIds,
    this.selectedTeams,
    this.selectedUserIds,
    this.selectedUsers,
    this.groupAssignmentMode,
    this.totalGroups,
    this.totalUsers,
    this.totalAssignees,
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  PublishSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formId = json['form_id'];
    selectedTeamIds = json['selected_team_ids']?.toString();
    selectedTeams = json['selected_teams']?.toString();
    selectedUserIds = json['selected_user_ids']?.toString();
    selectedUsers = json['selected_users']?.toString();
    groupAssignmentMode = json['group_assignment_mode']?.toString();
    totalGroups = json['total_groups'];
    totalUsers = json['total_users'];
    totalAssignees = json['total_assignees'];
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
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }
}
