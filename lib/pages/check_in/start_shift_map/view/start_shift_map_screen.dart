import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/start_shift_map/controller/start_shift_map_controller.dart';
import 'package:belcka/pages/check_in/start_shift_map/view/widgets/footer_buttons.dart';
import 'package:belcka/pages/check_in/start_shift_map/view/widgets/start_shift_button.dart';
import 'package:belcka/pages/check_in/start_shift_map/view/widgets/start_shift_map_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/map_view/map_back_arrow.dart';

class StartShiftMapScreen extends StatefulWidget {
  const StartShiftMapScreen({super.key});

  @override
  State<StartShiftMapScreen> createState() => _StartShiftMapScreenState();
}

class _StartShiftMapScreenState extends State<StartShiftMapScreen> {
  final controller = Get.put(StartShiftMapController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          /* appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'shift'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),*/
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
                          children: [
                            StartShiftMapView(),
                            MapBackArrow(onBackPressed: (){
                              Get.back();
                            },),
                            FooterButtons()
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
