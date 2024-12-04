import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/PrimaryBorderButton.dart';

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
              decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: dividerColor,
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
                  listener.onSelectItem(i, 0, list[i].name??"", list[i].action??"");
                  Get.back();
                },
                child: SizedBox(
                  child: Text(
                    list[i].name ?? "",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            );
          },
        ),
      );
}
