import 'package:flutter/material.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class DateFilterMyRequestOptionsHorizontalList extends StatelessWidget {
  const DateFilterMyRequestOptionsHorizontalList({super.key, this.listener});

  final DateFilterListener? listener;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DataUtils.dateFilterListMyRequest.length,
        separatorBuilder: (context, index) => SizedBox(width: 0),
        itemBuilder: (context, index) {
          return CardViewDashboardItem(
              child: GestureDetector(
                onTap: () {
                  List<DateTime> listDates =
                  DateUtil.getMyRequestsDateRange(DataUtils.dateFilterListMyRequest[index]);
                  String startDate = DateUtil.dateToString(
                      listDates[0], DateUtil.DD_MM_YYYY_SLASH);
                  String endDate = DateUtil.dateToString(
                      listDates[1], DateUtil.DD_MM_YYYY_SLASH);
                  listener?.onSelectDateFilter(0,"",startDate, endDate,"");

                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                  alignment: Alignment.center,
                  child: TitleTextView(
                    text: DataUtils.dateFilterListMyRequest[index],
                    textAlign: TextAlign.center,
                  ),
                ),
              ));
        },
      ),
    );
  }
}