import 'package:belcka/pages/check_in/clock_in/model/check_log_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopUserChecklogItem extends StatelessWidget {
  const WorkshopUserChecklogItem({
    super.key,
    required this.info,
    required this.onTap,
  });

  final CheckLogInfo info;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardViewDashboardItem(
          margin: const EdgeInsets.fromLTRB(12, 9, 12, 10),
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Row(
              children: [
                UserAvtarView(imageUrl: info.userThumbImage ?? ''),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(text: info.userName ?? ''),
                      _taskName(),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _totalWorkHour(context),
                const SizedBox(width: 4),
                RightArrowWidget(color: primaryTextColor_(context)),
              ],
            ),
          ),
        ),
        if (!StringHelper.isEmptyString(info.tradeName))
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: TextViewWithContainer(
                height: 18,
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                fontSize: 12,
                text: info.tradeName ?? '',
                fontColor: Colors.white,
                boxColor: AppUtils.getColor('#FF7F00'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _taskName() {
    if (StringHelper.isEmptyString(info.companyTaskName)) {
      return const SizedBox.shrink();
    }

    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: TextViewWithContainer(
          text: info.companyTaskName ?? '',
          padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
          fontColor: ThemeConfig.isDarkMode ? Colors.white : Colors.black,
          fontSize: 14,
          boxColor: ThemeConfig.isDarkMode
              ? const Color(0xFF4BA0F3)
              : const Color(0xffACDBFE),
          borderRadius: 5,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }

  Widget _totalWorkHour(BuildContext context) {
    return Column(
      children: [
        TitleTextView(
          text: DateUtil.seconds_To_HH_MM(info.totalWorkSeconds ?? 0),
          color: primaryTextColor_(Get.context!),
          fontSize: 17,
        ),
        SubtitleTextView(
          text:
              '(${info.formattedCheckInTime ?? ''} - ${info.formattedCheckOutTime ?? ''})',
          fontSize: 13,
        ),
      ],
    );
  }
}
