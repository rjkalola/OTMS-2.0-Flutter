import 'package:belcka/pages/payment_documents/add_invoice/model/invoice_info.dart';
import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class InvoiceList extends StatelessWidget {
  InvoiceList({super.key, required this.parentPosition});

  final controller = Get.put(PaymentDocumentsController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            InvoiceInfo info =
                controller.listInvoices[parentPosition].data![position];
            return CardViewDashboardItem(
                margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: GestureDetector(
                  onTap: () {
                    var arguments = {
                      AppConstants.intentKey.checkLogId: info.id ?? 0,
                    };
                    controller.moveToScreen(
                        AppRoutes.checkOutScreen, arguments);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          children: [
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            )
                          ],
                        ),
                        SizedBox(height: 4,),
                        Divider(
                          color: dividerColor_(context),
                        ),
                        SizedBox(height: 4,),
                        getDetailRow('invoice_date'.tr, info.invoiceDate),
                        getDetailRow('invoice_number'.tr, info.invoiceNumber),
                        getDetailRow('description'.tr, info.description)
                      ],
                    ),
                  ),
                ));
          },
          itemCount: controller.listInvoices[parentPosition].data!.length,
          // separatorBuilder: (context, position) => const Padding(
          //   padding: EdgeInsets.only(left: 100),
          //   child: Divider(
          //     height: 0,
          //     color: dividerColor,
          //     thickness: 0.8,
          //   ),
          // ),
          separatorBuilder: (context, position) => Container()),
    );
  }

  Widget getDetailRow(String? title, String? value) {
    return !StringHelper.isEmptyString(value)
        ? Padding(
          padding: const EdgeInsets.only(top: 3,bottom: 3),
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
