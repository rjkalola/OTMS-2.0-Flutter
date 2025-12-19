import 'package:belcka/pages/profile/rates/view/widgets/rate_request_pending_for_approval.dart';
import 'package:belcka/pages/profile/rates/view/widgets/trade_view.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/pages/profile/rates/view/widgets/netPer_text_field.dart';
import 'package:belcka/pages/profile/rates/view/widgets/trade_select_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  final controller = Get.put(RatesController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
            color: dashBoardBgColor_(context),
            child: SafeArea(
              child: Scaffold(
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: "edit_rate".tr,
                  isCenterTitle: false,
                  bgColor: dashBoardBgColor_(context),
                  isBack: true,
                  onBackPressed: () {
                    controller.onBackPress();
                  },
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
                                // Trade field
                                SizedBox(height: 16),
                                Visibility(
                                    visible: UserUtils.isAdmin(),
                                    child:  (controller.isRateRequested.value) ? TradeView() : TradeSelectView()),
                                Visibility(
                                    visible: !UserUtils.isAdmin(),
                                    child: TradeView()),
                                // Join company date
                                Text(
                                  "join_company_date".tr,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.joiningDate,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                Divider(height: 10),
                                SizedBox(height: 16),
                                NetPerDayTextField(),
                                SizedBox(height: 16),
                                // Gross per day and CIS row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "gross_per_day".tr,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "${controller.billingInfo.value.currency}${controller.grossPerDay.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${'cis'.tr} 20%",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "${controller.billingInfo.value.currency}${controller.cis.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                // Rate history link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      var arguments = {
                                        AppConstants.intentKey.userId:
                                            controller.billingInfo.value.userId ??
                                                UserUtils.getLoginUserId(),
                                      };
                                      Get.toNamed(AppRoutes.ratesHistoryScreen,
                                          arguments: arguments);
                                    },
                                    child: Text(
                                      'rate_history'.tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Obx(() {
                                  if (controller.isRateRequested.value) {
                                    return RateRequestPendingForApproval();
                                  }
                                  if (!controller.isShowSaveButton.value) {
                                    return SizedBox.shrink();
                                  }
                                  final enabled = controller.isSaveEnabled.value;
                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Opacity(
                                      opacity: enabled ? 1.0 : 0.4,
                                      child: ElevatedButton(
                                        onPressed: enabled
                                            ? () {
                                                FocusScope.of(context).unfocus();
                                                controller.showActionDialog(
                                                    AppConstants.dialogIdentifier
                                                        .approve);
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              defaultAccentColor_(context),
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          'send'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )),
                      ),
                ),
                // This is where bottomNavigationBar should go
              ),
            ),
          )),
    );
  }
}
