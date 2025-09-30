import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/check_in/check_out/controller/check_out_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/theme/theme_config.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/shapes/badge_count_widget.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedTypeOfWork extends StatelessWidget {
  SelectedTypeOfWork({super.key});

  final controller = Get.put(CheckOutController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.selectedTypeOfWorkList.isNotEmpty,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            itemCount: controller.selectedTypeOfWorkList.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              TypeOfWorkResourcesInfo info =
                  controller.selectedTypeOfWorkList[i];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.typeOfWorkDetails(info);
                    },
                    child: CardViewDashboardItem(
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
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (StringHelper.isEmptyString(controller
                                        .checkLogInfo.value.checkoutDateTime)) {
                                      controller.onSelectTypeOfWorkPhotos(i);
                                    } else {
                                      controller.typeOfWorkDetails(info);
                                    }
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
                                                  borderColor:
                                                      ThemeConfig.isDarkMode
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
                                                info.afterAttachments)
                                            ? Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 22,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Icon(
                                                  Icons.add_circle_outlined,
                                                  size: 22,
                                                  color: defaultAccentColor_(
                                                      context),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (StringHelper.isEmptyString(controller
                                        .checkLogInfo.value.checkoutDateTime)) {
                                      showNumberPicker(
                                          context,
                                          (info.progress ?? 0) != 0
                                              ? (info.progress ?? 0)
                                              : 100,
                                          i);
                                    }else {
                                      controller.typeOfWorkDetails(info);
                                    }
                                  },
                                  child: Container(
                                    width: 44,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    decoration:
                                        AppUtils.getGrayBorderDecoration(
                                            radius: 9,
                                            borderColor:
                                                secondaryExtraLightTextColor_(
                                                    context)),
                                    child: TitleTextView(
                                      fontSize: 15,
                                      text: ((info.progress ?? 0) != 0
                                              ? (info.progress ?? 0)
                                              : 100)
                                          .toString(),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  ),
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

  void showNumberPicker(BuildContext context, int progress, int position) {
    int finalProgress = progress;
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: dashBoardBgColor_(context),
        child: Column(
          children: [
            // Done button row
            Container(
              color: titleBgColor_(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'progress'.tr,
                      style: TextStyle(
                        fontSize: 17,
                        color: primaryTextColor_(context),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none, // no underline
                      ),
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      "Done",
                      style: TextStyle(color: defaultAccentColor_(context)),
                    ),
                    onPressed: () {
                      controller.selectedTypeOfWorkList[position].progress =
                          finalProgress;
                      controller.selectedTypeOfWorkList.refresh();
                      Get.back();
                    },
                  )
                ],
              ),
            ),

            // Roller picker
            Expanded(
              child: CupertinoPicker(
                backgroundColor: backgroundColor_(context),
                scrollController: FixedExtentScrollController(
                    initialItem: progress > 0 ? (progress - 1) : 0),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  finalProgress = (index + 1);
                  print("Progress:" + finalProgress.toString());
                },
                children: List<Widget>.generate(100, (index) {
                  final num = index + 1;
                  return Center(
                    child: Text(
                      num.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
