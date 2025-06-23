import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details/view/widgets/bank_details_view.dart';
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
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'billing_info'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
            widgets: actionButtons(),
          ),
          backgroundColor: dashBoardBgColor,
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? const Center(
                      child: Text("No Internet"),
                    )
                  : SingleChildScrollView(
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
                              // Address navigation box
                              GestureDetector(
                                onTap: () {
                                  // Navigate to address screen
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 4, color: Colors.black12)
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "My Address & Post Code",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 18, color: Colors.grey[600]),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        TaxInfoView(),
                        BankDetailsView(),
                      ],
                    )),
            );
          }),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      PrimaryButton(
          buttonText: 'edit'.tr,
          onPressed: () {
            var arguments = {
              AppConstants.intentKey.billingInfo: controller.billingInfo.value,
            };
            controller.moveToScreen(AppRoutes.billingInfoScreen, arguments);
          })
    ];
  }
}
