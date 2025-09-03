import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/teams/sub_contractor_details/controller/sub_contractor_details_controller.dart';
import 'package:belcka/pages/teams/sub_contractor_details/view/widgets/company_logo.dart';
import 'package:belcka/pages/teams/sub_contractor_details/view/widgets/info_tile.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/utils/app_utils.dart';
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
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'sub_contractor_details'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
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
                            CompanyLogo(),
                            InfoTile(
                                title: 'company_name'.tr,
                                value: controller
                                        .subContractorInfo.value.companyName ??
                                    "-",
                                iconData: Icons.business),
                            InfoTile(
                                title: 'company_admin'.tr,
                                value: controller
                                        .subContractorInfo.value.companyAdmin ??
                                    "-",
                                iconData: Icons.person),
                            InfoTile(
                              title: 'phone_number'.tr,
                              value: controller.subContractorInfo.value.phone ??
                                  "-",
                              iconData: Icons.phone,
                              isCopyIconVisible: true,
                            ),
                            InfoTile(
                                title: 'email'.tr,
                                value:
                                    controller.subContractorInfo.value.email ??
                                        "-",
                                iconData: Icons.email,
                                isCopyIconVisible: true)
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
