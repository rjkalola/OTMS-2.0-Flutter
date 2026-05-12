import 'package:belcka/pages/conflicts/controller/conflicts_controller.dart';
import 'package:belcka/pages/conflicts/model/conflicts_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConflictsListView extends StatelessWidget {
  ConflictsListView({super.key});

  final controller = Get.find<ConflictsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sections = _sectionsForSelectedTab(controller.selectedTab.value);
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

  List<_ConflictSection> _sectionsForSelectedTab(String selectedTab) {
    if (selectedTab == ConflictsTab.timesheet.value) {
      return [_timesheetSection];
    }
    if (selectedTab == ConflictsTab.billing.value) {
      return [_billingSection];
    }
    if (selectedTab == ConflictsTab.team.value) {
      return [_teamSection];
    }
    if (selectedTab == ConflictsTab.healthSafety.value) {
      return [_healthSafetySection];
    }
    if (selectedTab == ConflictsTab.store.value) {
      return [_storeSection];
    }
    return [
      _timesheetSection,
      _billingSection,
      _teamSection,
      _healthSafetySection,
      _storeSection,
    ];
  }

  _ConflictSection get _timesheetSection => _ConflictSection(
        title: 'Timesheet Conflicts',
        badgeColor: const Color(0xFFFFA300),
        items: controller.timesheetConflicts
            .map((e) => _UserConflictTile(data: e, isTimesheet: true))
            .toList(),
      );

  _ConflictSection get _billingSection => _ConflictSection(
        title: 'Billing Conflicts',
        badgeColor: const Color(0xFF5663FF),
        items: controller.billingConflicts
            .map((e) => _UserConflictTile(data: e, isTimesheet: false))
            .toList(),
      );

  _ConflictSection get _teamSection => _ConflictSection(
        title: 'Team Conflicts',
        badgeColor: const Color(0xFF8B5CF6),
        items: controller.teamConflicts
            .map((e) => _TeamConflictTile(data: e))
            .toList(),
      );

  _ConflictSection get _healthSafetySection => _ConflictSection(
        title: 'Health & Safety Conflicts',
        badgeColor: const Color(0xFFEF4444),
        items: controller.healthSafetyConflicts
            .map((e) => _HealthSafetyConflictTile(data: e))
            .toList(),
      );

  _ConflictSection get _storeSection => _ConflictSection(
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
    final item = data.items?.isNotEmpty == true ? data.items!.first : null;
    final subtitle = isTimesheet
        ? "${item?.start ?? '--:--'}-${item?.end ?? '--:--'}"
        : (item?.message ?? "");
    final badgeText = isTimesheet
        ? ((item?.isLeave ?? false) ? 'Delete Only' : 'Split & Delete')
        : 'Billing Info';
    final badgeColor = isTimesheet
        ? ((item?.isLeave ?? false)
            ? const Color(0xFFFFE8E8)
            : const Color(0xFFF1E8FF))
        : const Color(0xFFE7EEFF);
    final badgeTextColor = isTimesheet
        ? ((item?.isLeave ?? false)
            ? const Color(0xFFE23D3D)
            : const Color(0xFF8B5CF6))
        : const Color(0xFF4E63DD);

    return _BaseTile(
      imageUrl: data.userThumbImage ?? data.userImage,
      title: data.userName ?? "-",
      tagText: badgeText,
      tagColor: badgeColor,
      tagTextColor: badgeTextColor,
      subtitleTop: data.formattedDate ?? data.date ?? "",
      subtitleBottom: subtitle,
    );
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
                                Text(
                                  data.teamName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
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
                            _teamDetailRow(
                                context, "Team Name", data.teamName ?? "-"),
                            _teamDetailRow(context, "Supervisor",
                                data.supervisorName ?? "-"),
                            _teamDetailRow(
                              context,
                              "Conflict Type",
                              _formatTeamConflictType(data.conflictType),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _teamSheetTitle(context, "RESOLUTION"),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
                child: Column(
                  children: [
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
                        onPressed: () {},
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

  Widget _teamDetailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: secondaryLightTextColor_(context),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                                Text(
                                  data.reportedByName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.hazardName ?? "",
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
                          style: TextStyle(
                            color: primaryTextColor_(context),
                            fontSize: 13,
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
                            _detailRow(context, "Reported By",
                                data.reportedByName ?? "-"),
                            _detailRow(
                                context, "Hazard", data.hazardName ?? "-"),
                            _detailRow(context, "Conflict Type",
                                _formatConflictType(data.conflictType)),
                            _detailRow(
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
                  onPressed: () {},
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

  Widget _detailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: secondaryLightTextColor_(context),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                                Text(
                                  data.productShortName ?? "-",
                                  style: TextStyle(
                                    color: primaryTextColor_(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.storeName ?? "",
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
                            _detailRow(context, "Product", data.productShortName ?? "-"),
                            _detailRow(context, "Store", data.storeName ?? "-"),
                            _detailRow(
                              context,
                              "Conflict Type",
                              _formatConflictType(data.conflictType),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sheetTitle(context, "RESOLUTION"),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
                child: Column(
                  children: [
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
                        onPressed: () {},
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
              fontWeight: FontWeight.w700,
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

  Widget _detailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: secondaryLightTextColor_(context),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: primaryTextColor_(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
