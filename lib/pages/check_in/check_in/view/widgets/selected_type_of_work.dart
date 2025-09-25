import 'package:belcka/pages/check_in/check_in/controller/check_in_controller.dart';
import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedTypeOfWork extends StatelessWidget {
  SelectedTypeOfWork({super.key});

  final controller = Get.put(CheckInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.selectedTypeOfWorkList.isNotEmpty,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            itemCount: controller.selectedTypeOfWorkList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              TypeOfWorkResourcesInfo info =
                  controller.selectedTypeOfWorkList[i];
              return Stack(
                children: [
                  CardViewDashboardItem(
                      elevation: 1,
                      shadowColor: Colors.black45,
                      borderRadius: 16,
                      margin: EdgeInsets.fromLTRB(0, 14, 0, 14),
                      padding: EdgeInsets.fromLTRB(16, 9, 12, 9),
                      child: Row(
                        children: [
                          Expanded(
                            child: TitleTextView(
                              text: info.name ?? "",
                              fontSize: 17,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.onSelectTypeOfWorkPhotos(i);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48,
                              width: 48,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration:
                                        AppUtils.getGrayBorderDecoration(
                                            borderWidth: 1,
                                            borderColor: ThemeConfig.isDarkMode
                                                ? Colors.white
                                                : Colors.black26,
                                            radius: 45),
                                    alignment: Alignment.center,
                                    height: 36,
                                    width: 36,
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 22,
                                    ),
                                  ),
                                  !StringHelper.isEmptyList(
                                          info.beforeAttachments)
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            size: 22,
                                            color: Colors.green,
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.add_circle_outlined,
                                            size: 22,
                                            color: defaultAccentColor_(context),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        textContainerItem(
                            info.tradeName ?? "", AppUtils.getColor("#FF7F00")),
                         textContainerItem(
                            info.duration ?? "", AppUtils.getColor("#7523D3")),
                        (info.isPricework ?? false)
                            ? textContainerItem(
                                info.rate ?? "", AppUtils.getColor("#FF008C"))
                            : textContainerItem(info.repeatableJob ?? "",
                                AppUtils.getColor("#32A852")),
                        textContainerItem(info.locationName ?? "",
                            AppUtils.getColor("#F44336")),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget textContainerItem(String text, Color boxColor) {
    return !StringHelper.isEmptyString(text)
        ? Padding(
            padding: const EdgeInsets.only(right: 6, top: 4),
            child: TextViewWithContainer(
              alignment: Alignment.center,
              height: 22,
              text: text ?? "",
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              fontColor: Colors.white,
              fontSize: 12,
              boxColor: boxColor,
              borderRadius: 5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          )
        : Container();
  }
}
