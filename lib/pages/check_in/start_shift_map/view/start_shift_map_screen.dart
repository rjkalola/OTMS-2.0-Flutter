import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:otm_inventory/pages/check_in/start_shift_map/view/widgets/start_shift_map_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class StartShiftMapScreen extends StatefulWidget {
  const StartShiftMapScreen({super.key});

  @override
  State<StartShiftMapScreen> createState() => _StartShiftMapScreenState();
}

class _StartShiftMapScreenState extends State<StartShiftMapScreen> {
  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'shift'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget()
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Stack(
                          children: [StartShiftMapView()],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
