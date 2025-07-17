import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/bank_details_view.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/no_billing_data_view.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/phone_with_extension_field.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/tax_info_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';

import '../../../../utils/app_constants.dart';
import '../controller/billing_details_controller.dart';

class BillingDetailsScreen extends StatefulWidget {
  const BillingDetailsScreen({super.key});

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  final controller = Get.put(BillingDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'billing_info'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
            widgets: actionButtons(),
          ),
          backgroundColor: dashBoardBgColor_(context),
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

                          )),
                        ),

                        Visibility(
                          visible: (controller.billingInfo.value.statusText ?? "") == "pending",
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Billing information submission is pending for approval.",
                                style:
                                TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ) ,
                          ),
                        )
                      ],
                    ) : NoBillingDataView()),
          ),
        ),
      ),
    ),);
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: (controller.billingInfo.value.id ?? 0) != 0 &&
          (controller.billingInfo.value.statusText ?? "") != "pending",
          child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: ElevatedButton(
          onPressed: () {
            {
              var arguments = {
                AppConstants.intentKey.billingInfo: controller.billingInfo.value,
              };
              controller.moveToScreen(AppRoutes.billingInfoScreen, arguments);
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(126, 42),
            backgroundColor: defaultAccentColor_(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Text('edit'.tr, style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      ))
    ];
  }
}
