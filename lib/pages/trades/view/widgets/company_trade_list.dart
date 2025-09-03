import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/trades/controller/trades_controller.dart';
import 'package:belcka/pages/trades/view/widgets/company_sub_trade_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

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
                      GestureDetector(
                        onTap: () {
                          controller.companyTradesList[position].isExpanded =
                              !(controller
                                      .companyTradesList[position].isExpanded ??
                                  false);
                          controller.companyTradesList.refresh();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PrimaryTextView(
                                text: controller
                                        .companyTradesList[position].name ??
                                    "",
                                color: primaryTextColor_(context),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              !(controller.companyTradesList[position]
                                          .isExpanded ??
                                      false)
                                  ? Icon(
                                      Icons.keyboard_arrow_up_outlined,
                                      size: 26,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 26,
                                    )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 0,
                        color: dividerColor_(context),
                        thickness: 2,
                      ),
                      Visibility(
                          visible: !(controller
                                  .companyTradesList[position].isExpanded ??
                              false),
                          child: CompanySubTradeList(parentPosition: position)),
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
