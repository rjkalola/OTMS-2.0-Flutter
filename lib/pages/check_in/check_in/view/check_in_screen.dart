import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/check_in/controller/check_in_controller.dart';
import 'package:otm_inventory/pages/check_in/stop_shift/view/widgets/start_stop_box_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/map_view/bottom_curve_container.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/map_view/map_back_arrow.dart';
import 'package:otm_inventory/widgets/other_widgets/selection_screen_header_view.dart';
import 'package:otm_inventory/widgets/other_widgets/start_stop_box.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final controller = Get.put(CheckInController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(children: [
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      CustomMapView(
                        onMapCreated: controller.onMapCreated,
                        target: controller.center,
                      ),
                      MapBackArrow(onBackPressed: () {
                        Get.back();
                      }),
                      BottomCurveContainer()
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectionScreenHeaderView(
                          title: 'check_in_'.tr,
                          onBackPressed: () {
                            Get.back();
                          },
                        ),
                        StartStopBox(
                            title: 'check_in_'.tr,
                            time: "12:34".obs,
                            address: "",
                            isEditVisible: false.obs),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      )),
    );
  }
}
