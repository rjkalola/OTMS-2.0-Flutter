import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/users/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class UsersList extends StatelessWidget {
  UsersList({super.key});

  final controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                UserInfo info = controller.usersList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                  child: CardViewDashboardItem(
                    child: GestureDetector(
                      onTap: () {
                        // var arguments = {
                        //   AppConstants.intentKey.userId: info.id ?? 0,
                        //   AppConstants.intentKey.userName: info.name ?? "",
                        //   AppConstants.intentKey.userList: controller.usersList,
                        // };
                        // Get.toNamed(AppRoutes.userPermissionScreen,
                        //     arguments: arguments);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            UserAvtarView(
                              imageUrl: info.userThumbImage ?? "",
                              imageSize: 52,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryTextView(
                                    text: info.name ?? "",
                                    fontSize: 17,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  PrimaryTextView(
                                    text: info.tradeName ?? "",
                                    fontSize: 14,
                                    color: secondaryLightTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.usersList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
