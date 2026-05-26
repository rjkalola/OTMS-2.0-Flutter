import 'package:belcka/pages/workshop/workshop_hired_tools/model/workshop_hired_tools_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class WorkshopHiredToolsListItem extends StatelessWidget {
  const WorkshopHiredToolsListItem({
    super.key,
    required this.item,
    required this.isHired,
    this.onTap,
  });

  final WorkshopHiredToolInfo item;
  final bool isHired;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      borderRadius: 12,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            ImageUtils.setRectangleCornerCachedNetworkImage(
              url: item.thumbUrl ?? item.imageUrl ?? '',
              width: 52,
              height: 52,
              borderRadius: 6,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextView(
                    text: !StringHelper.isEmptyString(item.shortName)
                        ? item.shortName ?? ''
                        : item.name ?? '',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    maxLine: 1,
                  ),
                  const SizedBox(height: 2),
                  SubtitleTextView(
                    text:
                        '${isHired ? 'Hired' : 'Requested'} by ${item.userName ?? ''}',
                    fontSize: 13,
                    color: secondaryExtraLightTextColor_(context),
                    maxLine: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: secondaryTextColor_(context),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
