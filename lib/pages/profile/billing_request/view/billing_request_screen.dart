import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/bank_details_view.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/no_billing_data_view.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/phone_with_extension_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/tax_info_view.dart';
import 'package:otm_inventory/pages/profile/billing_request/controller/billing_request_controller.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/billing_approval_buttons_view.dart';
import 'package:otm_inventory/pages/profile/billing_request/view/widgets/no_billing_request_data_view.dart';
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
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'Billing Info Request'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor,
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? const Center(
              child: Text("No Internet"),
            )
                : Visibility(
                visible: controller.isMainViewVisible.value,
                child: (controller
                    .billingInfo.value.id ?? 0) != 0 ? Column(
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
                                          .billingInfo.value.userThumbImage ??
                                          "",
                                    ),
                                    const SizedBox(height: 10),
                                    // Name
                                    Text(
                                      controller.billingInfo.value.name ?? "",
                                      style: TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    // Phone
                                    PhoneWithExtensionField(
                                        "${controller.billingInfo.value.extension ?? ""} ${controller.billingInfo.value.phone ?? ""}",
                                        "Phone number"),
                                    const SizedBox(height: 10),
                                    // Email
                                    PhoneWithExtensionField(
                                        controller.billingInfo.value.email ?? "",
                                        "Email"),
                                    const SizedBox(height: 10),
                                    // My Address
                                    PhoneWithExtensionField(
                                        controller.billingInfo.value.address ?? "",
                                        "My Address"),
                                    const SizedBox(height: 10),
                                    // Post code
                                    PhoneWithExtensionField(
                                        controller.billingInfo.value.postCode ?? "",
                                        "Post Code"),
                                  ],
                                ),
                              ),
                              TaxInfoView(),
                              BankDetailsView(),
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