import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/info_card.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/navigation_card.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/no_billing_data_view.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/pending_for_approval_view.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/tax_info_view.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/bank_details_view.dart';
import 'package:otm_inventory/pages/profile/billing_details_new/view/widgets/phone_with_extension_field.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import '../../../../utils/app_constants.dart';
import '../controller/billing_details_new_controller.dart';

class BillingDetailsNewScreen extends StatefulWidget {
  const BillingDetailsNewScreen({super.key});

  @override
  State<BillingDetailsNewScreen> createState() => _BillingDetailsNewScreenState();
}

class _BillingDetailsNewScreenState extends State<BillingDetailsNewScreen> {
  final controller = Get.put(BillingDetailsNewController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "",
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
            widgets: actionButtons(),
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
                                    InfoCard(label: "Phone number", value:"${controller.billingInfo.value.extension ?? ""} ${controller.billingInfo.value.phone ?? ""}", isLink: true),
                                    InfoCard(label: "Email", value: controller.billingInfo.value.email ?? "", isLink: true),
                                    NavigationCard(value: controller.billingInfo.value.address ?? ""),
                                    NavigationCard(label: "TAX info", value: "${controller.billingInfo.value.utrNumber ?? ""} / ${controller.billingInfo.value.ninNumber ?? ""}"),
                                    NavigationCard(label: "Bank Details", value: "${controller.billingInfo.value.shortCode ?? ""} / ${controller.billingInfo.value.accountNo ?? ""}"),
                                    NavigationCard(label: "Rates", value: controller.billingInfo.value.net_rate_perDay != null
                                        ? "${controller.billingInfo.value.trade ?? ""} - ${controller.billingInfo.value.currency ?? ""}${controller.billingInfo.value.net_rate_perDay}"
                                        : "${controller.billingInfo.value.trade ?? ""}",),
                                    Divider(height: 32),
                                    NavigationCard(value: "Payslips"),
                                    NavigationCard(value: "Payment"),
                                    NavigationCard(value: "Invoice"),
                                  ],
                                ),
                              ),
                            ],
                          )),
                        ),
                        Visibility(
                          visible: (controller.billingInfo.value.statusText ?? "") == "pending",
                          child: PendingForApprovalView(),
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
            backgroundColor: blueBGButtonColor,
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


