import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/menu_item_listener.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

import '../../res/colors.dart';
import 'listener/select_item_listener.dart';

class MenuItemsListBottomDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final MenuItemListener listener;

  const MenuItemsListBottomDialog(
      {super.key,
      required this.list,
      required this.listener,});

  @override
  State<MenuItemsListBottomDialog> createState() =>
      MenuItemsListBottomDialogState(list, listener);
}

class MenuItemsListBottomDialogState extends State<MenuItemsListBottomDialog> {
  List<ModuleInfo> list;
  MenuItemListener listener;
  List<ModuleInfo> tempList = [];

  MenuItemsListBottomDialogState(this.list, this.listener);

  @override
  void initState() {
    tempList.clear();
    tempList.addAll(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CupertinoActionSheet(
          actions: list.map((item) {
            return CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                listener.onSelectMenuItem(item);
                print('Selected: ${item.name}');
              },
              // isDestructiveAction: item.isDestructive,
              child: Text(
                item.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    // color: item.isDestructive
                    //     ? CupertinoColors.systemRed
                    //     : CupertinoColors.activeBlue,
                    color: item.textColor != null
                        ? Color(AppUtils.haxColor(item.textColor ?? ""))
                        : defaultAccentColor),
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.black54,
              ),
            ),
          )),
    );
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: tempList.length,
          // scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            /* return ListTile(
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
            );*/
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: PrimaryTextView(
                    text: tempList[i].name ?? "",
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: i != tempList.length - 1,
                  child: Divider(
                    thickness: 1.2,
                    color: dividerColor,
                  ),
                ),
              ],
            );
          },
        ),
      );
}
