import 'package:belcka/pages/manage_forms/forms_list/model/form_administrator.dart';
import 'package:belcka/pages/manage_forms/forms_list/model/form_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormsListItem extends StatelessWidget {
  const FormsListItem({
    super.key,
    required this.item,
    this.onTap,
  });

  final FormInfo item;
  final VoidCallback? onTap;

  String _formattedDate() {
    if (StringHelper.isEmptyString(item.createdAt)) return '';
    final date = DateTime.tryParse(item.createdAt!);
    if (date == null) return '';
    return DateUtil.dateToString(date, DateUtil.DD_MM_YYYY_SLASH);
  }

  String _statusLabel() => item.displayStatusLabel;

  _StatusStyle _statusStyle(BuildContext context) {
    if (item.isPublished) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFE5F6EA),
        textColor: approvedTextColor_(context),
        borderColor: approvedTextColor_(context).withValues(alpha: 0.35),
      );
    }
    if (item.isArchived) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFF3F4F6),
        textColor: secondaryExtraLightTextColor_(context),
        borderColor: dividerColor_(context),
      );
    }
    return _StatusStyle(
      backgroundColor: const Color(0xFFFFF0E0),
      textColor: pendingTextColor_(context),
      borderColor: pendingTextColor_(context).withValues(alpha: 0.35),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(context);
    final statusLabel = _statusLabel();
    final hasStatus = statusLabel.isNotEmpty;
    final showPending =
        item.showPendingForUser(UserUtils.getLoginUserId());
    final createdByName = item.createdBy?.fullName ?? '';
    final createdDate = _formattedDate();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CardViewDashboardItem(
          borderRadius: 14,
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          padding: EdgeInsets.fromLTRB(12, hasStatus ? 16 : 14, 12, 14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: hasStatus ? 72 : 0),
                        child: TitleTextView(
                          text: item.name ?? '',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          maxLine: 3,
                        ),
                      ),
                    ),
                    RightArrowWidget(
                        color: secondaryExtraLightTextColor_(context)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _metric(
                        context,
                        label: 'entries'.tr,
                        value: '${item.entries ?? 0}',
                      ),
                    ),
                    Expanded(
                      child: _metric(
                        context,
                        label: 'views'.tr,
                        value: '${item.views ?? 0}',
                      ),
                    ),
                  ],
                ),
                if (!StringHelper.isEmptyString(item.assignedTo)) ...[
                  const SizedBox(height: 8),
                  SubtitleTextView(
                    text: '${'assigned_to'.tr}: ${item.assignedTo}',
                    fontSize: 13,
                    color: secondaryExtraLightTextColor_(context),
                    maxLine: 2,
                  ),
                ],
                if (!StringHelper.isEmptyString(createdByName) ||
                    !StringHelper.isEmptyString(createdDate)) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (!StringHelper.isEmptyString(createdByName)) ...[
                        UserAvtarView(
                          imageUrl: item.createdBy?.image ?? '',
                          imageSize: 28,
                          imageBorderWidth: 0.5,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubtitleTextView(
                                text: 'created_by'.tr,
                                fontSize: 11,
                                color: secondaryExtraLightTextColor_(context),
                              ),
                              PrimaryTextView(
                                text: createdByName,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                maxLine: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!StringHelper.isEmptyString(createdDate))
                        SubtitleTextView(
                          text: createdDate,
                          fontSize: 12,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                    ],
                  ),
                ],
                if ((item.administrators ?? []).isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _AdministratorAvatars(
                        administrators: item.administrators!,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SubtitleTextView(
                          text: 'administrated_by'.tr,
                          fontSize: 12,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (hasStatus)
          Positioned(
            top: 0,
            right: 36,
            child: TextViewWithContainer(
              text: statusLabel,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontColor: statusStyle.textColor,
              boxColor: statusStyle.backgroundColor,
              borderColor: statusStyle.borderColor,
              borderWidth: 1,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            ),
          ),
        if (showPending)
          TextViewWithContainer(
            text: 'pending'.tr,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            fontColor: Colors.orange,
            boxColor: Colors.orange.shade100,
            borderColor: Colors.orange,
            borderWidth: 1,
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.only(left: 30),
          ),
      ],
    );
  }

  Widget _metric(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SubtitleTextView(
          text: '$label: ',
          fontSize: 13,
          color: secondaryExtraLightTextColor_(context),
        ),
        PrimaryTextView(
          text: value,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class _AdministratorAvatars extends StatelessWidget {
  const _AdministratorAvatars({required this.administrators});

  final List<FormAdministrator> administrators;

  @override
  Widget build(BuildContext context) {
    final visible = administrators.take(4).toList();
    const avatarSize = 24.0;
    const overlap = 8.0;
    final width = avatarSize + (visible.length - 1) * (avatarSize - overlap);

    return SizedBox(
      width: width,
      height: avatarSize,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: UserAvtarView(
                imageUrl: visible[i].image ?? '',
                imageSize: avatarSize,
                imageBorderWidth: 1,
                imageBorderColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
}
