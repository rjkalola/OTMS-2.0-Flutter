import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:belcka/pages/permissions/company_permissions/view/widgets/company_permissions_list.dart';
import 'package:belcka/pages/permissions/company_permissions/view/widgets/search_company_permission.dart';
import 'package:belcka/pages/permissions/company_permissions/view/widgets/select_all_text.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/utils/app_utils.dart';
class CompanyPermissionScreen extends StatefulWidget {
  const CompanyPermissionScreen({super.key});

  @override
  State<CompanyPermissionScreen> createState() =>
      _CompanyPermissionScreenState();
}

class _CompanyPermissionScreenState extends State<CompanyPermissionScreen> {
  final controller = Get.put(CompanyPermissionController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'company_permissions'.tr,
                isCenterTitle: false,
                isBack: true,
                // widgets: actionButtons(),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              body: ModalProgressHUD(
                  inAsyncCall: controller.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: controller.isInternetNotAvailable.value
                      ? NoInternetWidget(
                          onPressed: () {
                            controller.isInternetNotAvailable.value = false;
                            controller.getCompanyPermissionsApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchCompanyPermissionWidget(),
                              SelectAllText(),
                              CompanyPermissionsList()
                            ],
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      TextButton(
        onPressed: () {
          if (controller.isDataUpdated.value) {
            controller.changeCompanyBulkPermissionStatusApi();
          }
        },
        child: PrimaryTextView(
          text: 'save'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: controller.isDataUpdated.value
              ? defaultAccentColor_(context)
              : defaultAccentLightColor_(context),
        ),
      )
    ];
  }
}
