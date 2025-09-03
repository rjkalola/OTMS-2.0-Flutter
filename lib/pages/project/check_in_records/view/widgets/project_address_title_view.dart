import 'package:flutter/material.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class ProjectAddressTitleView extends StatelessWidget {
  const ProjectAddressTitleView({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
        borderRadius: 16,
        child: SizedBox(
          width: double.infinity,
          child: PrimaryTextView(
            text: title??"",
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
