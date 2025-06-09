import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/teams/sub_contractor_details/controller/sub_contractor_details_controller.dart';
import 'package:otm_inventory/pages/teams/sub_contractor_details/view/widgets/info_tile.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SubContractorDetailsScreen extends StatefulWidget {
  const SubContractorDetailsScreen({super.key});

  @override
  State<SubContractorDetailsScreen> createState() =>
      _SubContractorDetailsScreenState();
}

class _SubContractorDetailsScreenState
    extends State<SubContractorDetailsScreen> {
  final controller = Get.put(SubContractorDetailsController());

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
            title: 'sub_contractor_details'.tr,
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
                            Divider(),
                            InfoTile(
                                title: 'company_name'.tr,
                                value: "Stypix Solution",
                                iconData: Icons.business),
                            InfoTile(
                                title: 'company_admin'.tr,
                                value: "Harvi Jivani",
                                iconData: Icons.person),
                            InfoTile(
                                title: 'phone_number'.tr,
                                value: "+91 9988776543",
                                iconData: Icons.phone),
                            InfoTile(
                                title: 'email'.tr,
                                value: "stypixsolution@gmail.com",
                                iconData: Icons.email)
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
