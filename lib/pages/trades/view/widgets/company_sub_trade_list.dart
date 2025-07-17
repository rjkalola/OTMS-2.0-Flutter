import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/trades/controller/trades_controller.dart';
import 'package:otm_inventory/pages/trades/model/trade_info.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class CompanySubTradeList extends StatelessWidget {
  CompanySubTradeList({super.key, required this.parentPosition});

  final controller = Get.put(TradesController());
  final int parentPosition;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          TradeInfo info =
              controller.companyTradesList[parentPosition].trades![position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextView(
                  text: info.name,
                  color: primaryTextColor_(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                CustomSwitch(
                    onValueChange: (value) {
                      print("value:" + value.toString());
                      info.status = !info.status!;
                      controller.companyTradesList.refresh();
                      controller.isDataUpdated.value = true;
                      controller.checkSelectAll();
                      // controller.changeCompanyTradeStatusApi(
                      //     info.id ?? 0, value);
                    },
                    mValue: info.status)
              ],
            ),
          );
        },
        itemCount: controller.companyTradesList[parentPosition].trades!.length,
        separatorBuilder: (context, position) => Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Divider(
                height: 0,
                color: dividerColor_(context),
                thickness: 1,
              ),
            )));
  }
}
