import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/phone_with_extension_field.dart';
import 'package:otm_inventory/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/bank_details_fields_view.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/billing_approval_buttons_view.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/no_billing_request_data_view.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/tax_info_fields_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import '../../../../utils/app_constants.dart';


class BillingRequestScreen extends StatefulWidget {
  const BillingRequestScreen({super.key});

  @override
  State<BillingRequestScreen> createState() => _BillingRequestScreenState();
}

class _BillingRequestScreenState extends State<BillingRequestScreen> {
  final controller = Get.put(BillingRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'billing_info_request'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? Center(
              child: Text("no_internet_text".tr),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: (controller
                    .billingRequestInfo.value.id ?? 0) != 0 ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //profile UI
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    UserAvtarView(
                                      imageSize: 60,
                                      imageUrl: controller
                                          .billingRequestInfo.value.userThumbImage ??
                                          "",
                                    ),
                                    const SizedBox(height: 10),
                                    // Name
                                    Visibility(
                                      visible:(controller.billingRequestInfo.value.name ?? "").isNotEmpty,
                                      child: Text(
                                        controller.billingRequestInfo.value.name ?? "",
                                        style: TextStyle(
                                            fontSize: 24, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Phone
                                    Visibility(
                                      visible:(controller.billingRequestInfo.value.phone ?? "").isNotEmpty,
                                      child: PhoneWithExtensionField(
                                          "${controller.billingRequestInfo.value.extension ?? ""} ${controller.billingRequestInfo.value.phone ?? ""}",
                                          "phone_number".tr),
                                    ),
                                    const SizedBox(height: 10),
                                    // Email
                                    Visibility(
                                      visible:(controller.billingRequestInfo.value.email ?? "").isNotEmpty,
                                      child: PhoneWithExtensionField(
                                          controller.billingRequestInfo.value.email ?? "",
                                          "email".tr),
                                    ),
                                    const SizedBox(height: 10),
                                    // My Address
                                    Visibility(
                                      visible:(controller.billingRequestInfo.value.address ?? "").isNotEmpty,
                                      child: PhoneWithExtensionField(
                                          controller.billingRequestInfo.value.address ?? "",
                                          "my_address".tr),
                                    ),
                                    const SizedBox(height: 10),
                                    // Post code
                                    Visibility(
                                      visible:(controller.billingRequestInfo.value.postCode ?? "").isNotEmpty,
                                      child: PhoneWithExtensionField(
                                          controller.billingRequestInfo.value.postCode ?? "",
                                          "post_code".tr),
                                    ),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: (controller.billingRequestInfo.value.nameOnUtr ?? "").isNotEmpty || (controller.billingRequestInfo.value.utrNumber ?? "").isNotEmpty || (controller.billingRequestInfo.value.ninNumber ?? "").isNotEmpty,
                                  child: TaxInfoFieldsView()),

                              Visibility(
                                visible: (controller.billingRequestInfo.value.nameOnAccount ?? "").isNotEmpty || (controller.billingRequestInfo.value.bankName ?? "").isNotEmpty || (controller.billingRequestInfo.value.accountNo ?? "").isNotEmpty || (controller.billingRequestInfo.value.shortCode ?? "").isNotEmpty,
                                  child: BankDetailsFieldsView()),
                            ],
                          )
                          ),
                        ),
                        BillingApprovalButtonsView()
                      ],
                    ) : NoBillingRequestDataView()),
          ),
        ),
      ),
    ),);
  }
}