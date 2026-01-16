import 'dart:io';

import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static var mTime;

  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static showSnackBarMessage(String message) {
    if (message.isNotEmpty) {
      // Get.rawSnackbar(message: message);
      BotToast.showText(
        text: message,
        align: Alignment.bottomCenter, // or .center
        duration: Duration(seconds: 3),
      );
    }
  }

  static showToastMessage(String message) {
    if (message.isNotEmpty) {
      BotToast.showText(
        text: message,
        align: Alignment.bottomCenter, // or .center
        duration: Duration(seconds: 3),
      );
      // Fluttertoast.showToast(
      //   msg: message,
      // );
    }
  }

  static showApiResponseMessage(String? message) {
    if (!StringHelper.isEmptyString(message)) {
      BotToast.showText(
        text: message ?? "",
        align: Alignment.bottomCenter, // or .center
        duration: Duration(seconds: 3),
      );
      /* Fluttertoast.showToast(
        msg: message ?? "",
      );*/
      // Get.rawSnackbar(message: message);
    }
  }

  static getStringTr(String key) {
    return key.tr;
  }

  static showErrorMessage() {}

  static Future<String> getDeviceName() async {
    String deviceName = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model.isNotEmpty ? androidInfo.model : "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName =
          iosInfo.utsname.machine.isNotEmpty ? iosInfo.utsname.machine : "";
    }
    return deviceName;
  }

  static Future<String> getDeviceUniqueId() async {
    String deviceId = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    }
    return deviceId;
  }

  static haxColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return colorInt;
  }

  static Color getColor(String colorHexCode) {
    String colorNew = '0xff$colorHexCode';
    colorNew = colorNew.replaceAll("#", '');
    int colorInt = int.parse(colorNew);
    return Color(colorInt);
  }

  static Future<bool> interNetCheck() async {
    try {
      Dio dio = Dio();
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

  static bool isPermission(bool? value) {
    return value != null && value;
  }

  static bool isUserCheckIn(int? value) {
    return value != null && value > 0;
  }

  static int getLoginUserId() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    return info.id ?? 0;
  }

  static bool isAdmin() {
    UserInfo info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.admin;
    return false;
  }

  static bool isEmployee() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.employee;
    return false;
  }

  static bool isManager() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.projectManager;
    return false;
  }

  static bool isSupervisor() {
    UserInfo? info = Get.find<AppStorage>().getUserInfo();
    // return info.userTypeId == AppConstants.userType.supervisor;
    return false;
  }

  static BoxShadow boxShadow(Color color, double radius) {
    return BoxShadow(
      blurRadius: radius,
      color: color,
    );
  }

  static saveLoginUser(UserInfo user) {
    List<UserInfo> list = Get.find<AppStorage>().getLoginUsers();
    print("before length:" + list.length.toString());
    bool isUserFound = false;
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == user.id) {
          isUserFound = true;
          break;
        }
      }
    }
    if (!isUserFound) {
      list.add(user);
      Get.find<AppStorage>().setLoginUsers(list);
      print("after length:" +
          Get.find<AppStorage>().getLoginUsers().length.toString());
    }
  }

  static BoxDecoration getGrayBorderDecoration(
      {Color? color,
      double? radius,
      double? borderWidth,
      Color? borderColor,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: color ?? Colors.transparent,
      boxShadow: boxShadow ?? null,
      border: Border.all(
          width: borderWidth ?? 0.6, color: borderColor ?? Colors.transparent),
      borderRadius: BorderRadius.circular(radius ?? 12),
    );
  }

  static BoxDecoration circleDecoration(
      {Color? color, double? borderWidth, Color? borderColor}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color ?? defaultAccentColor_(Get.context!),
      border: Border.all(
        color: borderColor ?? Colors.black,
        width: borderWidth ?? 0,
      ),
    );
  }

  static BoxDecoration getDashboardItemDecoration(
      {Color? color,
      double? radius,
      double? borderWidth,
      Color? borderColor,
      double? shadowRadius,
      List<BoxShadow>? boxShadow}) {
    bool isDark = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      color: color ?? backgroundColor_(Get.context!),
      boxShadow: boxShadow ??
          [AppUtils.boxShadow(shadowColor_(Get.context!), shadowRadius ?? 6)],
      border: Border.all(
          width: borderWidth ?? 0.6,
          color: borderColor ??
              (isDark ? Color(0xFF1F1F1F) : Colors.grey.shade300)),
      borderRadius: BorderRadius.circular(radius ?? 45),
    );
  }

  static String getFlagByExtension(String? extension) {
    String flag = AppConstants.defaultFlagUrl;
    if (!StringHelper.isEmptyString(extension)) {
      final match = DataUtils.getPhoneExtensionList()
          .firstWhere((item) => item.phoneExtension == extension);
      return match.flagImage ?? flag;
    }
    return flag;
  }

  static void copyText(String? value) {
    if (!StringHelper.isEmptyString(value)) {
      Clipboard.setData(ClipboardData(text: value ?? ""));
      AppUtils.showToastMessage('copied_to_clip_board'.tr);
    }
  }

  static Color getStatusColor(int status) {
    Color color = primaryTextColor_(Get.context!);
    if (status == AppConstants.status.approved) {
      color = Colors.green;
    } else if (status == AppConstants.status.rejected) {
      color = Colors.red;
    } else if (status == AppConstants.status.pending) {
      color = Colors.orange;
    }
    return color;
  }

  static String getStatusText(int status) {
    String statusText = "";
    if (status == AppConstants.status.approved) {
      statusText = 'approved'.tr;
    } else if (status == AppConstants.status.rejected) {
      statusText = 'rejected'.tr;
    } else if (status == AppConstants.status.pending) {
      statusText = 'pending'.tr;
    }
    return statusText;
  }

  static void setStatusBarColor() {
    ThemeController themeController = Get.find();
    bool isDarkMode = themeController.isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static void onClickPhoneNumber(String phoneNumber) {
    List<ModuleInfo> listItems = [];
    listItems
        .add(ModuleInfo(name: 'call'.tr, action: AppConstants.action.edit));
    listItems
        .add(ModuleInfo(name: 'message'.tr, action: AppConstants.action.add));

    showCupertinoModalPopup(
      context: Get.context!,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CupertinoActionSheet(
            actions: listItems.map((item) {
              return CupertinoActionSheetAction(
                onPressed: () async {
                  Get.back();
                  if (item.action == AppConstants.action.edit) {
                    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
                    await launchUrl(uri);
                  } else if (item.action == AppConstants.action.add) {
                    final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
                    await launchUrl(uri);
                  }
                },
                // isDestructiveAction: item.isDestructive,
                child: Text(
                  item.name ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: item.textColor != null
                          ? Color(AppUtils.haxColor(item.textColor ?? ""))
                          : defaultAccentColor_(Get.context!)),
                ),
              );
            }).toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(Get.context!),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color:
                      ThemeConfig.isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
            )),
      ),
    );
  }

  static void onClickUserAvatar(int userID) {
    if (UserUtils.isAdmin()) {
      var arguments = {
        AppConstants.intentKey.userId: userID,
      };
      Get.toNamed(AppRoutes.myAccountScreen, arguments: arguments);
    } else {
      var arguments = {
        AppConstants.intentKey.userId: userID,
      };
      Get.toNamed(AppRoutes.myProfileDetailsScreen, arguments: arguments);
    }
  }

  static void copyEmail(String? value) async {
    if (!StringHelper.isEmptyString(value)) {
      /*
    Clipboard.setData(ClipboardData(text: value ?? ""));
    AppUtils.showToastMessage('email_copied'.tr);
    */
      openEmailApp(value ?? "");
    }
  }

  static void openEmailApp(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("No email app found or error: $e");
      Clipboard.setData(ClipboardData(text: email));
      AppUtils.showToastMessage('email_copied'.tr);
    }
  }

  static Circle getCircle(
      {required String id,
      required LatLng latLng,
      Color? color,
      required double radius}) {
    final circle = Circle(
      circleId: CircleId(id),
      center: latLng,
      radius: radius,
      fillColor: (color ?? Colors.black).withValues(alpha: 0.3),
      strokeColor: color ?? Colors.black,
      strokeWidth: 2,
    );
    return circle;
  }

  static Polyline getPolyline(
      {required String id, required List<LatLng> listLatLng, Color? color}) {
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color ?? Colors.black,
      width: 2,
      points: listLatLng,
    );
    return polyline;
  }

  static Polygon getPolygon(
      {required String id, required List<LatLng> listLatLng, Color? color}) {
    final polygon = Polygon(
      polygonId: PolygonId(id),
      points: listLatLng,
      strokeWidth: 2,
      strokeColor: color ?? Colors.black,
      fillColor:
          (color ?? Colors.black).withValues(alpha: 0.3), // new opacity API
    );
    return polygon;
  }

  static String formatStringToDecimals(double value) {
    return value.toStringAsFixed(2);
  }

  static KeyboardActionsConfig buildKeyboardConfig({
    required List<FocusNode> focusNodes,
    bool nextFocus = false,
  }) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: focusNodes
          .map(
            (focusNode) => KeyboardActionsItem(
              focusNode: focusNode,
              toolbarButtons: [
                (node) => TextButton(
                      onPressed: () => node.unfocus(),
                      child: Text(
                        'done'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: defaultAccentColor_(Get.context!),
                        ),
                      ),
                    ),
              ],
            ),
          )
          .toList(),
    );
  }
}
