import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/select_user_listener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/search_text_field.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/textfield/search_text_field_dark.dart';

class SelectUserDialog extends StatefulWidget {
  final List<UserInfo> list;
  final String title, dialogIdentifier;
  final SelectUserListener listener;

  const SelectUserDialog(
      {super.key,
      required this.title,
      required this.dialogIdentifier,
      required this.list,
      required this.listener});

  @override
  State<SelectUserDialog> createState() =>
      _SelectUserDialogState(title, dialogIdentifier, list, listener);
}

class _SelectUserDialogState extends State<SelectUserDialog> {
  final RxList<UserInfo> tempList = <UserInfo>[].obs;
  final List<UserInfo> list;
  String title, dialogIdentifier;
  SelectUserListener listener;
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  _SelectUserDialogState(
      this.title, this.dialogIdentifier, this.list, this.listener);

  @override
  void initState() {
    // tempList.value = list;
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
              Container(
                decoration:  BoxDecoration(
                    color: backgroundColor_(context),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, size: 20),
                    ),
                    Center(
                      child: PrimaryTextView(
                          text: title,
                          softWrap: true,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: primaryTextColor_(context)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: SizedBox(
                  height: 44,
                  child: SearchTextFieldDark(
                    controller: searchController,
                    isClearVisible: isClearVisible,
                    hint: 'search'.tr,
                    label: 'search'.tr,
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
              Flexible(child: setDropDownList(listener))
            ]),
          ),
        );
      },
    );
  }

  Widget setDropDownList(SelectUserListener listener) => Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10),
          child: ListView.builder(
            itemCount: tempList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return Obx(
                () => Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: GestureDetector(
                    onTap: () {
                      listener.onSelectUser(dialogIdentifier, tempList[i]);
                      Get.back();
                    },
                    child: CardViewDashboardItem(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xff1E1E1E),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ImageUtils.setUserImage(
                                url: tempList[i].userThumbImage,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryTextView(
                                    softWrap: true,
                                    text: tempList[i].name ?? "",
                                    fontSize: 17,
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  void filterSearchResults(String query, List<UserInfo> list) {
    List<UserInfo> dummySearchList = <UserInfo>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      List<UserInfo> dummyListData = <UserInfo>[];
      for (var item in dummySearchList) {
        String name = item.name!;
        if (name.toLowerCase().contains(query.toLowerCase())) {
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
