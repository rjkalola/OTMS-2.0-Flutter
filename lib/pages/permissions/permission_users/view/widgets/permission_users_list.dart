import 'package:belcka/routes/app_routes.dart' show AppRoutes;
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:belcka/pages/permissions/permission_users/model/permission_user_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';

class PermissionUsersList extends StatelessWidget {
  PermissionUsersList({super.key});

  final controller = Get.put(PermissionUsersController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                PermissionUserInfo info =
                    controller.permissionUsersList[position];
                int status = info.status ?? 0;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  AppUtils.onClickUserAvatar(info.userId ?? 0);
                                },
                                child: Container(
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
                                    url: info.userThumbImage ?? "",
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Text(
                                  info.userName ?? "",
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: primaryTextColor_(context),
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        /* CustomSwitch(
                            onValueChange: (value) {
                              print("value:" + value.toString());
                              // info.status = !info.status!;
                              info.status = (info.status ?? 0) == 0 ? 1 : 0;
                              controller.permissionUsersList.refresh();
                              controller.isDataUpdated.value = true;
                              controller.checkSelectAll();
                              // controller.changeCompanyPermissionStatusApi(
                              //     info.permissionId ?? 0, value);
                            },
                            mValue: status == 1 ? true : false)*/
                        CustomSwitch(
                            onValueChange: (value) {
                              print("value:" + value.toString());
                              // info.status = !info.status!;
                              // info.status = (info.status ?? 0) == 0 ? 1 : 0;
                              // int status = info.status ?? 0;
                              switch (status) {
                                case 0:
                                  info.status = 2;
                                  break;
                                case 1:
                                  info.status = 3;
                                  break;
                                case 2:
                                  info.status = 0;
                                  break;
                                case 3:
                                  info.status = 1;
                                  break;
                              }
                              controller.permissionUsersList.refresh();
                              controller.isDataUpdated.value = true;
                              controller.checkSelectAll();
                            },
                            mValue:
                                (status == 2 || status == 1) ? true : false),
                        SizedBox(
                          width: 12,
                        ),
                        CustomSwitch(
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
                              controller.permissionUsersList.refresh();
                              controller.isDataUpdated.value = true;
                              controller.checkSelectAll();
                            },
                            mValue: (status == 3 || status == 1) ? true : false)
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.permissionUsersList.length,
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
