import 'package:flutter/cupertino.dart';

class MyAccountMenuItem {
  int? id;
  String? title, action;
  IconData? iconData;

  MyAccountMenuItem({this.id, this.title, this.action, this.iconData});

  MyAccountMenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    action = json['action'];
    iconData = json['iconData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['action'] = this.action;
    data['iconData'] = this.iconData;
    return data;
  }
}
