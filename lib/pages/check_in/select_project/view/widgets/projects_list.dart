import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/check_in/select_project/controller/select_project_controller.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class ProjectsList extends StatelessWidget {
  ProjectsList({super.key});

  final controller = Get.put(SelectProjectController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                ModuleInfo info = controller.projectsList[position];
                return CardViewDashboardItem(
                    elevation: 1,
                    shadowColor: Colors.black45,
                    borderRadius: 12,
                    margin: EdgeInsets.fromLTRB(14, 6, 14, 6),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: InkWell(
                        onTap: () {
                          controller.moveToScreen(info.id ?? 0);
                        },
                        child: Row(
                          children: [
                            CircleWidget(
                                color: Color(
                                    AppUtils.haxColor(info.randomColor ?? "")),
                                width: 20,
                                height: 20),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: TitleTextView(
                                text: info.name ?? "",
                                fontSize: 17,
                              ),
                            ),
                            RightArrowWidget()
                          ],
                        ),
                      ),
                    ));
              },
              itemCount: controller.projectsList.length,
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
