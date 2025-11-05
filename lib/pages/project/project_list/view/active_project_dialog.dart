import 'dart:math';

import 'package:belcka/pages/check_in/check_in/model/type_of_work_resources_info.dart';
import 'package:belcka/pages/common/listener/select_item_listener.dart';
import 'package:belcka/pages/common/listener/select_type_of_work_listener.dart';
import 'package:belcka/pages/project/project_info/model/project_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveProjectDialog extends StatefulWidget {
  final List<ProjectInfo> list;
  final String dialogType;
  final int selectedProjectId;
  final SelectItemListener listener;

  const ActiveProjectDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.selectedProjectId,
      required this.listener});

  @override
  State<ActiveProjectDialog> createState() =>
      ActiveProjectDialogState(dialogType, list, selectedProjectId, listener);
}

class ActiveProjectDialogState extends State<ActiveProjectDialog> {
  List<ProjectInfo> list;
  int selectedProjectId;
  String dialogType;
  SelectItemListener listener;
  final tempList = <ProjectInfo>[].obs;
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  ActiveProjectDialogState(
      this.dialogType, this.list, this.selectedProjectId, this.listener);

  @override
  void initState() {
    tempList.clear();
    tempList.value = list;

    // final checkedIds = selectedItemList
    //     .where((e) => e.isCheck == true)
    //     .map((e) => e.id)
    //     .toSet();

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
            SizedBox(
              height: 12,
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TitleTextView(
                    text: 'projects'.tr,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
                // Expanded(
                //   child: SearchTextFieldDark(
                //     controller: searchController,
                //     isClearVisible: isClearVisible,
                //     hint: 'search_task'.tr,
                //     label: 'search_task'.tr,
                //     onValueChange: (value) {
                //       filterSearchResults(value.toString(), list);
                //       isClearVisible.value =
                //           !StringHelper.isEmptyString(value.toString());
                //     },
                //     onPressedClear: () {
                //       searchController.value.clear();
                //       filterSearchResults("", list);
                //       isClearVisible.value = false;
                //     },
                //   ),
                // ),
              ],
            ),
            Flexible(child: setDropdownList(dialogType, listener)),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      );
    });
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) => Obx(
        () => Container(
          margin: const EdgeInsets.only(top: 0),
          child: ListView.builder(
            itemCount: tempList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              ProjectInfo info = tempList[i];
              return CardViewDashboardItem(
                  elevation: 1,
                  shadowColor: Colors.black45,
                  borderRadius: 16,
                  margin: EdgeInsets.fromLTRB(16, 7, 16, 7),
                  padding: EdgeInsets.fromLTRB(16, 9, 8, 9),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            var arguments = {
                              AppConstants.intentKey.projectId: info.id ?? 0,
                            };
                            Get.toNamed(AppRoutes.projectDetailsScreen,
                                arguments: arguments);
                          },
                          child: TitleTextView(
                            text: tempList[i].name ?? "",
                            fontSize: 17,
                          ),
                        ),
                      ),
                      (info.id != selectedProjectId)
                          ? CustomSwitch(
                              onValueChange: (value) {
                                info.isActive = !(info.isActive ?? false);
                                tempList.refresh();
                                listener.onSelectItem(i, tempList[i].id ?? 0,
                                    tempList[i].name ?? "", dialogType);
                                Get.back();
                              },
                              mValue: (info.id == selectedProjectId))
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 9, 6),
                              child: TitleTextView(
                                text: 'active'.tr,
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                    ],
                  ));
            },
          ),
        ),
      );

  void filterSearchResults(String query, List<ProjectInfo> list) {
    List<ProjectInfo> dummySearchList = <ProjectInfo>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      List<ProjectInfo> dummyListData = <ProjectInfo>[];
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
}
