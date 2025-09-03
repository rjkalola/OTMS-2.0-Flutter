import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/profile/billing_info/view/widgets/tax_info_view.dart';
import 'package:belcka/pages/profile/rates/controller/rates_controller.dart';
import 'package:belcka/pages/profile/rates/view/widgets/netPer_text_field.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  final controller = Get.put(RatesController());

  KeyboardActionsConfig _buildKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: controller.focusNode,
          toolbarButtons: [
                (node) => TextButton(
              onPressed: () => node.unfocus(),
              child: Text(
                'done'.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "edit_rate".tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: KeyboardActions(
              config: _buildKeyboardConfig(),
              child: Obx(
                    () {
                  return ModalProgressHUD(
                    inAsyncCall: controller.isLoading.value,
                    opacity: 0,
                    progressIndicator: const CustomProgressbar(),
                    child: controller.isInternetNotAvailable.value
                        ? Center(
                      child: Text("no_internet_text".tr),
                    )
                        : SingleChildScrollView(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "trade".tr,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Text(
                                        "${controller.billingInfo.value.tradeName}",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      //Icon(Icons.chevron_right, size: 20),
                                    ],
                                  ),
                                ],
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
                                    "${controller.billingInfo.value.currency}${controller.grossPerDay.toStringAsFixed(2)}",
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
                                    "${controller.billingInfo.value.currency}${controller.cis.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Rate history link
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
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.onSubmit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: defaultAccentColor_(context),
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text('send'.tr,
                                      style: TextStyle(
                                          color:backgroundColor_(context),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )),
                  );
                },
              )),
          // This is where bottomNavigationBar should go
          /*
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultAccentColor_(context),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('save'.tr,
                    style: TextStyle(
                        color:backgroundColor_(context),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          */
        ),
      ),
    );
  }
}
