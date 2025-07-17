import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../res/colors.dart';
import '../../common/listener/select_item_listener.dart';

class StoreListDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String title;
  final String dialogType;
  final SelectItemListener listener;

  const StoreListDialog(
      {super.key,
      required this.title,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<StoreListDialog> createState() =>
      StoreListDialogState(title, dialogType, list, listener);
}

class StoreListDialogState extends State<StoreListDialog> {
  List<ModuleInfo> list;
  String title;
  String dialogType;
  SelectItemListener listener;
  List<ModuleInfo> tempList = [];

  StoreListDialogState(
      this.title, this.dialogType, this.list, this.listener);

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
                    decoration:  BoxDecoration(
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
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: TextField(
                      onChanged: (value) {
                        setModalState(() {
                          filterSearchResults(value, list);
                        });
                      },
                      decoration:  InputDecoration(
                        contentPadding:const  EdgeInsets.fromLTRB(0, 2, 14, 0),
                        prefixIcon:const  Icon(Icons.search, color: Colors.black26),
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
                listener.onSelectItem(
                    i, tempList[i].id??0, tempList[i].name??"", dialogType);
                Navigator.pop(context);
              },
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              minVerticalPadding: 0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Text(
                  tempList[i].name??"",
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
