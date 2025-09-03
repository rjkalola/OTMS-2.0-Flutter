import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:belcka/pages/profile/post_coder_search/controller/post_coder_search_repository.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/web_services/response/base_response.dart';
import 'package:belcka/web_services/response/response_model.dart';

class PostCoderSearchController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final _api = PostCoderSearchRepository();
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    isMainViewVisible.value = true;

  }
}