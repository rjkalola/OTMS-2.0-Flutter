import 'package:belcka/pages/permissions/edit_widget/controller/edit_widget_controller.dart';
import 'package:belcka/pages/permissions/edit_widget/view/widgets/edit_widget_list.dart';
import 'package:belcka/pages/permissions/edit_widget/view/widgets/select_all_text.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditWidgetScreen extends StatefulWidget {
  const EditWidgetScreen({super.key});

  @override
  State<EditWidgetScreen> createState() => _EditWidgetScreenState();
}

class _EditWidgetScreenState extends State<EditWidgetScreen> {
  final controller = Get.put(EditWidgetController());

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
                title: 'edit_widget'.tr,
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
                              // !controller.fromDashboard.value
                              //     ? SearchUserPermissionWidget()
                              //     : Container(),
                              SelectAllText(),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(right: 16, top: 9),
                              //   child: WebAppTitleView(),
                              // ),
                              EditWidgetList()
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
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
