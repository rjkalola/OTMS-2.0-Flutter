import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/pages/check_in/clock_in/model/work_log_info.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/check_log_connector_painter.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/check_log_list_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/custom_views/dotted_line_vertical_widget.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';

class MyDayLogListView extends StatelessWidget {
  MyDayLogListView({super.key});

  final controller = Get.put(UserClockInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          // (controller.workLogData.value.workLogInfo ?? []).isNotEmpty &&
          //         UserClockInUtils.isCurrentDay(
          //             controller.workLogData.value.workStartDate ?? "")
          (controller.workLogData.value.workLogInfo ?? []).isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: controller.scrollController,
                    itemCount: controller.workLogData.value.workLogInfo!.length,
                    itemBuilder: (context, position) {
                      var info =
                          controller.workLogData.value.workLogInfo![position];
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                // const SizedBox(width: 22),
                                info.id != 0
                                    ? Expanded(
                                        child: _buildWorkLogItem(context, info),
                                      )
                                    : emptyView(),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            ),
                          ),
                          Visibility(
                              visible: (info.userChecklogs ?? []).isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 16, bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 10,
                                      child: CustomPaint(
                                        painter: CheckLogTopConnectorPainter(
                                          color: dividerColor_(context),
                                        ),
                                      ),
                                    ),
                                    CheckLogListView(
                                      parentIndex: position,
                                      isPriceWork: info.isPricework ?? false,
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 14,
                    ),
                  ),
                )
              : Container(),
    );
  }

  Widget _buildWorkLogItem(BuildContext context, WorkLogInfo info) {
    final isDarkMode = ThemeConfig.isDarkMode;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isDarkMode
                ? Border.all(color: dividerColor_(context), width: 0.8)
                : null,
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () => controller.onClickWorkLogItem(info.id),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4F7CFF), Color(0xFF7BA5FF)],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: backgroundColor_(context),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: Row(
                          children: [
                            Expanded(
                                child: _buildWorkLogLeftContent(context, info)),
                            _buildWorkLogRightContent(context, info),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        setItemTypeTextView(text: 'shift'.tr, color: "#FF7F00"),
      ],
    );
  }

  Widget _buildWorkLogLeftContent(BuildContext context, WorkLogInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!StringHelper.isEmptyString(info.projectName))
          PrimaryTextView(
            text: info.projectName ?? '',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryTextColor_(context),
            overflow: TextOverflow.ellipsis,
            maxLine: 1,
          ),
        if (!StringHelper.isEmptyString(info.shiftName)) ...[
          const SizedBox(height: 2),
          PrimaryTextView(
            text: '(${info.shiftName})',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: secondaryExtraLightTextColor_(context),
            overflow: TextOverflow.ellipsis,
            maxLine: 1,
          ),
        ],
      ],
    );
  }

  Widget _buildWorkLogRightContent(BuildContext context, WorkLogInfo info) {
    if (isActiveWorkLog(info)) {
      return _buildOngoingPill(context);
    }

    return TextViewWithContainer(
      // padding: const EdgeInsets.symmetric(horizontal: 12),
      borderRadius: 6,
      text: DateUtil.seconds_To_HH_MM(info.payableWorkSeconds ?? 0),
      fontColor: primaryTextColor_(context),
      fontSize: 17,
      fontWeight: FontWeight.w600,
      boxColor: Colors.transparent,
    );
  }

  Widget _buildOngoingPill(BuildContext context) {
    final isDarkMode = ThemeConfig.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A2744)
            : const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: defaultAccentColor_(context),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'ongoing'.tr,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: defaultAccentColor_(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget setProjectNameTextView(String? text) => Visibility(
      visible: !StringHelper.isEmptyString(text),
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 10),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        decoration: BoxDecoration(
            color:
                ThemeConfig.isDarkMode ? Color(0xFF339CFF) : Color(0xffACDBFE),
            borderRadius: BorderRadius.circular(45)),
        child: PrimaryTextView(
          text: text ?? "",
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
          color: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          softWrap: false,
          maxLine: 1,
        ),
      ));

  Widget setItemTypeTextView({required String text, required String color}) =>
      Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
              decoration: BoxDecoration(
                  color: Color(AppUtils.haxColor(color)),
                  borderRadius: BorderRadius.circular(45)),
              child: PrimaryTextView(
                text: text ?? "",
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ));

  Widget dottedLine({required int id}) => Column(
        children: [
          Visibility(
            visible: id == 0 &&
                !((controller.workLogData.value.userIsWorking ?? false) &&
                    controller.isChecking.value),
            child: Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: CustomPaint(
                  size: Size(1.3, double.infinity),
                  painter: DottedLineVerticalWidget()),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: id != 0
                ? CustomPaint(
                    size: Size(1.3, double.infinity),
                    painter: DottedLineVerticalWidget())
                : Container(),
          )
        ],
      );

  Widget circle(WorkLogInfo info) => Visibility(
        visible: info.id != 0,
        child: SizedBox(
          width: 22,
          height: 22,
          child: Center(
            child: CircleWidget(
              color:
                  isActiveWorkLog(info) ? Colors.green : Colors.grey.shade400,
              width: 14,
              height: 14,
            ),
          ),
        ),
      );

  Widget addCircle({required int id}) => Visibility(
        visible: id == 0 &&
            !((controller.workLogData.value.userIsWorking ?? false) &&
                controller.isChecking.value),
        child: GestureDetector(
          onTap: () {
            if (!(controller.workLogData.value.userIsWorking ?? false)) {
              controller.onClickStartShiftButton();
            } else {
              // controller
              //     .onClickAddExpense(controller.selectedWorkLogInfo?.id ?? 0);
              var arguments = {
                AppConstants.intentKey.switchProject: true,
                AppConstants.intentKey.workLogId:
                    controller.selectedWorkLogInfo?.id ?? 0,
              };
              controller.onClickStartShiftButton(arguments: arguments);
            }
            // else if ((controller.workLogData.value.userIsWorking ?? false) &&
            //     !controller.isChecking.value) {
            //   controller.onCLickCheckInButton();
            // }
          },
          child: Stack(
            children: [
              CircleWidget(
                  color: dashBoardBgColor_(Get.context!),
                  width: 22,
                  height: 22),
              ImageUtils.setSvgAssetsImage(
                  path: Drawable.addCreateNewPlusIcon,
                  width: 22,
                  height: 22,
                  color: primaryTextColor_(Get.context!))
            ],
          ),
        ),
      );

  Widget emptyView() => Expanded(
        child: SizedBox(
          height: 65,
        ),
      );

  Decoration? itemDecoration(
      {required bool isWorking,
      int? requestStatus,
      double? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: backgroundColor_(Get.context!),
      boxShadow: boxShadow,
      border: Border.all(
          width: 0.9, color: getBorderColor(isWorking, requestStatus)),
      borderRadius: BorderRadius.circular(borderRadius ?? 45),
    );
  }

  Color getBorderColor(bool isWorking, int? requestStatus) {
    if (isWorking) {
      return Color(0xff2DC75C);
    } else {
      if (requestStatus == null || requestStatus == 0) {
        return ThemeConfig.isDarkMode
            ? Color(0xFF1F1F1F)
            : Colors.grey.shade300;
      } else {
        return AppUtils.getStatusColor(requestStatus ?? 0);
      }
    }
  }

  bool isActiveWorkLog(WorkLogInfo info) {
    return StringHelper.isEmptyString(info.workEndTime);
  }

  String toWorkTimeText(WorkLogInfo info) {
    return "${!StringHelper.isEmptyString(info.workEndTime) ? controller.changeFullDateToSortTime(info.workEndTime) : 'ongoing'.tr})";
  }
}
