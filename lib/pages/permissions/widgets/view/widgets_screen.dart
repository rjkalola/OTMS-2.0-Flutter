import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/permissions/widgets/controller/widgets_controller.dart';
import 'package:otm_inventory/pages/permissions/widgets/view/widgets/search_widgets.dart';
import 'package:otm_inventory/pages/permissions/widgets/view/widgets/widgets_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class WidgetsScreen extends StatefulWidget {
  const WidgetsScreen({super.key});

  @override
  State<WidgetsScreen> createState() => _WidgetsScreenState();
}

class _WidgetsScreenState extends State<WidgetsScreen> {
  final controller = Get.put(WidgetsController());

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
              title: 'widget'.tr,
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
                            controller.getCompanyPermissionsApi(true);
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchWidgets(),
                              WidgetsList()
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
