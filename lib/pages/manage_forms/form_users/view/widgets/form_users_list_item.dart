import 'package:belcka/pages/manage_forms/form_details/model/form_entry_model.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';

class FormUsersListItem extends StatelessWidget {
  const FormUsersListItem({
    super.key,
    required this.entry,
    this.onTap,
  });

  final FormEntryModel entry;
  final VoidCallback? onTap;

  DateTime? get _submittedAt => DateTime.tryParse(entry.createdAt ?? '');

  String _formattedTime() {
    final date = _submittedAt;
    if (date == null) return '';
    return DateUtil.dateToString(date.toLocal(), DateUtil.HH_MM_24);
  }

  String _formattedDate() {
    final date = _submittedAt;
    if (date == null) return '';
    return DateUtil.dateToString(date.toLocal(), DateUtil.DD_MM_YYYY_SLASH);
  }

  @override
  Widget build(BuildContext context) {
    final time = _formattedTime();
    final date = _formattedDate();
    final secondaryColor = secondaryExtraLightTextColor_(context);

    return CardViewDashboardItem(
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvtarView(
              imageUrl: entry.avatarUrl,
              imageSize: 46,
              imageBorderWidth: 0.5,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryTextView(
                    text: entry.displayName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  if (!StringHelper.isEmptyString(entry.tradeName)) ...[
                    const SizedBox(height: 2),
                    SubtitleTextView(
                      text: entry.tradeName,
                      fontSize: 14,
                      color: secondaryColor,
                      maxLine: 1,
                    ),
                  ],
                ],
              ),
            ),
            if (!StringHelper.isEmptyString(time) ||
                !StringHelper.isEmptyString(date)) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!StringHelper.isEmptyString(time))
                    PrimaryTextView(
                      text: time,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLine: 1,
                    ),
                  if (!StringHelper.isEmptyString(date)) ...[
                    const SizedBox(height: 2),
                    SubtitleTextView(
                      text: date,
                      fontSize: 13,
                      color: secondaryColor,
                      maxLine: 1,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
