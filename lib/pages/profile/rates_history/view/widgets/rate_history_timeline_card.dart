import 'package:belcka/pages/profile/rates_history/controller/rates_history_controller.dart';
import 'package:belcka/pages/profile/rates_history/model/rates_history_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/app_colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RateHistoryTimelineCard extends StatelessWidget {
  final RatesHistoryInfo item;
  bool? isLast = false;

  RateHistoryTimelineCard({required this.item,required this.isLast});

  final controller = Get.put(RatesHistoryController());

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        // 🔵 Continuous vertical blue line
        Positioned.fill(
          left: 16,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 2,
              color: defaultAccentColor_(context),
            ),
          ),
        ),
        // Vertical line
        Positioned(
          left: 16,
          top: 0,
          bottom: isLast == false ? 40 : 0,
          child: Container(
            width: 2,
            color: defaultAccentColor_(context),
          ),
        ),

        // Circle dot
        Positioned(
          left: 9,
          top: 40,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: defaultAccentColor_(context),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Card content
        CardViewDashboardItem(
          margin: const EdgeInsets.only(left: 40, bottom: 24),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Effective date
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: dashBoardBgColor_(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Effective date: ${item.effectiveDate}',
                  style: TextStyle(color: primaryTextColor_(context)),
                ),
              ),
              const SizedBox(height: 12),
              // Title and Amount
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if ((double.tryParse(item.newNetRatePerday ?? "") ?? 0) > 0)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: primaryTextColor_(context), fontSize: 15),
                        children: [
                          const TextSpan(text: 'New Rate: '),
                          TextSpan(
                            text: '${item.currency}${item.newNetRatePerday ?? ""}',
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          TextSpan(text: '/day'),
                        ],
                      ),
                    ),
                  SizedBox(height: 8,),
                  if ((double.tryParse(item.oldNetRatePerday ?? "") ?? 0) > 0)

                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: primaryTextColor_(context), fontSize: 15),
                        children: [
                          const TextSpan(text: 'Old Rate: '),
                          TextSpan(
                            text: '${item.currency}${item.oldNetRatePerday ?? ""}',
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                          TextSpan(text: '/day'),
                        ],
                      ),
                    ),
                ],
              ),
              Divider(height:24,color:lightGreyColor(context)),
              //Divider(height:item.actionBy != null ? 24:0,color:item.actionBy != null ? lightGreyColor(context): Colors.transparent,),
              // Modified info (optional)
              if (item.actionBy != null)
                Text(
                  '${((item.statusText ?? "").toLowerCase()) == "pending" ? "Requested" : item.statusText?.capitalizeFirst} by ${item.actionBy} on ${item.date} at ${item.time}',
                  style: const TextStyle(fontSize: 13),
                ),

              if (item.actionBy == null)
                Text(
                  'Requested by ${item.userName} on ${item.date} at ${item.time}',
                  style: const TextStyle(fontSize: 13),
                ),
            ],
          ),
        ),
      ],
    );
  }
}