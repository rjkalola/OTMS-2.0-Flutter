import 'package:belcka/pages/store_settings/model/team_member_list_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class WorkshopTeamsListItem extends StatelessWidget {
  const WorkshopTeamsListItem({super.key, required this.info, this.onTap});

  final TeamMemberUserInfo info;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CardViewDashboardItem(
          borderRadius: 12,
          margin: const EdgeInsets.fromLTRB(12, 9, 12, 6),
          padding: const EdgeInsets.fromLTRB(12, 16, 10, 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => AppUtils.onClickUserAvatar(info.id ?? 0),
                  child: UserAvtarView(
                    imageUrl: info.image ?? '',
                    imageSize: 50,
                    imageBorderWidth: 1.2,
                    imageBorderColor: const Color(0xff1E1E1E),
                    isOnlineStatusVisible: true,
                    onlineStatusColor: (info.statusColor != null &&
                            info.statusColor!.startsWith("#"))
                        ? AppUtils.getColor(info.statusColor ?? "#FF1744")
                        : Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(
                        text: info.name ?? '',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      if (!StringHelper.isEmptyString(info.lastWorkedTime))
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SubtitleTextView(
                            text: 'Last activity ${info.lastWorkedTime}',
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                RightArrowWidget(color: primaryTextColor_(context)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 22,
          top: 0,
          right: 42,
          child: Wrap(
            spacing: 5,
            runSpacing: 3,
            children: [
              _chip(
                text: info.tradeName,
                color: AppUtils.getColor('#FF7F00'),
              ),
              _chip(
                text: info.projectName,
                color: AppUtils.getColor('#8067E8'),
              ),
              _chip(
                text: info.teamName,
                color: AppUtils.getColor('#E92E98'),
              ),
            ],
          ),
        ),
        if ((info.checkIns ?? 0) > 0)
          Positioned(
            top: 0,
            right: 15,
            child: CustomBadgeIcon(
              count: info.checkIns ?? 0,
              color: defaultAccentColor_(context),
            ),
          ),
      ],
    );
  }

  Widget _chip({required String? text, required Color color}) {
    if (StringHelper.isEmptyString(text)) {
      return const SizedBox.shrink();
    }

    return TextViewWithContainer(
      height: 18,
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
      text: text ?? '',
      fontColor: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      boxColor: color,
      borderRadius: 45,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}
