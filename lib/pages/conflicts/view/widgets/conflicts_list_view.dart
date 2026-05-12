import 'dart:convert';

import 'package:belcka/pages/common/listener/DialogButtonClickListener.dart';
import 'package:belcka/pages/conflicts/controller/conflicts_controller.dart';
import 'package:belcka/pages/conflicts/controller/timesheet_conflict_payload.dart';
import 'package:belcka/pages/conflicts/model/conflicts_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/AlertDialogHelper.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Pops the Get [Get.dialog] confirm, then the Material [showModalBottomSheet]
/// route. [Get.isBottomSheetOpen] is false for Material sheets, so we always
/// pop twice for this app's conflicts flow (dialog on top of sheet).
void _dismissConflictAlertAndBottomSheet() {
  Get.back();
  Get.back();
}

/// Detail row for conflict bottom sheets: avoids squeezing the label when the
/// value is long (never put [Expanded] only on the short title).
Widget _conflictSheetDetailRow(
  BuildContext context,
  String title,
  String value,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: secondaryLightTextColor_(context),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Ellipsis for long titles next to badges in sheet headers (team, store, etc.).
Widget _conflictSheetHeaderLine(
  BuildContext context, {
  required String text,
  required TextStyle style,
  int maxLines = 2,
}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    softWrap: true,
    style: style,
  );
}

class ConflictsListView extends StatelessWidget {
  ConflictsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConflictsController>();
    return Obx(() {
      final sections =
          _sectionsForSelectedTab(controller, controller.selectedTab.value);
      final hasData = sections.any((section) => section.items.isNotEmpty);
      if (!hasData) {
        return Center(
          child: Text(
            'no_data_found'.tr,
            style: TextStyle(color: secondaryLightTextColor_(context)),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: sections.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, index) {
          final section = sections[index];
          if (section.items.isEmpty) return const SizedBox.shrink();
          return _Section(
            title: section.title,
            count: section.items.length,
            badgeColor: section.badgeColor,
            child: Column(children: section.items),
          );
        },
      );
    });
  }

  List<_ConflictSection> _sectionsForSelectedTab(
    ConflictsController controller,
    String selectedTab,
  ) {
    if (selectedTab == ConflictsTab.timesheet.value) {
      return [_timesheetSection(controller)];
    }
    if (selectedTab == ConflictsTab.billing.value) {
      return [_billingSection(controller)];
    }
    if (selectedTab == ConflictsTab.team.value) {
      return [_teamSection(controller)];
    }
    if (selectedTab == ConflictsTab.healthSafety.value) {
      return [_healthSafetySection(controller)];
    }
    if (selectedTab == ConflictsTab.store.value) {
      return [_storeSection(controller)];
    }
    return [
      _timesheetSection(controller),
      _billingSection(controller),
      _teamSection(controller),
      _healthSafetySection(controller),
      _storeSection(controller),
    ];
  }

  _ConflictSection _timesheetSection(ConflictsController controller) =>
      _ConflictSection(
        title: 'Timesheet Conflicts',
        badgeColor: const Color(0xFFFFA300),
        items: controller.timesheetConflicts
            .map((e) => _UserConflictTile(data: e, isTimesheet: true))
            .toList(),
      );

  _ConflictSection _billingSection(ConflictsController controller) =>
      _ConflictSection(
        title: 'Billing Conflicts',
        badgeColor: const Color(0xFF5663FF),
        items: controller.billingConflicts
            .map((e) => _UserConflictTile(data: e, isTimesheet: false))
            .toList(),
      );

  _ConflictSection _teamSection(ConflictsController controller) =>
      _ConflictSection(
        title: 'Team Conflicts',
        badgeColor: const Color(0xFF8B5CF6),
        items: controller.teamConflicts
            .map((e) => _TeamConflictTile(data: e))
            .toList(),
      );

  _ConflictSection _healthSafetySection(ConflictsController controller) =>
      _ConflictSection(
        title: 'Health & Safety Conflicts',
        badgeColor: const Color(0xFFEF4444),
        items: controller.healthSafetyConflicts
            .map((e) => _HealthSafetyConflictTile(data: e))
            .toList(),
      );

