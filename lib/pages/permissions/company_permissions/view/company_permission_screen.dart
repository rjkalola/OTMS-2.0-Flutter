import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/view/widgets/company_permissions_list.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/view/widgets/search_company_permission.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/view/widgets/select_all_text.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: backgroundColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
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
              ? defaultAccentColor
              : defaultAccentLightColor,
        ),
      )
    ];
  }
}
