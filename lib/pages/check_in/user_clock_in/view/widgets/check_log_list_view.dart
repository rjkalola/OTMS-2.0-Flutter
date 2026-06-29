import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/user_clock_in/controller/user_clock_in_controller.dart';
import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/pages/check_in/user_clock_in/view/widgets/check_log_connector_painter.dart';
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

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class CheckLogListView extends StatefulWidget {
  final int parentIndex;
  final bool isPriceWork;

  const CheckLogListView({
    super.key,
    required this.parentIndex,
    required this.isPriceWork,
  });

  @override
  State<CheckLogListView> createState() => _CheckLogListViewState();
}

class _CheckLogListViewState extends State<CheckLogListView> {
  final controller = Get.put(UserClockInController());
  final _stackKey = GlobalKey();
  List<GlobalKey> _rowKeys = [];
  List<double> _branchCentersY = [];

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _measureBranchCenters();
    });
  }

  void _measureBranchCenters() {
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !mounted) return;

    final centers = <double>[];
    for (final key in _rowKeys) {
      final rowBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (rowBox == null) continue;
      final topLeft = stackBox.globalToLocal(
        rowBox.localToGlobal(Offset.zero),
      );
      centers.add(topLeft.dy + rowBox.size.height / 2);
    }

    if (centers.length != _rowKeys.length || centers.isEmpty) return;

    final changed = centers.length != _branchCentersY.length ||
        !_listEquals(centers, _branchCentersY);
    if (changed) {
      setState(() => _branchCentersY = centers);
    }
  }

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 0.5) return false;
    }
    return true;
  }

  List<GlobalKey> _ensureRowKeys(int count) {
    if (_rowKeys.length != count) {
      _rowKeys = List.generate(count, (_) => GlobalKey());
      _branchCentersY = [];
    }
    _scheduleMeasure();
    return _rowKeys;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final checkLogs = controller
                .workLogData.value.workLogInfo![widget.parentIndex]
                .userChecklogs ??
            [];
        final visibleLogs =
            checkLogs.where((log) => log.id != 0).toList(growable: false);

        if (visibleLogs.isEmpty) return Container();

        final rowKeys = _ensureRowKeys(visibleLogs.length);

        return Stack(
          key: _stackKey,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 24 + CheckLogTreeConnectorPainter.cardEdgeOverlap,
              child: CustomPaint(
                painter: CheckLogTreeConnectorPainter(
                  color: dividerColor_(context),
                  branchCentersY: _branchCentersY,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                children: List.generate(
                  visibleLogs.length,
                  (position) => Padding(
                    key: rowKeys[position],
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildCheckLogItem(context, visibleLogs[position]),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCheckLogItem(BuildContext context, CheckLogInfo info) {
    final isDarkMode = ThemeConfig.isDarkMode;
    final taskName = !StringHelper.isEmptyString(info.companyTaskName)
        ? info.companyTaskName
        : info.tradeName;
    final isOngoing = isActiveWorkLog(info);

    return GestureDetector(
      onTap: () {
        final arguments = {
          AppConstants.intentKey.checkLogId: info.id ?? 0,
          AppConstants.intentKey.projectId: controller
                  .workLogData.value.workLogInfo![widget.parentIndex].projectId ??
              0,
          AppConstants.intentKey.isPriceWork: controller
                  .workLogData.value.workLogInfo![widget.parentIndex].isPricework ??
              false,
        };
        controller.moveToScreen(AppRoutes.userCheckOutScreen, arguments);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 9, 14, 9),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isDarkMode ? dividerColor_(context) : const Color(0xFFF1F4FA),
          ),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1A2744)
                    : const Color(0xFFEBF1FF),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Center(
                child: ImageUtils.setSvgAssetsImage(
                  path: Drawable.mapPinIcon,
                  width: 24,
                  height: 24,
                  color: defaultAccentColor_(context),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!StringHelper.isEmptyString(info.addressName))
                    PrimaryTextView(
                      text: info.addressName ?? '',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                      overflow: TextOverflow.ellipsis,
                      maxLine: 1,
                    ),
                  if (!StringHelper.isEmptyString(taskName)) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1A2744)
                            : const Color(0xFFEBF1FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PrimaryTextView(
                        text: taskName ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: defaultAccentColor_(context),
                        overflow: TextOverflow.ellipsis,
                        maxLine: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            _buildCheckLogRightContent(context, info, isOngoing),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckLogRightContent(
      BuildContext context, CheckLogInfo info, bool isOngoing) {
    if (isOngoing) {
      return _buildOngoingPill(context);
    }

    final text = widget.isPriceWork
        ? "£${info.priceWorkTotalAmount ?? ""}"
        : DateUtil.seconds_To_HH_MM(info.totalWorkSeconds ?? 0);

    return PrimaryTextView(
      text: text,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: primaryTextColor_(context),
    );
  }

  Widget _buildOngoingPill(BuildContext context) {
    final isDarkMode = ThemeConfig.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A2744) : const Color(0xFFE8F0FE),
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

  Widget setProjectNameTextView(String? text) =>
      !StringHelper.isEmptyString(text)
          ? Container(
              // width: 70,
              margin: EdgeInsets.only(left: 16, right: 10, top: 3, bottom: 3),
              padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
              decoration: BoxDecoration(
                  color: ThemeConfig.isDarkMode
                      ? Color(0xFF339CFF)
                      : Color(0xffACDBFE),
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
            )
          : Container(
              width: 70,
            );

  Widget setItemTypeTextView({required String text, required String color}) =>
      Padding(
          padding: const EdgeInsets.only(left: 50),
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

  Widget dottedLine({required int id, Color? color}) => Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: CustomPaint(
                size: Size(1.3, double.infinity),
                painter: DottedLineVerticalWidget()),
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

  Widget circle(CheckLogInfo info) => Visibility(
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
        visible: id == 0,
        child: GestureDetector(
          onTap: () {
            if (!(controller.workLogData.value.userIsWorking ?? false)) {
              controller.onClickStartShiftButton();
            }
          },
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.addCreateNewPlusIcon,
              width: 22,
              height: 22,
              color: primaryTextColor_(Get.context!)),
        ),
      );

  Widget emptyView() => const SizedBox(height: 90);

  Decoration? itemDecoration(
      {required bool isWorking,
      required bool isRequestPending,
      double? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
      color: backgroundColor_(Get.context!),
      boxShadow: boxShadow,
      border: Border.all(
          width: 0.9, color: getBorderColor(isWorking, isRequestPending)),
      borderRadius: BorderRadius.circular(borderRadius ?? 45),
    );
  }

  Color getBorderColor(bool isWorking, bool isRequestPending) {
    if (isWorking) {
      return Color(0xff2DC75C);
    } else if (isRequestPending) {
      return Colors.red;
    } else {
      return ThemeConfig.isDarkMode ? Color(0xFF1F1F1F) : Colors.grey.shade300;
    }
  }

  bool isActiveWorkLog(CheckLogInfo info) {
    return StringHelper.isEmptyString(info.checkoutDateTime);
  }

  String toWorkTimeText(CheckLogInfo info) {
    return "${!StringHelper.isEmptyString(info.checkoutDateTime) ? controller.changeFullDateToSortTime(info.checkoutDateTime) : 'ongoing'.tr})";
  }
}
