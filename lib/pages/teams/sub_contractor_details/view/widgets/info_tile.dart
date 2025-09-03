import 'package:flutter/material.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class InfoTile extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  final bool? isCopyIconVisible;

  const InfoTile(
      {required this.title,
      required this.value,
      required this.iconData,
      this.isCopyIconVisible});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      borderRadius: 16,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // elevation: 2,
      child: ListTile(
        title: TitleTextView(
          text: title,
        ),
        subtitle: SubtitleTextView(
          text: value,
        ),
        leading: Icon(iconData),
        trailing: Visibility(
          visible: isCopyIconVisible ?? false,
          child: GestureDetector(
            onTap: () {
              AppUtils.copyText(value);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 2, 0, 2), // adds a tappable area
              child: Icon(Icons.copy,size: 22,),
            ),
          ),
        ),
      ),
    );
  }
}
