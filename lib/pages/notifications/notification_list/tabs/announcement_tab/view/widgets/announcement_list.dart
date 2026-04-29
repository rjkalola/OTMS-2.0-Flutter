import 'package:belcka/pages/notifications/create_announcement/model/announcement_info.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/view/widgets/attachment_list.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/notifications/notification_list/tabs/announcement_tab/controller/announcement_tab_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

import '../../../../../../../utils/app_constants.dart';

class AnnouncementList extends StatelessWidget {
  AnnouncementList({super.key});

  final controller = Get.put(AnnouncementTabController());
  static const Map<String, String> _emojiByCode = {
    "1f60a": "😊",
    "1f620": "😠",
    "1f44d": "👍",
    "1f44e": "👎",
    "1f622": "😢",
  };

  Future<void> _showReactionMenu(
      BuildContext context, Offset position, AnnouncementInfo info) async {
    final selectedReaction = await showDialog<Map<String, String>>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            Positioned(
              left: (position.dx - 150).clamp(12.0, 2400.0),
              top: (position.dy - 72).clamp(50.0, 2400.0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: ThemeConfig.isDarkMode
                        ? AppUtils.getColor("#1f2129")
                        : Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: AnnouncementTabController.reactionOptions
                        .map(
                          (reaction) => InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(dialogContext)
                                .pop(reaction),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                reaction["emoji"] ?? "",
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedReaction != null) {
      controller.storeAnnouncementFeed(
        announcementId: info.announcementId ?? 0,
        emoji: selectedReaction["emoji"] ?? "",
        emojiCode: selectedReaction["code"] ?? "",
      );
    }
  }

  Map<String, int> _reactionCountMap(AnnouncementInfo info) {
    final map = <String, int>{};
    for (final feed in (info.feeds ?? <AnnouncementFeedInfo>[])) {
      final code = (feed.code ?? "").toLowerCase();
      final emoji = _emojiByCode[code] ?? feed.action ?? "";
      if (emoji.isEmpty) continue;
      map[emoji] = (map[emoji] ?? 0) + 1;
    }
    return map;
  }

  List<AnnouncementFeedInfo> _allFeeds(AnnouncementInfo info) {
    return (info.feeds ?? <AnnouncementFeedInfo>[]);
  }

  String _feedEmoji(AnnouncementFeedInfo feed) {
    final code = (feed.code ?? "").toLowerCase();
    return _emojiByCode[code] ?? feed.action ?? "";
  }

  void _showEmojiDetailsBottomSheet(BuildContext context, AnnouncementInfo info) {
    final emojiFeeds = _allFeeds(info);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeConfig.isDarkMode
          ? AppUtils.getColor("#1f2129")
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.62,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(sheetContext).pop(),
                        child: const Icon(Icons.arrow_back, size: 24),
                      ),
                      const SizedBox(width: 12),
                      PrimaryTextView(
                        text: "Feed Emoji Details",
                        fontSize: 17,
                        color: primaryTextColor_(sheetContext),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: emojiFeeds.isEmpty
                      ? Center(
                          child: PrimaryTextView(
                            text: "No reactions found",
                            fontSize: 15,
                            color: secondaryLightTextColor_(sheetContext),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          itemCount: emojiFeeds.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (_, index) {
                            final feed = emojiFeeds[index];
                            return Row(
                              children: [
                                UserAvtarView(
                                  imageUrl: feed.userThumbImage ??
                                      feed.userImage ??
                                      "",
                                  imageSize: 35,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: PrimaryTextView(
                                    text: feed.userName ?? "-",
                                    fontSize: 16,
                                    color: primaryTextColor_(sheetContext),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _feedEmoji(feed),
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReactionSummary(
      BuildContext context, AnnouncementInfo info, Color textColor) {
    final reactions = _reactionCountMap(info);
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: reactions.entries
            .map(
              (entry) => InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _showEmojiDetailsBottomSheet(context, info),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ThemeConfig.isDarkMode
                        ? AppUtils.getColor("#2d2f3a")
                        : AppUtils.getColor("#f1f3f5"),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.key, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 6),
                      Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              AnnouncementInfo info = controller.announcementList[position];
              return Padding(
                padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                child: CardViewDashboardItem(
                  boxColor: !(info.isRead ?? false)
                      ? ThemeConfig.isDarkMode
                          ? AppUtils.getColor("#22242f")
                          : AppUtils.getColor("#edf2fb")
                      : null,
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.announcementId: info.id ?? 0,
                        AppConstants.intentKey.announcementId: info.id ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.announcementDetailsScreen, arguments);
                    },
                    onLongPressStart: (details) {
                      _showReactionMenu(
                          context, details.globalPosition, info);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: UserAvtarView(
                              imageUrl: info.senderThumbImage ?? "",
                              imageSize: 52,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: PrimaryTextView(
                                    text:
                                        "Announcement from ${info.senderName ?? ""}: ${info.name ?? ""}",
                                    fontSize: 17,
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                AttachmentList(
                                  onGridItemClick: controller.onGridItemClick,
                                  filesList: info.documents!.obs,
                                  parentIndex: position,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12, top: 2),
                                  child: PrimaryTextView(
                                    text: info.date ?? "",
                                    fontSize: 14,
                                    color: secondaryLightTextColor_(context),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                _buildReactionSummary(
                                  context,
                                  info,
                                  secondaryLightTextColor_(context),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: controller.announcementList.length,
            // separatorBuilder: (context, position) => const Padding(
            //   padding: EdgeInsets.only(left: 100),
            //   child: Divider(
            //     height: 0,
            //     color: dividerColor,
            //     thickness: 0.8,
            //   ),
            // ),
            separatorBuilder: (context, position) => Container()),
      ),
    );
  }
}
