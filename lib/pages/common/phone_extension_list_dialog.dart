import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/dialog_title_view.dart';
import 'package:otm_inventory/utils/data_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/search_text_field.dart';
import '../../res/colors.dart';
import 'listener/SelectPhoneExtensionListener.dart';

class PhoneExtensionListDialog extends StatefulWidget {
  final List<ModuleInfo> list;
  final String title;
  final SelectPhoneExtensionListener listener;

  const PhoneExtensionListDialog(
      {super.key,
      required this.title,
      required this.list,
      required this.listener});

  @override
  State<PhoneExtensionListDialog> createState() =>
      _PhoneExtensionListDialogState(title, list, listener);
}

class _PhoneExtensionListDialogState extends State<PhoneExtensionListDialog> {
  List<ModuleInfo> list;
  String title;
  SelectPhoneExtensionListener listener;
  List<ModuleInfo> tempList = [];
  final isClearVisible = false.obs;
  final searchController = TextEditingController().obs;

  _PhoneExtensionListDialogState(this.title, this.list, this.listener);

  @override
  void initState() {
    tempList.clear();
    tempList.addAll(DataUtils.getPhoneExtensionList());
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
              DialogTitleView(
                title: title,
              ),
              Padding(
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
              Flexible(child: setDropDownList(listener))
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
    //                     Align(
    //                         alignment: Alignment.centerRight,
    //                         child: IconButton(
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                           },
    //                           icon: const Icon(Icons.close, size: 20),
    //                         ))
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    //                 child: TextField(
    //                   onChanged: (value) {
    //                     setModalState(() {
    //                       filterSearchResults(value, list);
    //                     });
    //                   },
    //                   decoration: InputDecoration(
    //                     contentPadding: const EdgeInsets.fromLTRB(0, 2, 14, 0),
    //                     prefixIcon:
    //                         const Icon(Icons.search, color: Colors.black26),
    //                     border: const OutlineInputBorder(
    //                       borderSide:
    //                           BorderSide(color: Color(0xffbab8b8), width: 1.3),
    //                     ),
    //                     focusedBorder: const OutlineInputBorder(
    //                       borderSide:
    //                           BorderSide(color: Color(0xffbab8b8), width: 1.3),
    //                     ),
    //                     hintText: 'search'.tr,
    //                   ),
    //                 ),
    //               ),
    //               Expanded(child: setDropDownList(listener))
    //             ]),
    //           ),
    //         ));
  }

  Widget setDropDownList(SelectPhoneExtensionListener listener) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 10),
        child: ListView.builder(
          itemCount: tempList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () {
                listener.onSelectPhoneExtension(
                    tempList[i].id!,
                    tempList[i].phoneExtension!,
                    tempList[i].flagImage!,
                    tempList[i].name!);
                Navigator.pop(context);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.network(
                          //   tempList[i].flagImage!,
                          //   width: 36,
                          //   height: 36,
                          // ),
                          ImageUtils.setSvgAssetsImage(
                              path: tempList[i].flagImage!,
                              width: 24,
                              height: 24),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              "${tempList[i].name!} (${tempList[i].phoneExtension!})",
                              textAlign: TextAlign.start,
                              style:  TextStyle(
                                  fontSize: 16,
                                  color: primaryTextColor_(context),
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ]),
                  ),
                  // Divider()
                ],
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
        String extension = item.phoneExtension!;
        String country = item.name!;
        if (extension.toLowerCase().contains(query.toLowerCase()) ||
            country.toLowerCase().contains(query.toLowerCase())) {
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
