// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DashboardActionItemInfo dashboardActionItemInfoFromJson(String str) =>
    DashboardActionItemInfo.fromJson(json.decode(str));

class DashboardActionItemInfo {
  DashboardActionItemInfo({
    this.id,
    this.image,
    this.backgroundColor,
    this.title,
  });

  String? id;
  String? image;
  String? backgroundColor;
  String? title;

  factory DashboardActionItemInfo.fromJson(Map<String, dynamic> json) =>
      DashboardActionItemInfo(
        id: json["id"],
        image: json["image"],
        backgroundColor: json["backgroundColor"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "backgroundColor": backgroundColor,
        "title": title,
      };
}
