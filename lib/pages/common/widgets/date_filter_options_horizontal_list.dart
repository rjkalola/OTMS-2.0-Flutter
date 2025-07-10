import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_date_range_listener.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class DateFilterOptionsHorizontalList extends StatelessWidget
    implements SelectDateRangeListener {
  const DateFilterOptionsHorizontalList(
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
    return  Container(
      padding: padding,
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DataUtils.dateFilterList.length,
        separatorBuilder: (context, index) => SizedBox(width: 0),
        itemBuilder: (context, index) {
          return Obx(() => CardViewDashboardItem(
              borderColor: (selectedPosition.value == index)
                  ? defaultAccentColor
                  : Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  selectedPosition.value = index;
                  if (DataUtils.dateFilterList[index] != "Custom") {
                    List<DateTime> listDates = DateUtil.getDateWeekRange(
                        DataUtils.dateFilterList[index]);
                    String startDate = DateUtil.dateToString(
                        listDates[0], DateUtil.DD_MM_YYYY_SLASH);
                    String endDate = DateUtil.dateToString(
                        listDates[1], DateUtil.DD_MM_YYYY_SLASH);
                    listener?.onSelectDateFilter(startDate, endDate, "");
                  } else {
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
              )),);
        },
      ),
    );
  }

  void showDateRangePickerDialog(String dialogIdentifier, DateTime? startDate,
      DateTime? endDate, DateTime firstDate, DateTime lastDate) {
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
    listener?.onSelectDateFilter(startDateStr, endDateStr, "");
  }
}
