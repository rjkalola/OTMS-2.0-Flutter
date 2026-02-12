import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_info.dart';
import 'package:belcka/pages/payment_documents/add_payslip/model/payslip_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class PayslipList extends StatelessWidget {
  PayslipList({super.key, required this.parentPosition});

  final controller = Get.put(PaymentDocumentsController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.listPayslips.isNotEmpty &&
              controller.listPayslips[parentPosition].data != null)
          ? ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                PayslipInfo info =
                    controller.listPayslips[parentPosition].data![position];
                return CardViewDashboardItem(
                    margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                    padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.isDeleteEnable.value ||
                            controller.isDownloadEnable.value) {
                          info.isCheck = !(info.isCheck ?? false);
                          controller.listPayslips.refresh();
                          controller.checkSelectAll();
                        } else {
                          String fileUrl = info.pdf ?? "";
                          await ImageUtils.openAttachment(Get.context!, fileUrl,
                              ImageUtils.getFileType(fileUrl));
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Visibility(
                                  visible: controller.isDeleteEnable.value ||
                                      controller.isDownloadEnable.value,
                                  child: CustomCheckbox(
                                      color: defaultAccentColor_(context),
                                      onValueChange: (value) {
                                        info.isCheck = !(info.isCheck ?? false);
                                        controller.listPayslips.refresh();
                                        controller.checkSelectAll();
                                      },
                                      mValue: info.isCheck ?? false),
                                ),
                                Visibility(
                                    visible: !controller.isDeleteEnable.value &&
                                        !controller.isDownloadEnable.value,
                                    child: SizedBox(
                                      width: 14,
                                    )),
                                UserAvtarView(
                                  imageUrl: info.userThumbImage ?? "",
                                  imageSize: 40,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleTextView(
                                        text: info.userName,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // totalWorkHour(info),
                                Visibility(
                                  visible: !controller.isDeleteEnable.value &&
                                      !controller.isDownloadEnable.value,
                                  child: RightArrowWidget(
                                    color: primaryTextColor_(context),
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              child: Divider(
                                color: dividerColor_(context),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            getDetailRow('period'.tr,
                                "${info.fromDate ?? ""} - ${info.toDate ?? ""}"),
                            getDetailRow('updated_on'.tr, info.date),
                          ],
                        ),
                      ),
                    ));
              },
              itemCount:
                  (controller.listPayslips[parentPosition].data ?? []).length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Container())
          : Container(),
    );
  }

  Widget getDetailRow(String? title, String? value) {
    return !StringHelper.isEmptyString(value)
        ? Padding(
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, left: 14, right: 14),
            child: Row(
              children: [
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: TitleTextView(
                      text: "${title ?? ""}:",
                    )),
                Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: TitleTextView(
                      text: value ?? "",
                      textAlign: TextAlign.end,
                    ))
              ],
            ),
          )
        : Container();
  }
}
