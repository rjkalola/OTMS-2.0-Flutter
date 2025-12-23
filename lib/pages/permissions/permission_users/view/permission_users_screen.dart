import 'package:belcka/pages/permissions/user_permissions/view/widgets/web_app_title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:belcka/pages/permissions/permission_users/view/widgets/permission_users_list.dart';
import 'package:belcka/pages/permissions/permission_users/view/widgets/search_permission_users.dart';
import 'package:belcka/pages/permissions/permission_users/view/widgets/select_all_text.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/utils/app_utils.dart';

class PermissionUsersScreen extends StatefulWidget {
  const PermissionUsersScreen({super.key});

  @override
  State<PermissionUsersScreen> createState() => _PermissionUsersScreenState();
}

class _PermissionUsersScreenState extends State<PermissionUsersScreen> {
  final controller = Get.put(PermissionUsersController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: controller.title.value,
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 16, top: 9),
                                child: WebAppTitleView(),
                              ),
                              PermissionUsersList()
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      TextButton(
        onPressed: () {
          if (controller.isDataUpdated.value) {
            controller.changePermissionUserStatusApi();
          }
        },
        child: PrimaryTextView(
          text: 'save'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: controller.isDataUpdated.value
              ? defaultAccentColor_(context)
              : defaultAccentLightColor_(context),
        ),
      )
    ];
  }
}
