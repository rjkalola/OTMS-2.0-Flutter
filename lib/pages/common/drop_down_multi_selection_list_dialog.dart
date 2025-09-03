import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/search_text_field.dart';

import '../../res/colors.dart';
import 'listener/select_multi_item_listener.dart';

class DropDownMultiSelectionListDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String title;
  final String dialogType;
  final SelectMultiItemListener listener;

  const DropDownMultiSelectionListDialog(
      {super.key,
      required this.title,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<DropDownMultiSelectionListDialog> createState() =>
      DropDownMultiSelectionListDialogState(title, dialogType, list, listener);
}

class DropDownMultiSelectionListDialogState
    extends State<DropDownMultiSelectionListDialog> {
  List<ModuleInfo> list;
  String title;
  String dialogType;
  SelectMultiItemListener listener;
  List<ModuleInfo> tempList = [];
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  DropDownMultiSelectionListDialogState(
      this.title, this.dialogType, this.list, this.listener);

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
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: BoxDecoration(
                    color: titleBgColor_(context),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20))),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, size: 20),
                        ))
                  ],
                ),
              ),
              Padding(
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
              Flexible(child: setDropdownList(dialogType, listener)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: PrimaryBorderButton(
                        buttonText: 'cancel'.tr,
                        fontColor: Colors.red,
                        borderColor: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: PrimaryBorderButton(
                          buttonText: 'select'.tr,
                          fontColor: defaultAccentColor_(context),
                          borderColor: defaultAccentColor_(context),
                          onPressed: () {
                            listener.onSelectMultiItem(
                                tempList, dialogType);
                            Navigator.pop(context);
                          },
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
            ]),
          ),
        );
      },
    );

/*
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) =>
            DraggableScrollableSheet(
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) =>
                      Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Container(
                    decoration: BoxDecoration(
                        color: titleBgColor_(context),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close, size: 20),
                            ))
                      ],
                    ),
                  ),
                  Padding(
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
                  Expanded(child: setDropdownList(dialogType, listener)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: PrimaryBorderButton(
                            buttonText: 'cancel'.tr,
                            fontColor: Colors.red,
                            borderColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: PrimaryBorderButton(
                              buttonText: 'select'.tr,
                              fontColor: defaultAccentColor_(context),
                              borderColor: defaultAccentColor_(context),
                              onPressed: () {
                                listener.onSelectMultiItem(
                                    tempList, dialogType);
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                ]),
              ),
            ));
*/
  }

  Widget setDropdownList(String dialogType, SelectMultiItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: tempList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () {
                setState(() {
                  if (tempList[i].check != null) {
                    tempList[i].check = !tempList[i].check!;
                  } else {
                    tempList[i].check = true;
                  }
                });
              },
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              minVerticalPadding: 0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 18, 0),
                child: Row(children: [
                  Checkbox(
                      activeColor: defaultAccentColor_(context),
                      value: tempList[i].check ?? false,
                      onChanged: (isCheck) {
                        setState(() {
                          tempList[i].check = isCheck;
                        });
                      }),
                  Text(
                    tempList[i].name ?? "",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400),
                  )
                ]),
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
