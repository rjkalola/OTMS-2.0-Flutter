import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:belcka/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:belcka/pages/teams/create_team/view/widgets/member_limit_textfield.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class TradeWiseMaxMembersList extends StatelessWidget {
  TradeWiseMaxMembersList({super.key});

  final controller = Get.put(CreateTeamController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextView(
              text: 'trade_wise_max_members'.tr,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 8),
            if (controller.tradeMaxLimitFields.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.tradeMaxLimitFields.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = controller.tradeMaxLimitFields[index];
                  return Container(
                    padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: backgroundColor_(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.30),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryTextView(
                            text: item.tradeName,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ), 
                        ),
                        SizedBox(
                          width: 180,
                          child: MemberLimitTextField(
                            controller: item.controller,
                            hintText: 'max'.tr,
                            onChanged: (value) =>
                                controller.onTradeLimitChanged(index, value),
                            onIncrementTap: () =>
                                controller.incrementTradeLimit(index),
                            onDecrementTap: () =>
                                controller.decrementTradeLimit(index),
                            height: 38,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
