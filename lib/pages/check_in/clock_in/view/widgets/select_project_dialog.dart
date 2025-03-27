import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SelectProjectDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String dialogType;
  final SelectItemListener listener;

  const SelectProjectDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<SelectProjectDialog> createState() =>
      SelectProjectDialogState(dialogType, list, listener);
}

class SelectProjectDialogState extends State<SelectProjectDialog> {
  List<ModuleInfo> list;
  String dialogType;
  SelectItemListener listener;
  List<ModuleInfo> tempList = [];

  SelectProjectDialogState(this.dialogType, this.list, this.listener);

  @override
  void initState() {
    tempList.clear();
    tempList.addAll(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) =>
            DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) =>
                      Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: titleBgColor,
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
                              'select_project'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: TextField(
                      onChanged: (value) {
                        setModalState(() {
                          filterSearchResults(value, list);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 2, 14, 0),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black26),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffbab8b8), width: 1.3),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffbab8b8), width: 1.3),
                        ),
                        hintText: 'search'.tr,
                      ),
                    ),
                  ),
                  Expanded(child: setDropdownList(dialogType, listener))
                ]),
              ),
            ));
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: tempList.length,
          scrollDirection: Axis.vertical,
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
                child: Row(
                  children: [
                    Container(
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      tempList[i].name ?? "Project 1",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 17,
                          color: primaryTextColor,
                          fontWeight: FontWeight.w400),
                    )
                  ],
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