  _ConflictSection _storeSection(ConflictsController controller) =>
      _ConflictSection(
        title: 'Store Conflicts',
        badgeColor: const Color(0xFF06B6D4),
        items: controller.storeConflicts
            .map((e) => _StoreConflictTile(data: e))
            .toList(),
      );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.count,
    required this.badgeColor,
    required this.child,
  });

  final String title;
  final int count;
  final Color badgeColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: backgroundColor_(context),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: primaryTextColor_(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badgeColor,
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _UserConflictTile extends StatelessWidget {
  const _UserConflictTile({required this.data, required this.isTimesheet});

  final UserConflictData data;
  final bool isTimesheet;

  @override
  Widget build(BuildContext context) {
    final items = data.items ?? [];

    if (isTimesheet && items.length >= 2) {
      final a = items[0];
      final b = items[1];
      final resolved = _resolveTimesheetConflictLabel(a, b);
      final r1 = _formatTimeRange(a.start, a.end);
      final r2 = _formatTimeRange(b.start, b.end);
      final datePart = data.formattedDate ?? data.date ?? "";
      return _BaseTile(
        imageUrl: data.userThumbImage ?? data.userImage,
        title: data.userName ?? "-",
        tagText: resolved.label,
        tagColor: resolved.background,
        tagTextColor: resolved.foreground,
        subtitleTop: "$datePart · $r1 · $r2",
        subtitleBottom: "",
        onTap: () => _openTimesheetConflictSheet(context, data),
      );
    }

    final item = items.isNotEmpty ? items.first : null;
    if (isTimesheet) {
      return _BaseTile(
        imageUrl: data.userThumbImage ?? data.userImage,
        title: data.userName ?? "-",
        tagText: 'Delete Only',
        tagColor: const Color(0xFFFFE8E8),
        tagTextColor: const Color(0xFFE23D3D),
        subtitleTop: data.formattedDate ?? data.date ?? "",
        subtitleBottom:
            "${item?.start ?? '--:--'}-${item?.end ?? '--:--'}",
      );
    }

    return _BaseTile(
      imageUrl: data.userThumbImage ?? data.userImage,
      title: data.userName ?? "-",
      tagText: 'Billing Info',
      tagColor: const Color(0xFFE7EEFF),
      tagTextColor: const Color(0xFF4E63DD),
      subtitleTop: data.formattedDate ?? data.date ?? "",
      subtitleBottom: item?.message ?? "",
      onTap: items.isNotEmpty
          ? () => _openBillingConflictSheet(context, data)
          : null,
    );
  }
}

Map<String, dynamic>? _conflictBillingDataAsMap(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

String _billingConflictFieldValue(Map<String, dynamic>? map, String key) {
  if (map == null || !map.containsKey(key)) return '—';
  final v = map[key];
  if (v == null) return '—';
  if (v is String) {
    final t = v.trim();
    return t.isEmpty ? '—' : t;
  }
  if (v is num || v is bool) {
    return '$v';
  }
  if (v is Map || v is List) {
    try {
      final encoded = jsonEncode(v);
      return encoded.isEmpty ? '—' : encoded;
    } catch (_) {
      final s = v.toString().trim();
      return s.isEmpty ? '—' : s;
    }
  }
  final s = v.toString().trim();
  return s.isEmpty ? '—' : s;
}

List<String> _billingConflictFieldKeys(
  Map<String, dynamic>? oldMap,
  Map<String, dynamic>? newMap,
) {
  final keys = <String>{};
  for (final k in oldMap?.keys ?? const Iterable<String>.empty()) {
    if (k.isNotEmpty) keys.add(k);
  }
  for (final k in newMap?.keys ?? const Iterable<String>.empty()) {
    if (k.isNotEmpty) keys.add(k);
  }
  final list = keys.toList()..sort();
  return list;
}

/// Keys where at least one of old/new has a non-empty display value.
List<String> _billingConflictFieldKeysWithContent(
  Map<String, dynamic>? oldMap,
  Map<String, dynamic>? newMap,
) {
  return _billingConflictFieldKeys(oldMap, newMap)
      .where((key) {
        final before = _billingConflictFieldValue(oldMap, key);
        final after = _billingConflictFieldValue(newMap, key);
        return before != '—' || after != '—';
      })
      .toList();
}

String _billingConflictKeyLabel(String key) {
  if (key.isEmpty) return key;
  return key
      .split('_')
      .where((segment) => segment.isNotEmpty)
      .map((segment) =>
          '${segment[0].toUpperCase()}${segment.length > 1 ? segment.substring(1).toLowerCase() : ''}')
      .join(' ')
      .toUpperCase();
}

void _openBillingConflictSheet(BuildContext context, UserConflictData data) {
  final items = data.items ?? [];
  if (items.isEmpty) return;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor:
        isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
    builder: (ctx) => _BillingConflictSheet(data: data),
  );
}

class _BillingConflictSheet extends StatelessWidget {
  const _BillingConflictSheet({required this.data});

  final UserConflictData data;

  @override
  Widget build(BuildContext context) {
    final items = data.items ?? [];
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final item = items.first;
    final oldMap = _conflictBillingDataAsMap(item.oldData);
    final newMap = _conflictBillingDataAsMap(item.newData);
    final fieldKeysVisible =
        _billingConflictFieldKeysWithContent(oldMap, newMap);
    final dateLine = data.formattedDate ?? data.date ?? "";
    final message = item.message ?? "";
    final hasMessage = message.trim().isNotEmpty;
    final showBillingChanges =
        hasMessage || fieldKeysVisible.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: (data.userThumbImage ?? data.userImage ?? "")
                                .isNotEmpty
                            ? NetworkImage(
                                data.userThumbImage ?? data.userImage ?? "")
                            : null,
                        child: (data.userThumbImage ?? data.userImage ?? "")
                                .isEmpty
                            ? const Icon(Icons.person, size: 18)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.userName ?? "-",
                              style: TextStyle(
                                color: primaryTextColor_(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateLine,
                              style: TextStyle(
                                color: secondaryLightTextColor_(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7EEFF),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 14,
                              color: const Color(0xFF4E63DD),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Billing",
                              style: TextStyle(
                                color: const Color(0xFF4E63DD),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  if (showBillingChanges) ...[
                    const SizedBox(height: 20),
                    _billingSheetSectionTitle(context, "BILLING INFO CHANGES"),
                    if (hasMessage) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EE),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFD4A8)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFFFA94D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                message,
                                style: const TextStyle(
                                  color: Color(0xFFAA6E1A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (fieldKeysVisible.isNotEmpty) ...[
                      SizedBox(height: hasMessage ? 16 : 8),
                      for (final key in fieldKeysVisible)
                        KeyedSubtree(
                          key: ValueKey<String>('billing_diff_$key'),
                          child: _billingCompareRow(
                            context,
                            label: _billingConflictKeyLabel(key),
                            before: _billingConflictFieldValue(oldMap, key),
                            after: _billingConflictFieldValue(newMap, key),
                          ),
                        ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
            decoration: BoxDecoration(
              color: backgroundColor_(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _billingSheetSectionTitle(context, "RESOLUTION"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4E63DD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Keep Changes",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE23D3D),
                          side: const BorderSide(color: Color(0xFFFF8A8A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Discard",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _billingSheetSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _billingCompareRow(
    BuildContext context, {
    required String label,
    required String before,
    required String after,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: secondaryLightTextColor_(context),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _billingValueBox(
                  context,
                  caption: "BEFORE",
                  value: before,
                  background: const Color(0xFFFFEEF1),
                  borderColor: const Color(0xFFFFC9D4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _billingValueBox(
                  context,
                  caption: "AFTER",
                  value: after,
                  background: const Color(0xFFEEF8F0),
                  borderColor: const Color(0xFFB8E6C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _billingValueBox(
    BuildContext context, {
    required String caption,
    required String value,
    required Color background,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: TextStyle(
              color: secondaryLightTextColor_(context),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

void _openTimesheetConflictSheet(BuildContext context, UserConflictData data) {
  final items = data.items ?? [];
  if (items.length < 2) return;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor:
        isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
    builder: (ctx) => _TimesheetConflictSheet(data: data),
  );
}

class _TimesheetConflictSheet extends StatefulWidget {
  const _TimesheetConflictSheet({required this.data});

  final UserConflictData data;

  @override
  State<_TimesheetConflictSheet> createState() => _TimesheetConflictSheetState();
}

enum _TimesheetSheetPanel { none, cut, split, deleteMenu }

class _TimesheetConflictSheetState extends State<_TimesheetConflictSheet>
    implements DialogButtonClickListener {
  _TimesheetSheetPanel _panel = _TimesheetSheetPanel.none;
  int? _pendingDeleteWorklogId;

  @override
  Widget build(BuildContext context) {
    final items = widget.data.items ?? [];
    final a = items[0];
    final b = items[1];
    final kind = _resolveTimesheetResolutionKind(a, b);
    final dateLine =
        widget.data.formattedDate ?? widget.data.date ?? "";

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            (widget.data.userThumbImage ?? widget.data.userImage ?? "")
                                    .isNotEmpty
                                ? NetworkImage(
                                    widget.data.userThumbImage ??
                                        widget.data.userImage ??
                                        "")
                                : null,
                        child: (widget.data.userThumbImage ?? widget.data.userImage ?? "")
                                .isEmpty
                            ? const Icon(Icons.person, size: 18)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _conflictSheetHeaderLine(
                              context,
                              text: widget.data.userName ?? "-",
                              style: TextStyle(
                                color: primaryTextColor_(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            _conflictSheetHeaderLine(
                              context,
                              text: dateLine,
                              maxLines: 1,
                              style: TextStyle(
                                color: secondaryLightTextColor_(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4D6),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 14,
                              color: const Color(0xFFB45309),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Conflict",
                              style: const TextStyle(
                                color: Color(0xFFB45309),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _timesheetSheetSectionTitle(context, "OVERLAPPING SHIFTS"),
                  const SizedBox(height: 10),
                  _TimesheetOverlapBlock(item: a, useWorkDot: a.isLeave != true),
                  const SizedBox(height: 8),
                  _overlapDivider(context),
                  const SizedBox(height: 8),
                  _TimesheetOverlapBlock(item: b, useWorkDot: b.isLeave != true),
                  const SizedBox(height: 20),
                  _timesheetSheetSectionTitle(context, "RESOLUTION"),
                  const SizedBox(height: 10),
                  _resolutionButtons(context, kind),
                  if (_panel == _TimesheetSheetPanel.cut &&
                      kind == _TimesheetResolutionKind.cutAndDelete) ...[
                    const SizedBox(height: 12),
                    _cutPanel(
                      context,
                      a,
                      b,
                      onCut: _showCutConfirm,
                    ),
                  ],
                  if (_panel == _TimesheetSheetPanel.split &&
                      kind == _TimesheetResolutionKind.splitAndDelete) ...[
                    const SizedBox(height: 12),
                    _splitPreviewPanel(
                      context,
                      a,
                      b,
                      dateLine,
                      onCancel: () {
                        setState(() => _panel = _TimesheetSheetPanel.none);
                      },
                      onConfirm: _showSplitConfirm,
                    ),
                  ],
                  if (_panel == _TimesheetSheetPanel.deleteMenu) ...[
                    const SizedBox(height: 12),
                    _deleteChoicePanel(context, a, b, onDeleteItem: _showDeleteWorklogConfirm),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resolutionButtons(BuildContext context, _TimesheetResolutionKind kind) {
    void toggle(_TimesheetSheetPanel target) {
      setState(() {
        _panel = _panel == target ? _TimesheetSheetPanel.none : target;
      });
    }

    const deleteFg = Color(0xFFE23D3D);
    final deleteBtn = Expanded(
      child: OutlinedButton(
        onPressed: () => toggle(_TimesheetSheetPanel.deleteMenu),
        style: OutlinedButton.styleFrom(
          foregroundColor: deleteFg,
          side: const BorderSide(color: Color(0xFFFFB4B4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/ic_delete.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(deleteFg, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            const Text("Delete"),
            const SizedBox(width: 6),
            Icon(
              _panel == _TimesheetSheetPanel.deleteMenu
                  ? Icons.expand_less
                  : Icons.expand_more,
              size: 20,
              color: deleteFg,
            ),
          ],
        ),
      ),
    );

    if (kind == _TimesheetResolutionKind.deleteOnly) {
      return Row(children: [deleteBtn]);
    }

    if (kind == _TimesheetResolutionKind.cutAndDelete) {
      return Row(
        children: [
          Expanded(
          child: OutlinedButton.icon(
            onPressed: () => toggle(_TimesheetSheetPanel.cut),
            icon: Icon(
              _panel == _TimesheetSheetPanel.cut
                  ? Icons.expand_less
                  : Icons.content_cut,
              size: 18,
            ),
            label: const Text("Cut start/end"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                side: const BorderSide(color: Color(0xFF93C5FD)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          deleteBtn,
        ],
      );
    }

    // splitAndDelete
    const splitFg = Color(0xFF2563EB);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => toggle(_TimesheetSheetPanel.split),
            style: OutlinedButton.styleFrom(
              foregroundColor: splitFg,
              side: const BorderSide(color: Color(0xFF93C5FD)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.call_split, size: 18, color: splitFg),
                const SizedBox(width: 6),
                const Text("Split Containing"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        deleteBtn,
      ],
    );
  }

  void _showDeleteWorklogConfirm(ConflictItem item) {
    final id = item.worklogId;
    if (id == null) return;
    _pendingDeleteWorklogId = id;
    AlertDialogHelper.showAlertDialog(
      "",
      'are_you_sure_you_want_to_delete'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      false,
      this,
      AppConstants.dialogIdentifier.timesheetConflictDeleteWorklog,
    );
  }

  void _showCutConfirm() {
    AlertDialogHelper.showAlertDialog(
      "",
      'are_you_sure_you_want_to_cut'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      false,
      this,
      AppConstants.dialogIdentifier.timesheetConflictCut,
    );
  }

  void _showSplitConfirm() {
    AlertDialogHelper.showAlertDialog(
      "",
      'are_you_sure_you_want_to_split'.tr,
      'yes'.tr,
      'no'.tr,
      "",
      true,
      false,
      this,
      AppConstants.dialogIdentifier.timesheetConflictSplit,
    );
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    _pendingDeleteWorklogId = null;
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    final ctrl = Get.find<ConflictsController>();
    final items = widget.data.items ?? [];
    if (items.length < 2) {
      Get.back();
      return;
    }
    final a = items[0];
    final b = items[1];

    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.timesheetConflictDeleteWorklog) {
      final id = _pendingDeleteWorklogId;
      _pendingDeleteWorklogId = null;
      if (id == null) {
        Get.back();
        return;
      }
      _dismissConflictAlertAndBottomSheet();
      ctrl.deleteTimesheetWorklog(id);
      return;
    }
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.timesheetConflictCut) {
      _dismissConflictAlertAndBottomSheet();
      ctrl.cutTimesheetConflict(widget.data, a, b);
      return;
    }
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.timesheetConflictSplit) {
      _dismissConflictAlertAndBottomSheet();
      ctrl.splitTimesheetConflict(widget.data, a, b);
    }
  }
}

Widget _timesheetSheetSectionTitle(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(
      color: secondaryLightTextColor_(context),
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );
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
            "OVERLAP",
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

class _TimesheetOverlapBlock extends StatelessWidget {
  const _TimesheetOverlapBlock({
    required this.item,
    required this.useWorkDot,
  });

  final ConflictItem item;
  final bool useWorkDot;

  @override
  Widget build(BuildContext context) {
    final isLeave = item.isLeave == true;
    final label = isLeave
        ? (item.leaveName ?? item.shiftName ?? "Leave")
        : (item.shiftName ?? "Shift");
    final barColor = isLeave
        ? const Color(0xFFFFE8EE)
        : const Color(0xFFE8F4FF);
    final textColor = isLeave
        ? const Color(0xFFB91C1C)
        : const Color(0xFF1E40AF);
    final dotColor =
        useWorkDot ? const Color(0xFF2563EB) : const Color(0xFFE23D3D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.start ?? "--:--",
              style: TextStyle(
                color: primaryTextColor_(context),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "—",
                style: TextStyle(color: secondaryLightTextColor_(context)),
              ),
            ),
            Text(
              item.end ?? "--:--",
              style: TextStyle(
                color: primaryTextColor_(context),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              if (isLeave)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF87171)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Leave",
                    style: TextStyle(
                      color: Color(0xFFB91C1C),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _cutPanel(
  BuildContext context,
  ConflictItem a,
  ConflictItem b, {
  required VoidCallback onCut,
}) {
  final pa = timesheetIntervalTuple(a);
  final pb = timesheetIntervalTuple(b);
  if (pa == null || pb == null) return const SizedBox.shrink();
  final (ts1, te1) = pa;
  final (ts2, te2) = pb;
  ConflictItem longer;
  if ((te1 - ts1) >= (te2 - ts2)) {
    longer = a;
  } else {
    longer = b;
  }
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor_(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: dividerColor_(context)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cut the overlapping hours from the longer worklog:",
          style: TextStyle(
            color: secondaryLightTextColor_(context),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Cut from ${longer.shiftName ?? 'Shift'} "
                  "${longer.start ?? ''} – ${longer.end ?? ''}",
                  style: const TextStyle(
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onCut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Cut"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _splitPreviewPanel(
  BuildContext context,
  ConflictItem a,
  ConflictItem b,
  String dateLine, {
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
}) {
  final triplet = splitOuterInner(a, b);
  if (triplet == null) return const SizedBox.shrink();
  final (outer, _, point) = triplet;
  final po = timesheetIntervalTuple(outer);
  if (po == null) return const SizedBox.shrink();
  final (os, oe) = po;
  final name = outer.shiftName ?? "Shift";
  final s1 = formatClockHHmm(os);
  final e1 = formatClockHHmm(point);
  final s2 = formatClockHHmm(point);
  final e2 = formatClockHHmm(point);
  final s3 = formatClockHHmm(point);
  final e3 = formatClockHHmm(oe);
  final d1 = (point - os).clamp(0, 24 * 60);
  final d2 = 0;
  final d3 = (oe - point).clamp(0, 24 * 60);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor_(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: dividerColor_(context)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$dateLine · Split Preview",
          style: TextStyle(
            color: primaryTextColor_(context),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(0.8),
          },
          children: [
            TableRow(
              children: [
                _tableHeaderCell(context, "Shift"),
                _tableHeaderCell(context, "Start"),
                _tableHeaderCell(context, "End"),
                _tableHeaderCell(context, "Total"),
              ],
            ),
            _splitTableDataRow(context, name, s1, e1, d1),
            _splitTableDataRow(context, name, s2, e2, d2),
            _splitTableDataRow(context, name, s3, e3, d3),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryTextColor_(context),
                  side: BorderSide(color: dividerColor_(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Confirm split"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _tableHeaderCell(BuildContext context, String t) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6, right: 4),
    child: Text(
      t,
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

TableRow _splitTableDataRow(
  BuildContext context,
  String shiftName,
  String start,
  String end,
  int durationMins,
) {
  final bg = const Color(0xFFE8F4FF);
  Widget cell(String text) => Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1E3A8A),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
  return TableRow(
    children: [
      cell(shiftName),
      cell(start),
      cell(end),
      cell("${durationMins}m"),
    ],
  );
}

Widget _deleteChoicePanel(
  BuildContext context,
  ConflictItem a,
  ConflictItem b, {
  required void Function(ConflictItem) onDeleteItem,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor_(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: dividerColor_(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select which shift to delete:",
          style: TextStyle(
            color: primaryTextColor_(context),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        _deleteRow(context, a, onDeleteItem: onDeleteItem),
        const SizedBox(height: 10),
        _deleteRow(context, b, onDeleteItem: onDeleteItem),
      ],
    ),
  );
}

Widget _deleteRow(
  BuildContext context,
  ConflictItem item, {
  required void Function(ConflictItem) onDeleteItem,
}) {
  final label = item.isLeave == true
      ? (item.leaveName ?? item.shiftName ?? "Leave")
      : (item.shiftName ?? "Shift");
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: dashBoardBgColor_(context),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  color: primaryTextColor_(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.start ?? '--',
                    style: TextStyle(
                      color: secondaryLightTextColor_(context),
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: secondaryLightTextColor_(context),
                    ),
                  ),
                  Text(
                    item.end ?? '--',
                    style: TextStyle(
                      color: secondaryLightTextColor_(context),
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => onDeleteItem(item),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE23D3D),
            side: const BorderSide(color: Color(0xFFFFB4B4)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}

class _TeamResolveConflictListener implements DialogButtonClickListener {
  _TeamResolveConflictListener(this.teamId);

  final int teamId;

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (teamId == 0) {
      Get.back();
      return;
    }
    _dismissConflictAlertAndBottomSheet();
    Get.find<ConflictsController>().resolveTeamConflict(teamId);
  }
}

class _TeamConflictTile extends StatelessWidget {
  const _TeamConflictTile({required this.data});

  final TeamConflictData data;

  @override
  Widget build(BuildContext context) {
    final countText =
        "${data.currentMemberCount ?? 0}/${data.maxMemberLimit ?? 0}";
    return Material(
      color: backgroundColor_(context),
      child: InkWell(
        onTap: () => _openTeamConflictDetails(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: (data.supervisorThumbImage ?? "").isNotEmpty
                    ? NetworkImage(data.supervisorThumbImage!)
                    : null,
                child: (data.supervisorThumbImage ?? "").isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.teamName ?? "-",
                            style: TextStyle(
                                color: primaryTextColor_(context),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1E8FF),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Text(
                            "Limit exceeded",
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (data.maxMemberLimit ?? 0) == 0
                                  ? 1
                                  : (data.currentMemberCount ?? 0) /
                                      (data.maxMemberLimit ?? 1),
                              minHeight: 6,
                              color: rejectTextColor_(context),
                              backgroundColor: dividerColor_(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          countText,
                          style: TextStyle(
                              color: primaryTextColor_(context),
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Supervisor: ${data.supervisorName ?? '-'}",
                      style:
                          TextStyle(color: secondaryLightTextColor_(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTeamConflictDetails(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final current = data.currentMemberCount ?? 0;
    final maxAllowed = data.maxMemberLimit ?? 0;
    final over = (current - maxAllowed).clamp(0, 999);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor:
          isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (data.supervisorThumbImage ?? "").isNotEmpty
                                    ? NetworkImage(data.supervisorThumbImage!)
                                    : null,
                            child: (data.supervisorThumbImage ?? "").isEmpty
                                ? const Icon(Icons.person, size: 18)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _conflictSheetHeaderLine(
                                  context,
                                  text: data.teamName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _conflictSheetHeaderLine(
                                  context,
                                  text:
                                      "Supervisor: ${data.supervisorName ?? '-'}",
                                  style: TextStyle(
                                    color: secondaryLightTextColor_(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1E8FF),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: const Text(
                              "Team Limit",
                              style: TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _teamSheetTitle(context, "MEMBER USAGE"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFFFC9C9),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CURRENT",
                                        style: TextStyle(
                                          color: secondaryLightTextColor_(
                                              context),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "$current",
                                        style: const TextStyle(
                                          color: Color(0xFFE23D3D),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "MAX ALLOWED",
                                        style: TextStyle(
                                          color: secondaryLightTextColor_(
                                              context),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "$maxAllowed",
                                        style: TextStyle(
                                          color: primaryTextColor_(context),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: maxAllowed == 0
                                    ? 1
                                    : (current / maxAllowed).clamp(0.0, 1.0),
                                minHeight: 8,
                                color: const Color(0xFFE23D3D),
                                backgroundColor: dividerColor_(context),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              over > 0
                                  ? "$over members over the limit — reduce team size to resolve"
                                  : "Team is within the member limit.",
                              style: TextStyle(
                                color: over > 0
                                    ? const Color(0xFFE23D3D)
                                    : secondaryLightTextColor_(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _teamSheetTitle(context, "TEAM DETAILS"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dashBoardBgColor_(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _conflictSheetDetailRow(
                                context, "Team Name", data.teamName ?? "-"),
                            _conflictSheetDetailRow(context, "Supervisor",
                                data.supervisorName ?? "-"),
                            _conflictSheetDetailRow(
                              context,
                              "Conflict Type",
                              _formatTeamConflictType(data.conflictType),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
                decoration: BoxDecoration(
                  color: backgroundColor_(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _teamSheetTitle(context, "RESOLUTION"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.back();
                          if ((data.teamId ?? 0) != 0) {
                            final arguments = {
                              AppConstants.intentKey.teamId: data.teamId ?? 0,
                              AppConstants.intentKey.isAllUserTeams: false,
                            };
                            Get.toNamed(AppRoutes.teamDetailsScreen,
                                arguments: arguments);
                          }
                        },
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text("View Team"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2F4C7F),
                          side: BorderSide(color: dividerColor_(context)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D7D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final tid = data.teamId ?? 0;
                          if (tid == 0) return;
                          AlertDialogHelper.showAlertDialog(
                            "",
                            'are_you_sure_you_want_to_resolve'.tr,
                            'yes'.tr,
                            'no'.tr,
                            "",
                            true,
                            false,
                            _TeamResolveConflictListener(tid),
                            AppConstants.dialogIdentifier.teamConflictResolve,
                          );
                        },
                        child: const Text(
                          "Mark as Resolved",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _teamSheetTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  String _formatTeamConflictType(String? conflictType) {
    if ((conflictType ?? "").isEmpty) return "-";
    if (conflictType == "team_member_limit") {
      return "Member Limit Exceeded";
    }
    return conflictType!
        .split("_")
        .map((e) => e.isEmpty
            ? ""
            : "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .join(" ");
  }
}

class _HealthSafetyResolveConflictListener implements DialogButtonClickListener {
  _HealthSafetyResolveConflictListener(this.conflictType, this.recordId);

  final String conflictType;
  final int recordId;

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    _dismissConflictAlertAndBottomSheet();
    Get.find<ConflictsController>().resolveHealthSafetyConflict(
      conflictType: conflictType,
      recordId: recordId,
    );
  }
}

class _HealthSafetyConflictTile extends StatelessWidget {
  const _HealthSafetyConflictTile({required this.data});

  final HealthSafetyConflictData data;

  @override
  Widget build(BuildContext context) {
    return _BaseTile(
      imageUrl: data.reportedByThumbImage ?? data.reportedByImage,
      title: data.reportedByName ?? "-",
      tagText: data.hazardName ?? "",
      tagColor: const Color(0xFFFFE8EC),
      tagTextColor: const Color(0xFFE23D3D),
      subtitleTop: data.message ?? "",
      subtitleBottom: data.description ?? "",
      onTap: () => _openHealthSafetyDetails(context),
    );
  }

  void _openHealthSafetyDetails(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor:
          isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (data.reportedByThumbImage ?? "").isNotEmpty
                                    ? NetworkImage(data.reportedByThumbImage!)
                                    : null,
                            child: (data.reportedByThumbImage ?? "").isEmpty
                                ? const Icon(Icons.person, size: 18)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _conflictSheetHeaderLine(
                                  context,
                                  text: data.reportedByName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _conflictSheetHeaderLine(
                                  context,
                                  text: data.hazardName ?? "",
                                  style: TextStyle(
                                    color: secondaryLightTextColor_(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE8EC),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: const Text(
                              "Health & Safety",
                              style: TextStyle(
                                color: Color(0xFFE23D3D),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _sheetTitle(context, "HAZARD OVERVIEW"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFFFA94D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data.message ?? "",
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Color(0xFFAA6E1A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sheetTitle(context, "DESCRIPTION"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: dashBoardBgColor_(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data.description?.isNotEmpty == true
                              ? data.description!
                              : "-",
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: primaryTextColor_(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sheetTitle(context, "REPORT DETAILS"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dashBoardBgColor_(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _conflictSheetDetailRow(context, "Reported By",
                                data.reportedByName ?? "-"),
                            _conflictSheetDetailRow(
                                context, "Hazard", data.hazardName ?? "-"),
                            _conflictSheetDetailRow(context, "Conflict Type",
                                _formatConflictType(data.conflictType)),
                            _conflictSheetDetailRow(
                                context, "Record ID", "#${data.recordId ?? 0}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D7D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final rid = data.recordId ?? 0;
                    final ctype = (data.conflictType ?? "").trim();
                    if (rid == 0 || ctype.isEmpty) return;
                    AlertDialogHelper.showAlertDialog(
                      "",
                      'are_you_sure_you_want_to_resolve'.tr,
                      'yes'.tr,
                      'no'.tr,
                      "",
                      true,
                      false,
                      _HealthSafetyResolveConflictListener(ctype, rid),
                      AppConstants.dialogIdentifier.healthSafetyConflictResolve,
                    );
                  },
                  child: const Text(
                    "Mark as Resolved",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  String _formatConflictType(String? conflictType) {
    if ((conflictType ?? "").isEmpty) return "-";
    return conflictType!
        .split("_")
        .map((e) => e.isEmpty
            ? ""
            : "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .join(" ");
  }
}

class _StoreResolveConflictListener implements DialogButtonClickListener {
  _StoreResolveConflictListener(this.conflictType, this.productId, this.storeId);

  final String conflictType;
  final int productId;
  final int storeId;

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    _dismissConflictAlertAndBottomSheet();
    Get.find<ConflictsController>().resolveStoreConflict(
      conflictType: conflictType,
      productId: productId,
      storeId: storeId,
    );
  }
}

class _StoreConflictTile extends StatelessWidget {
  const _StoreConflictTile({required this.data});

  final StoreConflictData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor_(context),
      child: InkWell(
        onTap: () => _openStoreConflictDetails(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: (data.productThumbImage ?? "").isNotEmpty
                    ? NetworkImage(data.productThumbImage!)
                    : null,
                child: (data.productThumbImage ?? "").isEmpty
                    ? const Icon(Icons.store, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.productShortName ?? "-",
                            style: TextStyle(
                                color: primaryTextColor_(context),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8FA),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Text(
                            data.storeName ?? "",
                            style: const TextStyle(
                              color: Color(0xFF12AFC5),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.message ?? "",
                      style: TextStyle(color: secondaryLightTextColor_(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStoreConflictDetails(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor:
          isDarkMode ? const Color(0xCC121826) : const Color(0x99000000),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: backgroundColor_(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (data.productThumbImage ?? "").isNotEmpty
                                    ? NetworkImage(data.productThumbImage!)
                                    : null,
                            child: (data.productThumbImage ?? "").isEmpty
                                ? const Icon(Icons.inventory_2_outlined, size: 18)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _conflictSheetHeaderLine(
                                  context,
                                  text: data.productShortName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _conflictSheetHeaderLine(
                                  context,
                                  text: data.storeName ?? "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: secondaryLightTextColor_(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F8FA),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: const Text(
                              "Amount Exceeded",
                              style: TextStyle(
                                color: Color(0xFF12AFC5),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _sheetTitle(context, "STOCK OVERVIEW"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFFFA94D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data.message ?? "",
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Color(0xFFAA6E1A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _metricCard(
                              context,
                              title: "QTY",
                              value: "${data.currentQty ?? 0}",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _metricCard(
                              context,
                              title: "UNIT PRICE",
                              value: "${data.currency ?? ""}${data.price ?? "0"}",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _metricCard(
                              context,
                              title: "TOTAL",
                              value:
                                  "${data.currency ?? ""}${data.totalAmount ?? "0"}",
                              valueColor: const Color(0xFFE23D3D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _sheetTitle(context, "PRODUCT DETAILS"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dashBoardBgColor_(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _conflictSheetDetailRow(
                                context, "Product", data.productShortName ?? "-"),
                            _conflictSheetDetailRow(
                                context, "Store", data.storeName ?? "-"),
                            _conflictSheetDetailRow(
                              context,
                              "Conflict Type",
                              _formatConflictType(data.conflictType),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
                decoration: BoxDecoration(
                  color: backgroundColor_(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetTitle(context, "RESOLUTION"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D7D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final sid = data.storeId ?? 0;
                          final pid = data.productId ?? 0;
                          final ctype = (data.conflictType ?? "").trim();
                          if (sid == 0 || pid == 0 || ctype.isEmpty) return;
                          AlertDialogHelper.showAlertDialog(
                            "",
                            'are_you_sure_you_want_to_resolve'.tr,
                            'yes'.tr,
                            'no'.tr,
                            "",
                            true,
                            false,
                            _StoreResolveConflictListener(ctype, pid, sid),
                            AppConstants.dialogIdentifier.storeConflictResolve,
                          );
                        },
                        child: const Text(
                          "Mark as Resolved",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metricCard(
    BuildContext context, {
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: dashBoardBgColor_(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: secondaryLightTextColor_(context),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? primaryTextColor_(context),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: secondaryLightTextColor_(context),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  String _formatConflictType(String? conflictType) {
    if ((conflictType ?? "").isEmpty) return "-";
    return conflictType!
        .split("_")
        .map((e) => e.isEmpty
            ? ""
            : "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .join(" ");
  }
}

class _BaseTile extends StatelessWidget {
  const _BaseTile({
    required this.imageUrl,
    required this.title,
    required this.tagText,
    required this.tagColor,
    required this.tagTextColor,
    required this.subtitleTop,
    required this.subtitleBottom,
    this.onTap,
  });

  final String? imageUrl;
  final String title;
  final String tagText;
  final Color tagColor;
  final Color tagTextColor;
  final String subtitleTop;
  final String subtitleBottom;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor_(context),
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: (imageUrl ?? "").isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : null,
                child: (imageUrl ?? "").isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: primaryTextColor_(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (tagText.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Text(
                              tagText,
                              style: TextStyle(
                                color: tagTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    if (subtitleTop.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitleTop,
                        style: TextStyle(
                          color: secondaryLightTextColor_(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (subtitleBottom.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleBottom,
                        style: TextStyle(
                          color: secondaryTextColor_(context),
                          fontSize: 13,
                        ),
                      ),
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
}

/// Timesheet conflict row: always 2 items; label from start/end rules.
class _TimesheetBadgeStyle {
  const _TimesheetBadgeStyle(this.label, this.background, this.foreground);
  final String label;
  final Color background;
  final Color foreground;
}

String _formatTimeRange(String? start, String? end) {
  return '${start ?? '--:--'}\u2013${end ?? '--:--'}';
}

int? _timeToMinutes(String? t) {
  if (t == null || t.trim().isEmpty) return null;
  final parts = t.trim().split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}

/// Inner strictly inside outer: outerStart < innerStart && innerEnd < outerEnd
bool _strictlyInside(int outerS, int outerE, int innerS, int innerE) {
  return outerS < innerS && innerE < outerE;
}

enum _TimesheetResolutionKind { cutAndDelete, splitAndDelete, deleteOnly }

_TimesheetResolutionKind _resolveTimesheetResolutionKind(
    ConflictItem a, ConflictItem b) {
  final s1 = _timeToMinutes(a.start);
  var e1 = _timeToMinutes(a.end);
  final s2 = _timeToMinutes(b.start);
  var e2 = _timeToMinutes(b.end);
  if (s1 == null || e1 == null || s2 == null || e2 == null) {
    return _TimesheetResolutionKind.deleteOnly;
  }

  var ts1 = s1;
  var te1 = e1 < ts1 ? ts1 : e1;
  var ts2 = s2;
  var te2 = e2 < ts2 ? ts2 : e2;

  if (ts1 == ts2 && te1 != te2) {
    return _TimesheetResolutionKind.cutAndDelete;
  }

  if (_strictlyInside(ts1, te1, ts2, te2)) {
    final innerLen = te2 - ts2;
    return innerLen > 0
        ? _TimesheetResolutionKind.deleteOnly
        : _TimesheetResolutionKind.splitAndDelete;
  }
  if (_strictlyInside(ts2, te2, ts1, te1)) {
    final innerLen = te1 - ts1;
    return innerLen > 0
        ? _TimesheetResolutionKind.deleteOnly
        : _TimesheetResolutionKind.splitAndDelete;
  }

  return _TimesheetResolutionKind.deleteOnly;
}

_TimesheetBadgeStyle _timesheetBadgeForKind(_TimesheetResolutionKind kind) {
  switch (kind) {
    case _TimesheetResolutionKind.cutAndDelete:
      return const _TimesheetBadgeStyle(
        'Cut & Delete',
        Color(0xFFFFF4D6),
        Color(0xFF7A4A12),
      );
    case _TimesheetResolutionKind.splitAndDelete:
      return const _TimesheetBadgeStyle(
        'Split & Delete',
        Color(0xFFF1E8FF),
        Color(0xFF8B5CF6),
      );
    case _TimesheetResolutionKind.deleteOnly:
      return const _TimesheetBadgeStyle(
        'Delete Only',
        Color(0xFFFFE8E8),
        Color(0xFFE23D3D),
      );
  }
}

_TimesheetBadgeStyle _resolveTimesheetConflictLabel(ConflictItem a, ConflictItem b) {
  return _timesheetBadgeForKind(_resolveTimesheetResolutionKind(a, b));
}

class _ConflictSection {
  _ConflictSection({
    required this.title,
    required this.badgeColor,
    required this.items,
  });

  final String title;
  final Color badgeColor;
  final List<Widget> items;
}
