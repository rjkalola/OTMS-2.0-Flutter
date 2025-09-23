import 'dart:math';

import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/common/listener/select_type_of_work_listener.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTypeOfWorkDialog extends StatefulWidget {
  final List<TypeOfWorkResourcesInfo> list, selectedItemList;
  final String dialogType;
  final SelectTypeOfWorkListener listener;

  const SelectTypeOfWorkDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.selectedItemList,
      required this.listener});

  @override
  State<SelectTypeOfWorkDialog> createState() =>
      SelectTypeOfWorkDialogState(dialogType, list, selectedItemList, listener);
}

class SelectTypeOfWorkDialogState extends State<SelectTypeOfWorkDialog> {
  List<TypeOfWorkResourcesInfo> list, selectedItemList;
  String dialogType;
  SelectTypeOfWorkListener listener;
  final tempList = <TypeOfWorkResourcesInfo>[].obs;
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  SelectTypeOfWorkDialogState(
      this.dialogType, this.list, this.selectedItemList, this.listener);

  @override
  void initState() {
    tempList.clear();
    // tempList.value = list.map((e) => e.copyWith()).toList();

    print("selectedItemList size:" + selectedItemList.length.toString());

    // final checkedIds = selectedItemList
    //     .where((e) => e.isCheck == true)
    //     .map((e) => e.id)
    //     .toSet();

    final List<String> typeOfWorkIds = [];
    final List<String> companyTaskIds = [];
    for (var item in selectedItemList) {
      typeOfWorkIds.add((item.typeOfWorkId ?? 0).toString());
      companyTaskIds.add((item.companyTaskId ?? 0).toString());
    }

    tempList.value = list.map((e) {
      final isChecked = typeOfWorkIds.contains(e.typeOfWorkId.toString()) &&
          companyTaskIds.contains(e.companyTaskId.toString());
      return e.copyWith(isCheck: isChecked);
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight * 0.8;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: dashBoardBgColor_(context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 24,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: SearchTextFieldDark(
                      controller: searchController,
                      isClearVisible: isClearVisible,
                      hint: 'search_task'.tr,
                      label: 'search_task'.tr,
                      onValueChange: (value) {
                        filterSearchResults(value.toString(), list);
                        isClearVisible.value =
                            !StringHelper.isEmptyString(value.toString());
                      },
                      onPressedClear: () {
                        searchController.value.clear();
                        filterSearchResults("", list);
                        isClearVisible.value = false;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 26,
                    ),
                    onPressed: () {
                      Get.back();
                      // listener.onSelectTypeOfWork(0, 0, 0, "",
                      //     AppConstants.dialogIdentifier.selectTypeOfDayWork);
                      listener.onSelectTypeOfWork(tempList,
                          AppConstants.dialogIdentifier.selectTypeOfDayWork);
                    },
                  ),
                ],
              ),
            ),
            Flexible(child: setDropdownList(dialogType, listener)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: PrimaryButton(
                        buttonText: 'select'.tr,
                        onPressed: () {
                          Get.back();
                          List<TypeOfWorkResourcesInfo> listItems = [];
                          for (var info in tempList) {
                            if (info.isCheck ?? false) {
                              listItems.add(info);
                            }
                          }
                          listener.onSelectTypeOfWork(listItems, dialogType);
                        }),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    child: PrimaryBorderButton(
                        buttonText: 'cancel'.tr,
                        borderColor: secondaryLightTextColor_(context),
                        fontColor: secondaryLightTextColor_(context),
                        onPressed: () {
                          Get.back();
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
          ]),
        ),
      );
    });
  }

  Widget setDropdownList(
          String dialogType, SelectTypeOfWorkListener listener) =>
      Obx(
        () => Container(
          margin: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemCount: tempList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              TypeOfWorkResourcesInfo info = tempList[i];
              return Stack(
                children: [
                  CardViewDashboardItem(
                      elevation: 1,
                      shadowColor: Colors.black45,
                      borderRadius: 16,
                      margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
                      padding: EdgeInsets.fromLTRB(16, 4, 4, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                /* Get.back();
                                listener.onSelectTypeOfWork(
                                    i,
                                    tempList[i].typeOfWorkId ?? 0,
                                    tempList[i].companyTaskId ?? 0,
                                    tempList[i].name ?? "",
                                    dialogType);*/
                                info.isCheck = !(info.isCheck ?? false);
                                tempList.refresh();
                              },
                              child: TitleTextView(
                                text: tempList[i].name ?? "",
                                fontSize: 17,
                              ),
                            ),
                          ),
                          CustomCheckbox(
                              onValueChange: (value) {
                                info.isCheck = !(info.isCheck ?? false);
                                tempList.refresh();
                              },
                              mValue: tempList[i].isCheck ?? false)
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Row(
                      children: [
                        textContainerItem(tempList[i].tradeName ?? "",
                            AppUtils.getColor("#FF7F00")),
                        textContainerItem(tempList[i].duration ?? "",
                            AppUtils.getColor("#7523D3")),
                        (tempList[i].isPricework ?? false)
                            ? textContainerItem(tempList[i].rate ?? "",
                                AppUtils.getColor("#FF008C"))
                            : textContainerItem(tempList[i].repeatableJob ?? "",
                                AppUtils.getColor("#32A852"))
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );

  void filterSearchResults(String query, List<TypeOfWorkResourcesInfo> list) {
    List<TypeOfWorkResourcesInfo> dummySearchList = <TypeOfWorkResourcesInfo>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      List<TypeOfWorkResourcesInfo> dummyListData = <TypeOfWorkResourcesInfo>[];
      for (var item in dummySearchList) {
        if (item.name!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        tempList.clear();
        tempList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        tempList.clear();
        tempList.addAll(list);
      });
    }
  }

  Color getRandomColor() {
    String color = "#CB4646DD";
    final random = Random();
    int randomNumber = random.nextInt(DataUtils.listColors.length - 1);
    color = DataUtils.listColors[randomNumber];
    return Color(AppUtils.haxColor(color));
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
