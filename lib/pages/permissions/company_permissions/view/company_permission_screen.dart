import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/company/company_details//view/widgets/upload_photo_view.dart';
import 'package:otm_inventory/pages/company/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/preferred_image_size_view.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/row_phone_number_and_extension.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_address.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_admin.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_code.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_description.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_email.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_established_date.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_name.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_company_website.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_insurance_expiry_date.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_insurance_number.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_main_contracts.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_number_of_employee.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_registration_number.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_vat_number.dart';
import 'package:otm_inventory/pages/company/company_details/view/widgets/text_field_working_hours.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/view/widgets/company_permissions_list.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/view/widgets/search_company_permission.dart';
import 'package:otm_inventory/pages/trades/controller/trades_controller.dart';
import 'package:otm_inventory/pages/trades/view/widgets/company_trade_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

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
        // if (didPop && result == null) {
        controller.onBackPress();
        // }
        // Get.back(result: controller.isDataUpdated.value);
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'permissions'.tr,
              isCenterTitle: false,
              isBack: true,
              onBackPressed: () {
                controller.onBackPress();
                // Get.back(result: controller.isDataUpdated.value);
              },
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
                            controller.getCompanyPermissionsApi();
                          },
                        )
                      : Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Column(
                            children: [
                              Divider(),
                              SearchCompanyPermissionWidget(),
                              CompanyPermissionsList()
                            ],
                          ),
                        ));
            }),
          ),
        ),
      ),
    );
  }
}
