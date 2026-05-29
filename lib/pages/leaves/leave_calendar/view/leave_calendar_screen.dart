import 'package:belcka/pages/leaves/leave_list/model/leave_info.dart';
import 'package:belcka/pages/leaves/leave_utils.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class LeaveCalendarScreen extends StatefulWidget {
  const LeaveCalendarScreen({super.key, required this.leaves});

  final List<LeaveInfo> leaves;

  @override
  State<LeaveCalendarScreen> createState() => _LeaveCalendarScreenState();
}

class _LeaveCalendarScreenState extends State<LeaveCalendarScreen> {
  static const int _timelineStartHour = 6;
  static const int _timelineEndHour = 18;
  static const double _hourRowHeight = 28;
  static const double _timelineBottomPadding = 16;
  static const double _timelineLabelWidth = 36;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    final initialDay =
        LeaveCalendarHelper.initialFocusedDay(widget.leaves) ?? DateTime.now();
    _focusedDay = initialDay;
    _selectedDay = initialDay;
  }

  List<LeaveInfo> _leavesOnDay(DateTime day) {
    return LeaveCalendarHelper.leavesOnDay(widget.leaves, day);
  }

  String? _formatSelectedDaySummary(List<LeaveInfo> leaves) {
    if (leaves.isEmpty) return null;

    var paidCount = 0;
    var unpaidCount = 0;
    for (final leave in leaves) {
      final type = (leave.leaveType ?? "").toLowerCase();
      if (type == "paid") {
        paidCount++;
      } else if (type == "unpaid") {
        unpaidCount++;
      }
    }

    final parts = <String>[];
    if (paidCount > 0) {
      parts.add("$paidCount ${'paid_leave'.tr}");
    }
    if (unpaidCount > 0) {
      parts.add("$unpaidCount ${'unpaid_leave'.tr}");
    }
    if (parts.isEmpty) return null;

    return "(${parts.join(", ")})";
  }

  @override
  Widget build(BuildContext context) {
    final selectedLeaves = _leavesOnDay(_selectedDay);
    final selectedDaySummary = _formatSelectedDaySummary(selectedLeaves);
    final allDayLeaves =
        selectedLeaves.where((leave) => leave.isAlldayLeave ?? false).toList();
    final halfDayLeaves =
        selectedLeaves.where((leave) => !(leave.isAlldayLeave ?? false)).toList();

    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'leave_calendar'.tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
          ),
          body: Column(
            children: [
              _buildLegend(context),
              CardViewDashboardItem(
                margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                borderRadius: 15,
                child: TableCalendar<LeaveInfo>(
                  firstDay: DateTime.utc(2018, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                      LeaveCalendarHelper.isSameDay(day, _selectedDay),
                  calendarFormat: _calendarFormat,
                  eventLoader: _leavesOnDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() => _calendarFormat = format);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) =>
                        _buildDayCell(context, day, isOutside: false),
                    outsideBuilder: (context, day, focusedDay) =>
                        _buildDayCell(context, day, isOutside: true),
                    todayBuilder: (context, day, focusedDay) =>
                        _buildDayCell(context, day, isOutside: false, isToday: true),
                    selectedBuilder: (context, day, focusedDay) =>
                        _buildDayCell(context, day, isOutside: false, isSelected: true),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: primaryTextColor_(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: defaultAccentColor_(context),
                      fontSize: 13,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: primaryTextColor_(context),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: primaryTextColor_(context),
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: secondaryTextColor_(context),
                      fontSize: 12,
                    ),
                    weekendStyle: TextStyle(
                      color: rejectTextColor_(context),
                      fontSize: 12,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
                    markersMaxCount: 0,
                    defaultTextStyle: TextStyle(
                      color: primaryTextColor_(context),
                      fontSize: 14,
                    ),
                    weekendTextStyle: TextStyle(
                      color: rejectTextColor_(context),
                      fontSize: 14,
                    ),
                    outsideTextStyle: TextStyle(
                      color: secondaryLightTextColor_(context),
                      fontSize: 14,
                    ),
                    selectedDecoration: const BoxDecoration(),
                    todayDecoration: const BoxDecoration(),
                    defaultDecoration: const BoxDecoration(),
                    weekendDecoration: const BoxDecoration(),
                    outsideDecoration: const BoxDecoration(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      TitleTextView(
                        text: DateUtil.dateToString(
                          _selectedDay,
                          DateUtil.DD_MMM_YYYY_SLASH,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      if (selectedDaySummary != null)
                        SubtitleTextView(
                          text: selectedDaySummary,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: secondaryLightTextColor_(context),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: selectedLeaves.isEmpty
                    ? Center(
                        child: SubtitleTextView(
                          text: 'no_leaves_on_this_day'.tr,
                          fontSize: 15,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                        children: [
                          if (allDayLeaves.isNotEmpty) ...[
                            _sectionTitle(context, 'all_day'.tr),
                            ...allDayLeaves.map(
                              (leave) => _leaveEventCard(context, leave),
                            ),
                          ],
                          if (halfDayLeaves.isNotEmpty) ...[
                            _sectionTitle(context, 'half_day'.tr),
                            ...halfDayLeaves.map(
                              (leave) => _leaveEventCard(context, leave),
                            ),
                            const SizedBox(height: 8),
                            _halfDayTimeline(context, halfDayLeaves),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          _legendItem(context, Colors.green, 'paid'.tr),
          const SizedBox(width: 20),
          _legendItem(context, Colors.orange, 'unpaid'.tr),
        ],
      ),
    );
  }

  Widget _legendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        SubtitleTextView(text: label, fontSize: 13),
      ],
    );
  }

  Widget? _buildDayCell(
    BuildContext context,
    DateTime day, {
    required bool isOutside,
    bool isToday = false,
    bool isSelected = false,
  }) {
    final events = _leavesOnDay(day);
    final textColor = isOutside
        ? secondaryLightTextColor_(context)
        : (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday)
            ? rejectTextColor_(context)
            : primaryTextColor_(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isSelected
            ? defaultAccentColor_(context).withValues(alpha: 0.18)
            : isToday
                ? defaultAccentColor_(context).withValues(alpha: 0.08)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isToday && !isSelected
            ? Border.all(color: defaultAccentColor_(context), width: 1)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (events.isNotEmpty)
            Positioned(
              left: 2,
              right: 2,
              bottom: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: events.take(2).map((leave) {
                  final segment =
                      LeaveCalendarHelper.getAllDaySegment(leave, day);
                  final color = LeaveUtils.getLeaveTypeColor(
                      leave.leaveType ?? "");
                  return Container(
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.85),
                      borderRadius: segment != null
                          ? LeaveCalendarHelper.segmentBorderRadius(segment)
                          : BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
          Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasUserInfo(LeaveInfo leave) {
    return !StringHelper.isEmptyString(leave.userName ?? "") ||
        !StringHelper.isEmptyString(leave.userThumbImage ?? "");
  }

  Widget _buildUserRow(BuildContext context, LeaveInfo leave) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvtarView(
          imageUrl: leave.userThumbImage ?? leave.userImage ?? "",
          imageSize: 28,
          imageBorderWidth: 0.5,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SubtitleTextView(
            text: leave.userName ?? "",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: primaryTextColor_(context),
            softWrap: true,
            maxLine: 2,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: TitleTextView(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _leaveEventCard(BuildContext context, LeaveInfo leave) {
    final isAllDay = leave.isAlldayLeave ?? false;
    final color = LeaveUtils.getLeaveTypeColor(leave.leaveType ?? "");

    return CardViewDashboardItem(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TitleTextView(
                  text: leave.leaveName ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextViewWithContainer(
                text: StringHelper.capitalizeFirstLetter(leave.leaveType ?? ""),
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                fontColor: Colors.white,
                fontSize: 12,
                boxColor: color,
                borderRadius: 5,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SubtitleTextView(
            text: isAllDay
                ? "${'date'.tr}: ${leave.startDate ?? ""} - ${leave.endDate ?? ""}"
                : "${'date'.tr}: ${leave.startDate ?? ""}",
            fontSize: 14,
          ),
          if (!isAllDay)
            SubtitleTextView(
              text:
                  "${'time'.tr}: ${_formatTime24(leave.startTime ?? "")} - ${_formatTime24(leave.endTime ?? "")}",
              fontSize: 14,
            ),
          if (_hasUserInfo(leave))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildUserRow(context, leave),
            ),
        ],
      ),
    );
  }

  int _timelineEndHourForLeaves(List<LeaveInfo> leaves) {
    var endHour = _timelineEndHour;
    for (final leave in leaves) {
      final end = DateUtil.getDateTimeFromHHMM(leave.endTime ?? "");
      if (end != null && end.hour >= endHour) {
        endHour = end.hour + (end.minute > 0 ? 1 : 0);
      }
    }
    return endHour.clamp(_timelineEndHour, 23);
  }

  double _timelineDrawableHeight(int endHour) {
    return (endHour - _timelineStartHour) * _hourRowHeight;
  }

  Widget _halfDayTimeline(BuildContext context, List<LeaveInfo> leaves) {
    final endHour = _timelineEndHourForLeaves(leaves);
    final drawableHeight = _timelineDrawableHeight(endHour);
    final timelineHeight = drawableHeight + _timelineBottomPadding;

    return CardViewDashboardItem(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleTextView(
            text: 'time'.tr,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: timelineHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ...List.generate(endHour - _timelineStartHour + 1, (index) {
                  final hour = _timelineStartHour + index;
                  final top = index * _hourRowHeight;
                  return Positioned(
                    top: top,
                    left: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: _timelineLabelWidth,
                          child: SubtitleTextView(
                            text: _formatHourLabel24(hour),
                            fontSize: 11,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: dividerColor_(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                ...leaves.map(
                  (leave) => _timelineBlock(
                    context,
                    leave,
                    drawableHeight: drawableHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineBlock(
    BuildContext context,
    LeaveInfo leave, {
    required double drawableHeight,
  }) {
    final start = DateUtil.getDateTimeFromHHMM(leave.startTime ?? "");
    final end = DateUtil.getDateTimeFromHHMM(leave.endTime ?? "");
    if (start == null || end == null) return const SizedBox.shrink();

    final totalMinutes = (_timelineEndHour - _timelineStartHour) * 60;

    int toMinutes(DateTime time) => (time.hour * 60) + time.minute;
    final startMinutes =
        (toMinutes(start) - (_timelineStartHour * 60)).clamp(0, totalMinutes);
    final endMinutes =
        (toMinutes(end) - (_timelineStartHour * 60)).clamp(0, totalMinutes);
    if (endMinutes <= startMinutes) return const SizedBox.shrink();

    final durationMinutes = endMinutes - startMinutes;
    var blockHeight =
        (durationMinutes / totalMinutes) * drawableHeight;
    const minBlockHeight = 32.0;
    blockHeight = blockHeight.clamp(minBlockHeight, drawableHeight);

    var top = (startMinutes / totalMinutes) * drawableHeight;
    if (top + blockHeight > drawableHeight) {
      top = (drawableHeight - blockHeight).clamp(0.0, drawableHeight);
    }

    final color = LeaveUtils.getLeaveTypeColor(leave.leaveType ?? "");
    final timeLabel =
        '${_formatTime24(leave.startTime ?? "")} - ${_formatTime24(leave.endTime ?? "")}';

    return Positioned(
      top: top,
      left: _timelineLabelWidth + 4,
      right: 0,
      height: blockHeight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          timeLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ),
    );
  }

  String _formatHourLabel24(int hour) {
    return hour.toString().padLeft(2, '0');
  }

  String _formatTime24(String time) {
    if (StringHelper.isEmptyString(time)) return time;
    final parsed = DateUtil.getDateTimeFromHHMM(time);
    if (parsed == null) return time;
    return DateUtil.timeToString(parsed, DateUtil.HH_MM_24);
  }
}
