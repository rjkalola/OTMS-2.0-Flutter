import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/archive_shift_list/controller/archive_shift_list_controller.dart';
import 'package:belcka/pages/shifts/create_shift/model/shift_info.dart';
import 'package:belcka/pages/shifts/shift_list/view/widgets/break_list.dart';
import 'package:belcka/pages/teams/team_list/model/team_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../../../../utils/app_constants.dart';

class ArchiveShiftsList extends StatelessWidget {
  ArchiveShiftsList({super.key});

  final controller = Get.put(ArchiveShiftListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ShiftInfo info = controller.shiftList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    borderRadius: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextView(
                                    text: info.name ?? "",
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  SubtitleTextView(
                                    text:
                                        "${'shift'.tr}: ${info.startTime} - ${info.endTime}",
                                  ),
                                  BreakList(breakList: info.breaks ?? [])
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.unArchiveShiftApi(
                                    info.id ?? 0, position);
                              },
                              child: ImageUtils.setSvgAssetsImage(
                                  path: Drawable.unArchiveIcon,
                                  color: defaultAccentColor_(context),
                                  width: 28,
                                  height: 28),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.showDeleteShiftDialog(
                                    info.id ?? 0, position);
                              },
                              child: ImageUtils.setSvgAssetsImage(
                                  path: Drawable.deletePermanentIcon,
                                  color: Colors.red,
                                  width: 24,
                                  height: 24),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.shiftList.length,
              /* separatorBuilder: (context, position) => const Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor,
                      thickness: 2,
                    ),
                  )),*/
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
