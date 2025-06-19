import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/text/SubTitleTextView.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class BillingHistoryList extends StatelessWidget {
  const BillingHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return CardViewDashboardItem(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TitleTextView(
                      text: "DCK Construction",
                    ),
                  ),
                  TextViewWithContainer(
                    text: "Active",
                    fontColor: Colors.green,
                    borderColor: Colors.green,
                    padding: EdgeInsets.only(left: 12, right: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SubtitleTextView(
                              text: "Trade",
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            TitleTextView(
                              text: "Backend",
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SubtitleTextView(
                              text: "(£) Net Per Day",
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            TitleTextView(
                              text: "180.00",
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  RightArrowWidget()
                ],
              )
            ],
          ));
        },
        itemCount: 3,
        separatorBuilder: (context, position) => Container());
  }
}
