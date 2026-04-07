import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthIssueFormItem {
  final int healthIssueId;
  int? heathId;
  final String name;
  final RxBool isYes = false.obs;
  final TextEditingController commentController = TextEditingController();

  HealthIssueFormItem({
    required this.healthIssueId,
    required this.name,
    this.heathId,
    bool? initialYes,
    String? comment,
  }) {
    isYes.value = initialYes ?? false;
    if (comment != null && comment.isNotEmpty) {
      commentController.text = comment;
    }
  }

  void dispose() {
    commentController.dispose();
  }
}
