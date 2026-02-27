import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/payment_documents/payment_documents/model/payments_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/user_utils.dart';

class PaymentsList extends StatelessWidget {
  PaymentsList({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: controller.listPayments.isNotEmpty
            ? ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  PaymentsInfo info = controller.listPayments[position];
                  return CardViewDashboardItem(
                      margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                      child: GestureDetector(
                        onTap: () {
                          var arguments = {
                            AppConstants.intentKey.paymentsInfo: info,
                          };
                          controller.moveToScreen(
                              AppRoutes.paymentDetailsScreen, arguments);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 14,
                                  ),
                                  UserAvtarView(
                                    imageUrl: info.userThumbImage ?? "",
                                    imageSize: 36,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                  RightArrowWidget(
                                    color: primaryTextColor_(context),
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
                              getDetailRow(info.weekRange ?? "",
                                  "${info.currency ?? ""}${info.totalPayableAmount ?? ""}"),
                            ],
                          ),
                        ),
                      ));
                },
                itemCount: controller.listPayments.length,
                // separatorBuilder: (context, position) => const Padding(
                //   padding: EdgeInsets.only(left: 100),
                //   child: Divider(x
                //     height: 0,
                //     color: dividerColor,
                //     thickness: 0.8,
                //   ),
                // ),
                separatorBuilder: (context, position) => Container())
            : Center(child: NoDataFoundWidget()),
      ),
    );
  }

  Widget getDetailRow(String? title, String? value) {
    return !StringHelper.isEmptyString(value)
        ? Padding(
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, left: 14, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleTextView(
                  text: "${title ?? ""}",
                ),
                TitleTextView(
                  text: value ?? "",
                  textAlign: TextAlign.end,
                )
              ],
            ),
          )
        : Container();
  }
}
