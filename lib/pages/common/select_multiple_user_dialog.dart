import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/listener/select_user_listener.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/search_text_field.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class SelectMultipleUserDialog extends StatefulWidget {
  final List<UserInfo> list;
  final String title, dialogIdentifier;
  final SelectUserListener listener;

  const SelectMultipleUserDialog(
      {super.key,
      required this.title,
      required this.dialogIdentifier,
      required this.list,
      required this.listener});

  @override
  State<SelectMultipleUserDialog> createState() =>
      _SelectMultipleUserDialogState(title, dialogIdentifier, list, listener);
}

class _SelectMultipleUserDialogState extends State<SelectMultipleUserDialog> {
  final RxList<UserInfo> tempList = <UserInfo>[].obs;
  final List<UserInfo> list;
  String title, dialogIdentifier;
  SelectUserListener listener;
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  _SelectMultipleUserDialogState(
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
                color: backgroundColor_(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration:  BoxDecoration(
                    color: titleBgColor_(context),
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
                    Expanded(
                      child: PrimaryTextView(
                          text: title,
                          softWrap: true,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: primaryTextColor_(context)),
                    ),
                    GestureDetector(
                      onTap: () {
                        filterSearchResults("", list);
                        listener.onSelectMultipleUser(
                            dialogIdentifier, tempList);
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: PrimaryTextView(
                            text: 'select'.tr,
                            softWrap: true,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: defaultAccentColor_(context)),
                      ),
                    )
                  ],
                ),
              ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: SizedBox(
                  height: 44,
                  child: SearchTextField(
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
                  child: InkWell(
                    onTap: () {
                      tempList[i].isCheck = !(tempList[i].isCheck ?? false);
                      tempList.refresh();
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
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
                              url: tempList[i].userThumbImage??"",
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
                                TitleTextView(
                                  text: tempList[i].name ?? "",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          CustomCheckbox(
                              onValueChange: (value) {
                                print("value:" + value.toString());
                                tempList[i].isCheck =
                                    !(tempList[i].isCheck ?? false);
                                tempList.refresh();
                              },
                              mValue: tempList[i].isCheck ?? false)
                        ],
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
