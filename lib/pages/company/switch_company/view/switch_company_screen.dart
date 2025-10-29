import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/company/switch_company/controller/switch_company_controller.dart';
import 'package:belcka/pages/company/switch_company/view/widgets/company_list.dart';
import 'package:belcka/pages/company/switch_company/view/widgets/search_company.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';

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
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'switch_company'.tr,
                isCenterTitle: false,
                isBack: false,
                onBackPressed: (){
                  controller.onBackPress();
                },
                bgColor: dashBoardBgColor_(context),
                widgets: actionButtons(),
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
                              children: [
                                Divider(),
                                SearchCompany(),
                                CompanyList()
                              ],
                            ),
                          ));
              }),
            ),
          ),
        ));
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: true,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}
