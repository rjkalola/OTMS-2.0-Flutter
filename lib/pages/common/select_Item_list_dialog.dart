import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/web_services/response/module_info.dart';

import '../../res/colors.dart';
import 'listener/select_item_listener.dart';

class SelectItemListDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String title;
  final String dialogType;
  final SelectItemListener listener;

  const SelectItemListDialog(
      {super.key,
      required this.title,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<SelectItemListDialog> createState() =>
      SelectItemListDialogState(title, dialogType, list, listener);
}

class SelectItemListDialogState extends State<SelectItemListDialog> {
  List<ModuleInfo> list;
  String title;
  String dialogType;
  SelectItemListener listener;

  SelectItemListDialogState(
      this.title, this.dialogType, this.list, this.listener);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) => Container(
              decoration: BoxDecoration(
                  color: backgroundColor_(context),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: titleBgColor_(context),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor_(context),
                ),
                setDropdownList(dialogType, listener),
              ]),
            ));
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: InkWell(
                onTap: () {
                  listener.onSelectItem(
                      i, 0, list[i].name ?? "", list[i].action ?? "");
                  Get.back();
                },
                child: SizedBox(
                  child: Text(
                    list[i].name ?? "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17,
                        color: primaryTextColor_(context),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            );
          },
        ),
      );
}
