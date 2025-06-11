// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DashboardGridItemInfo dashboardGridItemInfoFromJson(String str) =>
    DashboardGridItemInfo.fromJson(json.decode(str));

class DashboardGridItemInfo {
  DashboardGridItemInfo({
    this.action,
    this.icon,
    this.iconColor,
    this.title,
    this.subTitle,
  });

  String? iconColor, title, subTitle, action, icon;

  factory DashboardGridItemInfo.fromJson(Map<String, dynamic> json) =>
      DashboardGridItemInfo(
        action: json["action"],
        icon: json["icon"],
        iconColor: json["iconColor"],
        title: json["title"],
        subTitle: json["subTitle"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "icon": icon,
        "iconColor": iconColor,
        "title": title,
        "subTitle": subTitle,
      };
}
