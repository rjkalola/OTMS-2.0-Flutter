import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/users/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';

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
                  padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
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
                                  url: info.userThumbImage,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                info.name ?? "",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
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
              separatorBuilder: (context, position) => const Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor,
                      thickness: 2,
                    ),
                  )),
        ));
  }
}
