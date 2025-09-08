import 'package:belcka/pages/profile/rates_request/view/widgets/rate_request_pending_for_approval.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/pages/profile/rates/view/widgets/netPer_text_field.dart';
import 'package:belcka/pages/profile/rates/view/widgets/trade_select_view.dart';
import 'package:belcka/pages/profile/rates_request/controller/rates_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class RatesRequestScreen extends StatefulWidget {
  const RatesRequestScreen({super.key});

  @override
  State<RatesRequestScreen> createState() => _RatesRequestScreenState();
}

class _RatesRequestScreenState extends State<RatesRequestScreen> {
  final controller = Get.put(RatesRequestController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "rate_request".tr,
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
                  child: SingleChildScrollView(
                  child: CardViewDashboardItem(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "rates".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Trade field
                        Text(
                          "trade".tr,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${controller.tradeName}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Divider(height: 24),
                        // Join company date
                        Text(
                          "join_company_date".tr,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${controller.joiningDate}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Divider(height: 24),
                        NetPerDayTextField(
                          controller: controller.netPerDayController,
                          isEnabled: false,
                        ),
                        SizedBox(height: 16),
                        // Gross per day and CIS row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "gross_per_day".tr,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${controller.rateRequestInfo.value.currency ?? ""}${controller.grossPerDay.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${'cis'.tr} 20%",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${controller.rateRequestInfo.value.currency ?? ""}${controller.cis.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        // Rate history link
                        /*
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "rate_history".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24,),
                                */
                        (UserUtils.isAdmin()) ?
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.infinity, 45),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.zero, // important!
                                ),
                                onPressed: () {
                                  controller.rejectRequest("");
                                },
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16), // Gap between buttons
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.infinity, 45),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.zero, // important!
                                ),
                                onPressed: () {
                                  controller.approveRequest();
                                },
                                child: const Text(
                                  "Approve",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ) : RateRequestPendingForApproval()
                      ],
                    ),
                  )),
                ),
          ),
          // This is where bottomNavigationBar should go
        ),
      ),
    )
    );
  }
}
