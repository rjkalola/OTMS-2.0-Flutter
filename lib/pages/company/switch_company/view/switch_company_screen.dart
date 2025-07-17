import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/company/switch_company/controller/switch_company_controller.dart';
import 'package:otm_inventory/pages/company/switch_company/view/widgets/company_list.dart';
import 'package:otm_inventory/pages/company/switch_company/view/widgets/search_company.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SwitchCompanyScreen extends StatefulWidget {
  const SwitchCompanyScreen({super.key});

  @override
  State<SwitchCompanyScreen> createState() => _SwitchCompanyScreenState();
}

class _SwitchCompanyScreenState extends State<SwitchCompanyScreen> {
  final controller = Get.put(SwitchCompanyController());

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
            title: 'switch_company'.tr,
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
                          controller.getSwitchCompanyListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [Divider(), SearchCompany(), CompanyList()],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
