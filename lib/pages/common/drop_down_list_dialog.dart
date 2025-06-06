import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';

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
            decoration: const BoxDecoration(
                color: Colors.white,
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
              // Visibility(
              //   visible: isSearchEnable,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              //     child: TextField(
              //       onChanged: (value) {
              //         setState(() {
              //           filterSearchResults(value, list);
              //         });
              //       },
              //       decoration: InputDecoration(
              //         contentPadding: const EdgeInsets.fromLTRB(0, 2, 14, 0),
              //         prefixIcon:
              //             const Icon(Icons.search, color: Colors.black26),
              //         border: const OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Color(0xffbab8b8), width: 1.3),
              //         ),
              //         focusedBorder: const OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Color(0xffbab8b8), width: 1.3),
              //         ),
              //         hintText: 'search'.tr,
              //       ),
              //     ),
              //   ),
              // ),
              Flexible(child: setDropdownList(dialogType, listener))
            ]),
          ),
        );
      },
    );
    // return StatefulBuilder(
    //     builder: (BuildContext context, StateSetter setModalState) =>
    //         DraggableScrollableSheet(
    //           initialChildSize: 0.9,
    //           maxChildSize: 0.9,
    //           minChildSize: 0.5,
    //           builder:
    //               (BuildContext context, ScrollController scrollController) =>
    //                   Container(
    //             decoration: const BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius:
    //                     BorderRadius.vertical(top: Radius.circular(20))),
    //             child: Column(mainAxisSize: MainAxisSize.max, children: [
    //               Container(
    //                 decoration: const BoxDecoration(
    //                     color: titleBgColor,
    //                     borderRadius:
    //                         BorderRadius.vertical(top: Radius.circular(20))),
    //                 child: Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     Align(
    //                       alignment: Alignment.center,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(18.0),
    //                         child: Text(
    //                           title,
    //                           style: const TextStyle(
    //                               fontWeight: FontWeight.w600, fontSize: 17),
    //                         ),
    //                       ),
    //                     ),
    //                     Visibility(
    //                       visible: isCloseEnable,
    //                       child: Align(
    //                           alignment: Alignment.centerRight,
    //                           child: IconButton(
    //                             onPressed: () {
    //                               Get.back();
    //                             },
    //                             icon: const Icon(Icons.close, size: 20),
    //                           )),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Visibility(
    //                 visible: isSearchEnable,
    //                 child: Padding(
    //                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    //                   child: TextField(
    //                     onChanged: (value) {
    //                       setModalState(() {
    //                         filterSearchResults(value, list);
    //                       });
    //                     },
    //                     decoration: InputDecoration(
    //                       contentPadding:
    //                           const EdgeInsets.fromLTRB(0, 2, 14, 0),
    //                       prefixIcon:
    //                           const Icon(Icons.search, color: Colors.black26),
    //                       border: const OutlineInputBorder(
    //                         borderSide: BorderSide(
    //                             color: Color(0xffbab8b8), width: 1.3),
    //                       ),
    //                       focusedBorder: const OutlineInputBorder(
    //                         borderSide: BorderSide(
    //                             color: Color(0xffbab8b8), width: 1.3),
    //                       ),
    //                       hintText: 'search'.tr,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(child: setDropdownList(dialogType, listener))
    //             ]),
    //           ),
    //         ));
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
                  style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff333333),
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
