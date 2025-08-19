class ProjectDetalsItem {
  String title;
  String subtitle;
  int? badge;
  String? iconPath;
  String? iconColor;
  String? flagName;

  ProjectDetalsItem(
      {required this.title,
      required this.subtitle,
      this.badge,
      this.iconPath,
      this.iconColor,
      this.flagName});
}
