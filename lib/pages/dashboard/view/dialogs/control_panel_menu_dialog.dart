import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/shapes/dialog_handle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class ControlPanelMenuDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String dialogType;
  final SelectItemListener listener;

  const ControlPanelMenuDialog(
      {super.key,
      required this.dialogType,
      required this.list,
      required this.listener});

  @override
  State<ControlPanelMenuDialog> createState() =>
      ControlPanelMenuDialogState(dialogType, list, listener);
}

class ControlPanelMenuDialogState extends State<ControlPanelMenuDialog> {
  List<ModuleInfo> list;
  String dialogType;
  SelectItemListener listener;
  List<ModuleInfo> tempList = [];
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  ControlPanelMenuDialogState(this.dialogType, this.list, this.listener);

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
            decoration:  BoxDecoration(
                color: dashBoardBgColor_(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 12,
              ),
              DialogHandleWidget(),
              SizedBox(
                height: 10,
              ),
              Flexible(child: setDropdownList(dialogType, listener)),
              SizedBox(
                height: 16,
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget setDropdownList(String dialogType, SelectItemListener listener) =>
      ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () {
              // Get.back();
              listener.onSelectItem(
                  position,
                  tempList[position].id ?? 0,
                  tempList[position].name ?? "",
                  tempList[position].action ?? "");
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 9, 18, 9),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9),
                      width: 44,
                      height: 44,
                      decoration: AppUtils.getGrayBorderDecoration(
                          color: backgroundColor_(context),
                          borderColor: dividerColor_(context),
                          borderWidth: 1),
                      child: ImageUtils.setSvgAssetsImage(
                        color: primaryTextColor_(context),
                          path: tempList[position].icon ??
                              Drawable.truckPermissionIcon,
                          width: 24,
                          height: 24),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      tempList[position].name ?? "",
                      textAlign: TextAlign.start,
                      style:  TextStyle(
                          fontSize: 17,
                          color: primaryTextColor_(context),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: tempList.length,
        separatorBuilder: (context, position) =>  Padding(
          padding: EdgeInsets.only(left: 70),
          child: Divider(
            height: 0,
            color: dividerColor_(context),
            thickness: ThemeConfig.isDarkMode?1:2,
          ),
        ),
      );
}
