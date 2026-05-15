import 'package:belcka/pages/check_in/upload_offline_worklog/model/offline_worklog_conflict_item.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows overlapping-shift conflict UI (same structure as timesheet conflict sheet).
void showOfflineWorklogConflictBottomSheet({
  required BuildContext context,
  required List<OfflineWorklogConflictItem> items,
  required List<ProjectInfo> projectsList,
  void Function(int index, OfflineWorklogConflictItem item)? onKeep,
}) {
  if (items.length < 2) return;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor:
        isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
    builder: (ctx) => PopScope(
      canPop: false,
      child: OfflineWorklogConflictBottomSheet(
      items: items,
      projectsList: projectsList,
      onKeep: onKeep,
      ),
    ),
  );
}

class OfflineWorklogConflictBottomSheet extends StatelessWidget {
  const OfflineWorklogConflictBottomSheet({
    super.key,
    required this.items,
    required this.projectsList,
    this.onKeep,
  });

  final List<OfflineWorklogConflictItem> items;
  final List<ProjectInfo> projectsList;
  final void Function(int index, OfflineWorklogConflictItem item)? onKeep;

  @override
  Widget build(BuildContext context) {
    final first = items[0];
    final second = items[1];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.72,
      ),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHeader(context),
            const SizedBox(height: 4),
            Text(
              'offline_worklog_overlapping_shifts'.tr,
              style: TextStyle(
                color: secondaryLightTextColor_(context),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'OVERLAPPING SHIFTS'),
            const SizedBox(height: 10),
            _ConflictOverlapBlock(
              item: first,
              projectsList: projectsList,
              onKeep: onKeep == null ? null : () => onKeep!(0, first),
            ),
            const SizedBox(height: 8),
            _overlapDivider(context),
            const SizedBox(height: 8),
            _ConflictOverlapBlock(
              item: second,
              projectsList: projectsList,
              onKeep: onKeep == null ? null : () => onKeep!(1, second),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'offline_worklog_data_conflict'.tr,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _conflictBadge(),
      ],
    );
  }

  Widget _conflictBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(45),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: Color(0xFFB45309),
          ),
          SizedBox(width: 4),
          Text(
            'Conflict',
            style: TextStyle(
              color: Color(0xFFB45309),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}

Widget _overlapDivider(BuildContext context) {
  return Row(
    children: [
      Expanded(child: Divider(color: dividerColor_(context), height: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4D6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'offline_worklog_overlap'.tr.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFB45309),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      Expanded(child: Divider(color: dividerColor_(context), height: 1)),
    ],
  );
}

class _ConflictOverlapBlock extends StatelessWidget {
  const _ConflictOverlapBlock({
    required this.item,
    required this.projectsList,
    this.onKeep,
  });

  final OfflineWorklogConflictItem item;
  final List<ProjectInfo> projectsList;
  final VoidCallback? onKeep;

  @override
  Widget build(BuildContext context) {
    final shiftLabel = _resolveShiftName(item, projectsList);
    final projectLabel = _resolveProjectName(item, projectsList);
    final startLabel = _formatConflictClock(item.startTime);
    final endLabel = _formatConflictClock(item.endTime);
    final hasEnd = !StringHelper.isEmptyString(item.endTime);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineRail(hasEnd: hasEnd),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _timeRow(
                          context,
                          label: 'offline_worklog_start'.tr,
                          value: startLabel,
                        ),
                        const SizedBox(height: 6),
                        _timeRow(
                          context,
                          label: 'offline_worklog_end'.tr,
                          value: endLabel,
                        ),
                      ],
                    ),
                  ),
                  if (onKeep != null) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onKeep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultAccentColor_(context),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text('offline_worklog_keep'.tr),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _infoChip(
                    context,
                    shiftLabel,
                    const Color(0xFFE8F4FF),
                    const Color(0xFF1E40AF),
                  ),
                  _infoChip(
                    context,
                    projectLabel,
                    const Color(0xFFE8F4FF),
                    const Color(0xFF1E40AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            color: secondaryLightTextColor_(context),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: primaryTextColor_(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoChip(
    BuildContext context,
    String text,
    Color bg,
    Color fg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor_(context).withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.hasEnd});

  final bool hasEnd;

  @override
  Widget build(BuildContext context) {
    const dotColor = Color(0xFF2563EB);
    return SizedBox(
      width: 14,
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 2,
            height: 36,
            color: dividerColor_(context),
          ),
          Container(
            width: hasEnd ? 8 : 6,
            height: hasEnd ? 8 : 6,
            decoration: BoxDecoration(
              color: hasEnd ? dotColor : Colors.transparent,
              shape: BoxShape.circle,
              border: hasEnd
                  ? null
                  : Border.all(color: dividerColor_(context), width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatConflictClock(String? dateTime) {
  if (StringHelper.isEmptyString(dateTime)) return '—';
  try {
    return DateUtil.changeDateFormat(
      dateTime!,
      DateUtil.DD_MM_YYYY_TIME_24_SLASH2,
      DateUtil.HH_MM_24,
    );
  } catch (_) {
    return dateTime ?? '—';
  }
}

String _resolveShiftName(
  OfflineWorklogConflictItem item,
  List<ProjectInfo> projectsList,
) {
  if (!StringHelper.isEmptyString(item.shiftName)) {
    return item.shiftName!;
  }
  ProjectInfo? project;
  for (final p in projectsList) {
    if ((p.id ?? 0) == (item.projectId ?? 0)) {
      project = p;
      break;
    }
  }
  if (project?.shifts != null) {
    for (final shift in project!.shifts!) {
      if ((shift.id ?? 0) == (item.shiftId ?? 0)) {
        return shift.name ?? '—';
      }
    }
  }
  if (!StringHelper.isEmptyString(item.teamName)) {
    return item.teamName!;
  }
  return '—';
}

String _resolveProjectName(
  OfflineWorklogConflictItem item,
  List<ProjectInfo> projectsList,
) {
  if (!StringHelper.isEmptyString(item.projectName)) {
    return item.projectName!;
  }
  for (final project in projectsList) {
    if ((project.id ?? 0) == (item.projectId ?? 0)) {
      return project.name ?? '—';
    }
  }
  return '—';
}
