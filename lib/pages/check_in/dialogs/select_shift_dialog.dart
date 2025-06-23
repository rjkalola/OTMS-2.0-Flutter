import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/resources_shift_info.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/right_arrow_widget.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';
import 'package:otm_inventory/widgets/textfield/search_text_field_dark.dart';

class SelectShiftDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String dialogType;
  final SelectItemListener listener;

  const SelectShiftDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<SelectShiftDialog> createState() =>
      SelectShiftDialogState(dialogType, list, listener);
}

class SelectShiftDialogState extends State<SelectShiftDialog> {
  List<ModuleInfo> list;
  String dialogType;
  SelectItemListener listener;
  List<ModuleInfo> tempList = [];
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  SelectShiftDialogState(this.dialogType, this.list, this.listener);

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
          decoration: const BoxDecoration(
              color: dashBoardBgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 3,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TitleTextView(
                    text: 'select_shift'.tr,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, size: 20),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: SizedBox(
                height: 44,
                child: SearchTextFieldDark(
                  controller: searchController,
                  isClearVisible: isClearVisible,
                  hint: 'Search shift...',
                  label: 'Search shift...',
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
            ),
            Flexible(child: setDropdownList(dialogType, listener)),
            SizedBox(
              height: 18,
            ),
          ]),
        ),
      );
    });
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: tempList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return CardViewDashboardItem(
                elevation: 1,
                shadowColor: Colors.black45,
                borderRadius: 16,
                margin: EdgeInsets.fromLTRB(11, 6, 11, 6),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      listener.onSelectItem(i, tempList[i].id ?? 0,
                          tempList[i].name ?? "", dialogType);
                    },
                    child: Row(
                      children: [
                        CircleWidget(
                            color: getRandomColor(), width: 20, height: 20),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TitleTextView(
                            text: tempList[i].name ?? "Shift 1",
                            fontSize: 17,
                          ),
                        ),
                        RightArrowWidget()
                      ],
                    ),
                  ),
                ));
          },
        ),
      );

  void filterSearchResults(String query, List<ModuleInfo> list) {
    List<ModuleInfo> dummySearchList = <ModuleInfo>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      List<ModuleInfo> dummyListData = <ModuleInfo>[];
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
}
