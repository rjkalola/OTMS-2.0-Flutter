import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/model/resources_shift_info.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

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
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DialogTitleView(
              title: 'select_shift'.tr,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 6),
              child: SizedBox(
                  width: double.infinity,
                  child: PrimaryTextView(
                    text: 'all_shifts'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: secondaryExtraLightTextColor,
                  )),
            ),
            Flexible(child: setDropdownList(dialogType, listener))
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      listener.onSelectItem(i, tempList[i].id ?? 0,
                          tempList[i].name ?? "", dialogType);
                    },
                    child: Row(
                      children: [
                        ImageUtils.setSvgAssetsImage(
                            path: Drawable.homeDrawerIcon,
                            width: 24,
                            height: 24,
                            color: primaryTextColor),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          tempList[i].name ?? "Shift 1",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 17,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: dividerColor,
                )
              ],
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
