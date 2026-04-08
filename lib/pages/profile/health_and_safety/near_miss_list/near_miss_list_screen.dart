import 'package:belcka/pages/profile/health_and_safety/near_miss_list/controller/near_miss_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/near_miss_list/view/near_miss_list_widget.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NearMissListScreen extends StatefulWidget {
  const NearMissListScreen({super.key});

  @override
  State<NearMissListScreen> createState() => _NearMissListScreenState();
}

class _NearMissListScreenState extends State<NearMissListScreen> {
  final controller = Get.put(NearMissListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
          () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: OrdersBaseAppBar(
                appBar: AppBar(),
                title: 'near_miss_reporting'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                widgets: actionButtons(),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                  },
                )
                    : controller.isMainViewVisible.value
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: NearMissListWidget(),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: (){
          controller.moveToScreen(AppRoutes.nearMissReportingScreen, null);
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.add,
            color: primaryTextColor_(context) ,
            size: 25,
          ),
        ),
      ),
      SizedBox(width: 8,),
    ];
  }
}