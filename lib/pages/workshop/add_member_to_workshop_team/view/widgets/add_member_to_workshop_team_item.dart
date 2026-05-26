import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class AddMemberToWorkshopTeamItem extends StatelessWidget {
  const AddMemberToWorkshopTeamItem({
    super.key,
    required this.info,
    required this.onTap,
  });

  final UserInfo info;
  final VoidCallback onTap;

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
                UserAvtarView(
                  imageUrl: info.userThumbImage ?? info.userImage ?? '',
                  imageSize: 52,
                  imageBorderWidth: 2,
                  imageBorderColor: const Color(0xff1E1E1E),
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
                CustomCheckbox(
                  mValue: info.isCheck == true,
                  onValueChange: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 22,
          top: 0,
          right: 42,
          child: _tradeChip(),
        ),
      ],
    );
  }

  Widget _tradeChip() {
    if (StringHelper.isEmptyString(info.tradeName)) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: TextViewWithContainer(
        height: 18,
        padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
        text: info.tradeName ?? '',
        fontColor: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        boxColor: AppUtils.getColor('#FF7F00'),
        borderRadius: 45,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}
