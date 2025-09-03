import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/dialog_title_view.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/search_text_field.dart';

import '../../res/colors.dart';
import 'listener/select_item_listener.dart';

class DropDownListDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String title;
  final String dialogType;
  final SelectItemListener listener;
  final bool isCloseEnable;
  final bool isSearchEnable;

  const DropDownListDialog(
      {super.key,
      required this.title,
      required this.dialogType,
      required this.list,
      required this.isCloseEnable,
      required this.listener,
      required this.isSearchEnable});

  @override
  State<DropDownListDialog> createState() => DropDownListDialogState(
      title, dialogType, list, listener, isCloseEnable, isSearchEnable);
}

class DropDownListDialogState extends State<DropDownListDialog> {
  List<ModuleInfo> list;
  String title;
  String dialogType;
  SelectItemListener listener;
  List<ModuleInfo> tempList = [];
  bool isCloseEnable, isSearchEnable;
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  DropDownListDialogState(this.title, this.dialogType, this.list, this.listener,
      this.isCloseEnable, this.isSearchEnable);

  @override
  void initState() {
    tempList.clear();
    tempList.addAll(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Set a max height for bottom sheet (e.g. 80% of screen)
        double maxHeight = constraints.maxHeight * 0.8;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: backgroundColor_(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DialogTitleView(
                title: title,
              ),
              Visibility(
                visible: isSearchEnable,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                  child: SizedBox(
                    height: 44,
                    child: SearchTextField(
                      controller: searchController,
                      isClearVisible: isClearVisible,
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
              ),
              Flexible(child: setDropdownList(dialogType, listener))
            ]),
          ),
        );
      },
    );
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 6, bottom: 10),
        child: ListView.builder(
          itemCount: tempList.length,
          // scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () {
                Get.back();
                listener.onSelectItem(
                    i, tempList[i].id ?? 0, tempList[i].name ?? "", dialogType);
              },
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              minVerticalPadding: 0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Text(
                  tempList[i].name ?? "",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17,
                      color: primaryTextColor_(context),
                      fontWeight: FontWeight.w400),
                ),
              ),
            );
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
}
