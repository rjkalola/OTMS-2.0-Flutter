import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/controller/user_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/view/widgets/search_user_permission.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/view/widgets/select_all_text.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/view/widgets/user_permissions_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/utils/app_utils.dart';
class UserPermissionScreen extends StatefulWidget {
  const UserPermissionScreen({super.key});

  @override
  State<UserPermissionScreen> createState() => _UserPermissionScreenState();
}

class _UserPermissionScreenState extends State<UserPermissionScreen> {
  final controller = Get.put(UserPermissionController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.fromDashboard.value
                  ? 'edit_widget'.tr
                  : 'user_permissions'.tr,
              isCenterTitle: false,
              isBack: true,
              // widgets: actionButtons(),
              onBackPressed: () {
                controller.onBackPress();
              },
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                    controller.getCompanyPermissionsApi();
                  },
                )
                    : Visibility(
                  visible: controller.isMainViewVisible.value,
                  child: Column(
                    children: [
                      Divider(),
                      !controller.fromDashboard.value
                          ? SearchUserPermissionWidget()
                          : Container(),
                      SelectAllText(),
                      UserPermissionsList()
                    ],
                  ),
                )),
          ),
        ),
      ),),
    );
  }

/* List<Widget>? actionButtons() {
    return [
      TextButton(
        onPressed: () {
          if (controller.isDataUpdated.value) {
            controller.changeUserBulkPermissionStatusApi();
          }
        },
        child: PrimaryTextView(
          text: 'save'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: controller.isDataUpdated.value
              ? defaultAccentColor
              : defaultAccentLightColor,
        ),
      )
    ];
  }*/
}
