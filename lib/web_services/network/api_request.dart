import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_storage.dart';
import '../response/response_model.dart';
import 'api_exception.dart';

class ApiRequest {
  final String url;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  var response;
  multi.FormData? formData;
  bool? isFormData = false;
  late Dio dio;

  // live
  //final BASE_URL = "http://distportal.navneet.com/mobile/";

  ApiRequest(
      {required this.url,
      this.data,
      this.formData,
      this.queryParameters,
      this.isFormData = false});

  Future<bool> interNetCheck() async {
    try {
      dio = Dio();
      dio.options.connectTimeout = const Duration(minutes: 3); //3 minutes
      dio.options.receiveTimeout = const Duration(minutes: 3); //3 minutes
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  // Future<bool> interNetCheck() async {
  //   try {
  //     final foo = await InternetAddress.lookup('google.com');
  //     return foo.isNotEmpty && foo[0].rawAddress.isNotEmpty ? true : false;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<dynamic> getRequest({
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    ResponseModel responseModel;
    try {
      bool isInternet = await interNetCheck();
      if (isInternet) {
        response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: ApiConstants.getHeader(),
          ),
        );
        if (kDebugMode) print("Response Data ==> ${response.data}");
        /* if (response.statusCode == 200) {
          responseModel = returnResponse(jsonEncode(response.data),
              response.statusCode, response.statusMessage);
        } else {
          responseModel =
              returnResponse(null, response.statusCode, response.statusMessage);
        }
        if (onSuccess != null) onSuccess(responseModel);*/
        if (response.statusCode == 200) {
          bool isSuccess = response.data['IsSuccess'];
          int errorCode = response.data['ErrorCode'] ?? 0;
          print("isSuccess:" + isSuccess.toString());
          print("errorCode:" + errorCode.toString());
          if (isSuccess || errorCode != 401) {
            responseModel = returnResponse(jsonEncode(response.data),
                response.statusCode, response.statusMessage);
          } else {
            showUnAuthorizedDialog();
            responseModel = returnResponse(null, 0, "");
          }
        } else {
          responseModel =
              returnResponse(null, response.statusCode, response.statusMessage);
        }
        if (onSuccess != null) onSuccess(responseModel);
      } else {
        responseModel = returnResponse(
            null, ApiConstants.CODE_NO_INTERNET_CONNECTION, 'try_again'.tr);
        if (onError != null) onError(responseModel);
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioError(e);
      if (kDebugMode) print("Error in api call $apiException.message");
      responseModel = returnResponse(null, 0, apiException.message);
    }
    return responseModel;
  }

  Future<dynamic> postRequest({
    Function()? beforeSend,
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    ResponseModel responseModel;
    try {
      bool isInternet = await interNetCheck();
      // AppUtils.showToastMessage("Internet Connection:"+isInternet.toString());
      if (isInternet) {
        if (kDebugMode) print("accessToken:::" + ApiConstants.accessToken);
        if (kDebugMode) print("URL ==> $url");
        if (kDebugMode) print("isFormData ==> $isFormData");
        if (!isFormData!) {
          if (kDebugMode) print("Request Data1 ==> ${data.toString()}");
          response = await dio.post(
            url,
            data: data,
            options: Options(
              headers: ApiConstants.getHeader(),
            ),
          );
        } else {
          if (kDebugMode) print("Request Data2 ==> ${formData.toString()}");
          multi.Dio dio = multi.Dio();
          response = await dio.post(
            url,
            data: formData,
            options: Options(
              headers: ApiConstants.getHeader(),
              // receiveTimeout: Duration(minutes: 3),
              // sendTimeout: Duration(minutes: 3),
            ),
          );
        }
        if (kDebugMode) print("Response Data ==> ${response.data}");

        if (response.statusCode == 200) {
          print("111111111112");
          bool isSuccess = response.data['IsSuccess'];
          int errorCode = response.data['ErrorCode'] ?? 0;
          print("isSuccess:" + isSuccess.toString());
          print("errorCode:" + errorCode.toString());
          if (isSuccess || errorCode != 401) {
            responseModel = returnResponse(jsonEncode(response.data),
                response.statusCode, response.statusMessage);
          } else {
            showUnAuthorizedDialog();
            responseModel = returnResponse(null, 0, "");
          }
        } else {
          print("2222222222222");
          responseModel =
              returnResponse(null, response.statusCode, response.statusMessage);
        }
        if (onSuccess != null) onSuccess(responseModel);
      } else {
        print("333333333333");
        responseModel = returnResponse(
            null, ApiConstants.CODE_NO_INTERNET_CONNECTION, 'try_again'.tr);
        if (onError != null) onError(responseModel);
      }
    } on DioException catch (e) {
      print("4444444444444");
      final ApiException apiException = ApiException.fromDioError(e);
      if (kDebugMode) print("Error in api call $apiException.message");
      responseModel = returnResponse(null, 0, apiException.message);
      if (onError != null) onError(responseModel);
    }
    return responseModel;
  }

  ResponseModel returnResponse(
      String? result, int? statusCode, String? statusMessage) {
    var responseModel = ResponseModel(
        result: result, statusCode: statusCode, statusMessage: statusMessage);
    return responseModel;
  }

  showUnAuthorizedDialog() {
    Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: CupertinoAlertDialog(
          content: Text('unauthorized_message'.tr,
              style: const TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(fontSize: 18)),
              onPressed: () {
                Get.find<AppStorage>().clearAllData();
                Get.offAllNamed(AppRoutes.loginScreen);
              },
            ),
          ],
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ),
      ),
    );
  }
}
