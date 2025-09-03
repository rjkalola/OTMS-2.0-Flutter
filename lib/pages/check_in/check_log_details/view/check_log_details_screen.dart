import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/check_log_details/controller/check_log_details_controller.dart';
import 'package:belcka/pages/check_in/check_log_details/view/widgets/my_day_log_details_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

class CheckLogDetailsScreen extends StatefulWidget {
  const CheckLogDetailsScreen({super.key});

  @override
  State<CheckLogDetailsScreen> createState() => _CheckLogDetailsScreenState();
}

class _CheckLogDetailsScreenState extends State<CheckLogDetailsScreen> {
  final controller = Get.put(CheckLogDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'check_in_'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
            // widgets: actionButtons()
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: MyDayLogDetailsView()));
          }),
        ),
      ),
    );
  }

}
