import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:otm_inventory/pages/check_in/check_in/model/type_of_work_resources_response.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/listener/select_type_of_work_listener.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';
import 'package:otm_inventory/widgets/textfield/search_text_field_dark.dart';

class SelectTypeOfWorkDialog extends StatefulWidget {
  final List<TypeOfWorkResourcesInfo> list;
  final String dialogType;
  final SelectTypeOfWorkListener listener;

  const SelectTypeOfWorkDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<SelectTypeOfWorkDialog> createState() =>
      SelectTypeOfWorkDialogState(dialogType, list, listener);
}

class SelectTypeOfWorkDialogState extends State<SelectTypeOfWorkDialog> {
  List<TypeOfWorkResourcesInfo> list;
  String dialogType;
  SelectTypeOfWorkListener listener;
  List<TypeOfWorkResourcesInfo> tempList = [];
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  SelectTypeOfWorkDialogState(this.dialogType, this.list, this.listener);

  @override
  void initState() {
    tempList.clear();
    tempList.addAll(list);
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
                      listener.onSelectTypeOfWork(0, 0, 0, "",
                          AppConstants.dialogIdentifier.selectTypeOfDayWork);
                    },
                  ),
                ],
              ),
            ),
            Flexible(child: setDropdownList(dialogType, listener)),
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
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: tempList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Stack(
              children: [
                CardViewDashboardItem(
                    elevation: 1,
                    shadowColor: Colors.black45,
                    borderRadius: 16,
                    margin: EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          listener.onSelectTypeOfWork(
                              i,
                              tempList[i].typeOfWorkId ?? 0,
                              tempList[i].companyTaskId ?? 0,
                              tempList[i].name ?? "",
                              dialogType);
                        },
                        child: TitleTextView(
                          text: tempList[i].name ?? "",
                          fontSize: 17,
                        ),
                      ),
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
