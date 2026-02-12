import 'package:belcka/pages/payment_documents/payment_details/controller/payment_details_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final controller = Get.put(PaymentDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.paymentsInfo.value.weekRange ?? "",
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          // controller.getTeamListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    getDetailRow(
                                        'gross_amount'.tr,
                                        getValue(controller
                                            .paymentsInfo.value.grossAmount)),
                                    getDetailRow(
                                        'cis_amount'.tr,
                                        !StringHelper.isEmptyString(getValue(
                                                controller.paymentsInfo.value
                                                    .cisAmount))
                                            ? "-${getValue(controller.paymentsInfo.value.cisAmount)}"
                                            : "",
                                        fontColor: Colors.red),
                                    getDetailRow(
                                        'net_timesheet'.tr,
                                        getValue(controller.paymentsInfo.value
                                            .netTimeclockAmount)),
                                    getDetailRow(
                                        'net_price_work'.tr,
                                        getValue(controller.paymentsInfo.value
                                            .netPriceworkAmount)),
                                    getDetailRow(
                                        'penalty_amount'.tr,
                                        !StringHelper.isEmptyString(getValue(
                                                controller.paymentsInfo.value
                                                    .netPenaltyAmount))
                                            ? "-${getValue(controller.paymentsInfo.value.netPenaltyAmount)}"
                                            : "",
                                        fontColor: Colors.red),
                                    getDetailRow(
                                        'expense_amount'.tr,
                                        getValue(controller.paymentsInfo.value
                                            .netExpenseAmount)),
                                    getDetailRow(
                                        'paid_leave'.tr,
                                        getValue(controller.paymentsInfo.value
                                            .netPaidLeaveAmount)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Divider(
                                        thickness: 2,
                                        color: dividerColor_(context),
                                      ),
                                    ),
                                    getDetailRow(
                                        'total_paid'.tr,
                                        getValue(controller.paymentsInfo.value
                                            .totalPayableAmount),
                                        fontWeight: FontWeight.w600),
                                  ],
                                ),
                              ),
                            ),
                            // PrimaryButton(
                            //     padding: EdgeInsets.all(20),
                            //     buttonText: 'delete'.tr,
                            //     onPressed: () {
                            //       controller.showDeleteTeamDialog();
                            //     })
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  String getValue(String? value) {
    return value != null && value != "0"
        ? "${controller.currency.value}${value ?? ""}"
        : "";
  }

  Widget getDetailRow(String? title, String? value,
      {double? fontSize, Color? fontColor, FontWeight? fontWeight}) {
    return !StringHelper.isEmptyString(value)
        ? Padding(
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: TitleTextView(
                      text: title ?? "",
                      fontSize: fontSize ?? 18,
                      fontWeight: fontWeight ?? FontWeight.w400),
                ),
                Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: TitleTextView(
                      text: value ?? "",
                      textAlign: TextAlign.end,
                      fontSize: fontSize ?? 18,
                      fontWeight: fontWeight ?? FontWeight.w400,
                      color: fontColor ?? Colors.green,
                    ))
              ],
            ),
          )
        : Container();
  }
}
