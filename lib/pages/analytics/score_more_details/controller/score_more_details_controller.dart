import 'dart:convert';
import 'dart:ui';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_grid_item.dart';
import 'package:belcka/pages/analytics/user_analytics/model/user_analytics_model.dart';
import 'package:belcka/pages/analytics/user_score/controller/user_analytics_score_repository.dart';
import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_repository.dart';
import 'package:belcka/pages/analytics/user_score_types/model/user_score_warnings_model.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreMoreDetailsController extends GetxController{
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  int? userScore = 0;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      userScore = arguments["score"] ?? 0;
    }
    isMainViewVisible.value = true;
  }
}
