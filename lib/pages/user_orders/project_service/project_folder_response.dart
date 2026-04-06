import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Main response model
class ProjectFolderResponse {
  final bool isSuccess;
  final String message;
  final List<ProjectFolderInfo> info;

  ProjectFolderResponse({
    required this.isSuccess,
    required this.message,
    required this.info,
  });

  factory ProjectFolderResponse.fromJson(Map<String, dynamic> json) {
    var list = json['info'] as List? ?? [];

    List<ProjectFolderInfo> folderList = [];

    for (int i = 0; i < list.length; i++) {
      folderList.add(ProjectFolderInfo.fromJson(list[i], i));
    }

    return ProjectFolderResponse(
      isSuccess: json['IsSuccess'] ?? false,
      message: json['message'] ?? '',
      info: folderList,
    );
  }
}


class ProjectFolderInfo {
  final int id;
  final String name;
  final int companyId;
  final String companyName;
  final int? projectId;
  final String? projectName;
  final List<dynamic> favoriteProducts;

  // 1. Add the color property
  final Color folderColor;

  ProjectFolderInfo({
    required this.id,
    required this.name,
    required this.companyId,
    required this.companyName,
    this.projectId,
    this.projectName,
    required this.favoriteProducts,
    required this.folderColor, // 2. Require it in constructor
  });

  // 3. Factory update: Pass the index/count to generate the color
  factory ProjectFolderInfo.fromJson(Map<String, dynamic> json, int index) {
    return ProjectFolderInfo(
      id: json['id'],
      name: json['name'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      favoriteProducts: json['favorite_products'] ?? [],
      folderColor: _generateColor(index),
    );
  }

  // 5. Logic to pick a color based on folder count
  static Color _generateColor(int index) {
    const List<Color> uiColors = [
      Colors.deepOrangeAccent, // Deep orange
      Color(0xFF2196F3), // Blue
      Color(0xFF673AB7), // Deep Purple
      Color(0xFF00BCD4), // Cyan
      Color(0xFF4CAF50), // Green
      Color(0xFFFF9800), // Orange
      Color(0xFFE91E63), // Pink
      Color(0xFF3F51B5), // Indigo
    ];

    // Uses modulo to loop through the list if count exceeds list length
    return uiColors[index % uiColors.length];
  }
}