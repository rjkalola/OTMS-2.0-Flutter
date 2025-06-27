import 'package:flutter/material.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class DateFilterOptionsHorizontalList extends StatelessWidget {
  const DateFilterOptionsHorizontalList({super.key, this.listener});

  final DateFilterListener? listener;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DataUtils.dateFilterList.length,
        separatorBuilder: (context, index) => SizedBox(width: 0),
        itemBuilder: (context, index) {
          return CardViewDashboardItem(
              child: GestureDetector(
            onTap: () {
              if (DataUtils.dateFilterList[index] != "Custom") {
                List<DateTime> listDates =
                    DateUtil.getDateWeekRange(DataUtils.dateFilterList[index]);
                String startDate = DateUtil.dateToString(
                    listDates[0], DateUtil.DD_MM_YYYY_SLASH);
                String endDate = DateUtil.dateToString(
                    listDates[1], DateUtil.DD_MM_YYYY_SLASH);
                listener?.onSelectDateFilter(startDate, endDate);
              }
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
              alignment: Alignment.center,
              child: TitleTextView(
                text: DataUtils.dateFilterList[index],
                textAlign: TextAlign.center,
              ),
            ),
          ));
        },
      ),
    );
  }
}
