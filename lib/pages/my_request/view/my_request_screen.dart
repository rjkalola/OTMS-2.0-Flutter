import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/my_request/controller/my_request_controller.dart';
import 'package:otm_inventory/pages/my_request/view/widgets/my_request_list.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final controller = Get.put(MyRequestController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'my_requests'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor,
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
                          // controller.getTeamListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            MyRequestList()
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }

}
