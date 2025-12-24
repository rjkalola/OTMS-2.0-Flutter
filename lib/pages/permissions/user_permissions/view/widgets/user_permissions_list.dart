import 'package:belcka/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:belcka/pages/permissions/user_permissions/controller/user_permission_controller.dart';
import 'package:belcka/pages/permissions/user_permissions/view/widgets/empty_switch_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/other_widgets/widget_icon_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/widget_title_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPermissionsList extends StatelessWidget {
  UserPermissionsList({super.key});

  final controller = Get.put(UserPermissionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                PermissionInfo info = controller.userPermissionList[position];
                int status = info.status ?? 0;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 9, 16, 9),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              WidgetIconView(
                                iconPath: info.icon,
                                iconColor: info.color,
                                isAdminWidget: info.isAdmin,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              WidgetTitleTextView(
                                text: info.name ?? "",
                                fontSize: 18,
                              )
                            ],
                          ),
                        ),
                        // (info.isWeb ?? false)
                        //     ? CustomSwitch(
                        //         onValueChange: (value) {
                        //           print("value:" + value.toString());
                        //           // info.status = !info.status!;
                        //           // info.status = (info.status ?? 0) == 0 ? 1 : 0;
                        //           // int status = info.status ?? 0;
                        //           switch (status) {
                        //             case 0:
                        //               info.status = 2;
                        //               break;
                        //             case 1:
                        //               info.status = 3;
                        //               break;
                        //             case 2:
                        //               info.status = 0;
                        //               break;
                        //             case 3:
                        //               info.status = 1;
                        //               break;
                        //           }
                        //           controller.userPermissionList.refresh();
                        //           controller.isDataUpdated.value = true;
                        //           controller.checkSelectAll();
                        //         },
                        //         mValue:
                        //             (status == 2 || status == 1) ? true : false)
                        //     : EmptySwitchView(),
                        // SizedBox(
                        //   width: 12,
                        // ),
                        (info.isApp ?? false)
                            ? CustomSwitch(
                                onValueChange: (value) {
                                  print("value:" + value.toString());
                                  // info.status = !info.status!;
                                  // info.status = (info.status ?? 0) == 0 ? 1 : 0;
                                  // int status = info.status ?? 0;
                                  switch (status) {
                                    case 0:
                                      info.status = 3;
                                      break;
                                    case 1:
                                      info.status = 2;
                                      break;
                                    case 2:
                                      info.status = 1;
                                      break;
                                    case 3:
                                      info.status = 0;
                                      break;
                                  }
                                  controller.userPermissionList.refresh();
                                  controller.isDataUpdated.value = true;
                                  controller.checkSelectAll();
                                },
                                mValue:
                                    (status == 3 || status == 1) ? true : false)
                            : EmptySwitchView()
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.userPermissionList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor_(context),
                      thickness: 2,
                    ),
                  )),
        ));
  }
}
