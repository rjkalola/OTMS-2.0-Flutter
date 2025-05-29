import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/trades/controller/trades_controller.dart';
import 'package:otm_inventory/pages/trades/view/widgets/company_sub_trade_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class CompanyTradeList extends StatelessWidget {
  CompanyTradeList({super.key});

  final controller = Get.put(TradesController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryTextView(
                              text:
                                  controller.companyTradesList[position].name ??
                                      "",
                              color: primaryTextColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 26,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Divider(
                          height: 0,
                          color: dividerColor,
                          thickness: 2,
                        ),
                      ),
                      CompanySubTradeList(parentPosition: position),
                    ],
                  ),
                );
              },
              itemCount: controller.companyTradesList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
