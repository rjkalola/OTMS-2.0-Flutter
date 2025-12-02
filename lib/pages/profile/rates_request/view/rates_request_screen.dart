import 'package:belcka/pages/profile/rates/view/widgets/rate_request_pending_for_approval.dart';
import 'package:belcka/pages/profile/rates_request/view/widgets/add_note_field_widget.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/buttons/approve_reject_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/rates_request/controller/rates_request_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
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
              title: "rate_request".tr,
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
                  : Form(
                    key: controller.formKey,
                    child: Visibility(
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
                            Divider(height: 8),
                            SizedBox(height: 16),
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
                            Divider(height: 8),
                            SizedBox(height: 16),
                            // Net rate per day
                            Text(
                                "(£)${'net_per_day'.tr}",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              controller.netPerDayController.value.text ?? "",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Divider(height: 8),
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
                            (UserUtils.isAdmin() && (controller.rateRequestInfo.value.statusText == "pending" && controller.rateRequestInfo.value.is_show == true)) ?
                            Visibility(
                              visible: controller.isShowSaveButton.value,
                              child: Column(
                                spacing: 8,
                                children: [
                                  AddNoteFieldWidget(
                                      controller: controller.noteController,
                                  isReadOnly: false,),
                                  ApproveRejectButtons(
                                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                                      onClickApprove: (){
                                        controller.showActionDialog(
                                            AppConstants
                                                .dialogIdentifier
                                                .approve);
                                      },
                                      onClickReject: () {
                                        if (controller.valid()) {
                                          controller.showActionDialog(
                                              AppConstants
                                                  .dialogIdentifier.reject);
                                        }
                                      }),
                                ],
                              ),
                            ) : Visibility(
                              visible: (controller.rateRequestInfo.value.statusText == "pending" && controller.rateRequestInfo.value.is_show == true) ? true : false,
                                child: RateRequestPendingForApproval())
                          ],
                        ),
                      )),
                    ),
                  ),
            ),
            // This is where bottomNavigationBar should go
          ),
        ),
      )
      ),
    );
  }
}
