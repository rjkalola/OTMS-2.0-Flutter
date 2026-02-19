import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/listener/select_date_range_listener.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class DateFilterOptionsWithAllHorizontalList extends StatelessWidget
    implements SelectDateRangeListener {
  const DateFilterOptionsWithAllHorizontalList(
      {super.key,
      this.listener,
      this.padding,
      this.startDate,
      this.endDate,
      required this.selectedPosition});

  final DateFilterListener? listener;
  final EdgeInsetsGeometry? padding;
  final String? startDate, endDate;
  final RxInt selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DataUtils.dateFilterListWithAll.length,
        separatorBuilder: (context, index) => SizedBox(width: 0),
        itemBuilder: (context, index) {
          return Obx(
            () => CardViewDashboardItem(
                borderColor: (selectedPosition.value == index &&
                        selectedPosition.value != -1 &&
                        selectedPosition.value != 0)
                    ? defaultAccentColor_(context)
                    : Colors.transparent,
                boxColor: backgroundColor_(context),
                child: GestureDetector(
                  onTap: () {
                    selectedPosition.value = index;
                    if (DataUtils.dateFilterListWithAll[index] == "Custom") {
                      DateTime? startDateTime =
                          !StringHelper.isEmptyString(startDate)
                              ? DateUtil.stringToDate(
                                  startDate!, DateUtil.DD_MM_YYYY_SLASH)
                              : null;
                      DateTime? endDateTime =
                          !StringHelper.isEmptyString(endDate)
                              ? DateUtil.stringToDate(
                                  endDate!, DateUtil.DD_MM_YYYY_SLASH)
                              : null;
                      showDateRangePickerDialog("", startDateTime, endDateTime,
                          DateTime(1900), DateTime(2100));
                    } else if (DataUtils.dateFilterListWithAll[index] ==
                        "Reset") {
                      listener?.onSelectDateFilter(index,
                          DataUtils.dateFilterListWithAll[index], "", "", "");
                    } else if (DataUtils.dateFilterListWithAll[index] ==
                        "All") {
                      listener?.onSelectDateFilter(index,
                          DataUtils.dateFilterListWithAll[index], "", "", "");
                    } else {
                      List<DateTime> listDates = DateUtil.getDateWeekRange(
                          DataUtils.dateFilterListWithAll[index]);
                      String startDate = DateUtil.dateToString(
                          listDates[0], DateUtil.DD_MM_YYYY_SLASH);
                      String endDate = DateUtil.dateToString(
                          listDates[1], DateUtil.DD_MM_YYYY_SLASH);
                      listener?.onSelectDateFilter(
                          index,
                          DataUtils.dateFilterListWithAll[index],
                          startDate,
                          endDate,
                          "");
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                    alignment: Alignment.center,
                    child: TitleTextView(
                      text: DataUtils.dateFilterListWithAll[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  void showDateRangePickerDialog(String dialogIdentifier, DateTime? startDate,
      DateTime? endDate, DateTime firstDate, DateTime lastDate) {
    AppUtils.setStatusBarColor();
    DateUtil.showDateRangeDialog(
        initialFirstDate: startDate,
        initialLastDate: endDate,
        firstDate: firstDate,
        lastDate: lastDate,
        dialogIdentifier: dialogIdentifier,
        listener: this);
  }

  @override
  void onSelectDateRange(
      DateTime startDate, DateTime endDate, String dialogIdentifier) {
    String startDateStr =
        DateUtil.dateToString(startDate, DateUtil.DD_MM_YYYY_SLASH);
    String endDateStr =
        DateUtil.dateToString(endDate, DateUtil.DD_MM_YYYY_SLASH);
    listener?.onSelectDateFilter(
        selectedPosition.value,
        DataUtils.dateFilterListWithAll[selectedPosition.value],
        startDateStr,
        endDateStr,
        "");
  }
}
