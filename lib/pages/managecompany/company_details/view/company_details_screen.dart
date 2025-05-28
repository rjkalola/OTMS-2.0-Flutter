import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/managecompany/company_details//view/widgets/upload_photo_view.dart';
import 'package:otm_inventory/pages/managecompany/company_details/controller/company_details_controller.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/preferred_image_size_view.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/row_phone_number_and_extension.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_address.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_admin.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_code.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_description.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_email.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_established_date.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_name.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_company_website.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_insurance_expiry_date.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_insurance_number.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_main_contracts.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_number_of_employee.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_registration_number.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_vat_number.dart';
import 'package:otm_inventory/pages/managecompany/company_details/view/widgets/text_field_working_hours.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final controller = Get.put(CompanyDetailsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'company_details'.tr,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            Divider(),
                            SizedBox(
                              height: 12,
                            ),
                            Visibility(
                                visible: controller.isMainViewVisible.value,
                                child: Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        UploadPhotoView(),
                                        PreferredImageSizeView(),
                                        TextFieldCompanyName(),
                                        TextFieldCompanyCode(),
                                        TextFieldCompanyAdmin(),
                                        TextFieldCompanyAddress(),
                                        RowPhoneNumberAndExtension(),
                                        TextFieldCompanyEmail(),
                                        TextFieldCompanyWebsite(),
                                        TextFieldCompanyDescription(),
                                        TextFieldRegistrationNumber(),
                                        TextFieldVatNumber(),
                                        TextFieldCompanyEstablishedDate(),
                                        TextFieldMainContracts(),
                                        TextFieldWorkingHours(),
                                        TextFieldInsuranceNumber(),
                                        TextFieldInsuranceExpiryDate(),
                                        TextFieldNumberOfEmployee(),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 10, 16, 14),
                                          width: double.infinity,
                                          child: ContinueButton(
                                              title: 'submit'.tr,
                                              onPressed: () {
                                                controller
                                                    .onClickContinueButton();
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
