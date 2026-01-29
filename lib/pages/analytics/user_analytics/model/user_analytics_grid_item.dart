import 'package:flutter/cupertino.dart';

class UserAnalyticsGridItem {
  int? id;
  String? title,value, action;
  IconData? iconData;
  Color? color;

  UserAnalyticsGridItem({this.id, this.title, this.value, this.action, this.iconData, this.color});

  UserAnalyticsGridItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    action = json['action'];
    iconData = json['iconData'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['value'] = this.value;
    data['action'] = this.action;
    data['iconData'] = this.iconData;
    data['color'] = this.color;
    return data;
  }
}
