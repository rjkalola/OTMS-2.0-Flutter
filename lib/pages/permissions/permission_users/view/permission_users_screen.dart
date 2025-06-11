import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/permissions/permission_users/view/widgets/select_all_text.dart';
import 'package:otm_inventory/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:otm_inventory/pages/permissions/permission_users/view/widgets/permission_users_list.dart';
import 'package:otm_inventory/pages/permissions/permission_users/view/widgets/search_permission_users.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class PermissionUsersScreen extends StatefulWidget {
  const PermissionUsersScreen({super.key});

  @override
  State<PermissionUsersScreen> createState() => _PermissionUsersScreenState();
}

class _PermissionUsersScreenState extends State<PermissionUsersScreen> {
  final controller = Get.put(PermissionUsersController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.title.value,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
                // Get.back(result: controller.isDataUpdated.value);
              },
            ),
            body: Obx(() {
              return ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            controller.getPermissionUsersApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchPermissionUsersWidget(),
                              SelectAllText(),
                              PermissionUsersList()
                            ],
                          ),
                        ));
            }),
          ),
        ),
      ),
    );
  }
}
