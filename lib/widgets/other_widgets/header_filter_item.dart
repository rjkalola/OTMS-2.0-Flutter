import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderFilterItem extends StatelessWidget {
  final String title;
  final int? count;
  final bool selected;
  final int? flex;
  final GestureTapCallback? onTap;

  HeaderFilterItem({
    super.key,
    required this.title,
    required this.selected,
    this.count,
    this.flex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex ?? 1,
      child: Stack(
        children: [
          CardViewDashboardItem(
              borderColor: selected
                  ? defaultAccentColor_(context)
                  : Colors.transparent,
              boxColor: lightGreyColor(context),
              borderWidth: 2,
              elevation: 2,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  alignment: Alignment.center,
                  child: TitleTextView(
                    text: title,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor_(context),
                  ),
                ),
              )),
          Visibility(
            visible: (count ?? 0) != 0,
            child: Align(
              alignment: Alignment.topRight,
              child: CustomBadgeIcon(
                count: count ?? 0,
                color: defaultAccentColor_(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
