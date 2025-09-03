import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/permissions/search_user/controller/search_user_controller.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';

import '../../../../../../utils/app_constants.dart';

class UsersList extends StatelessWidget {
  UsersList({super.key});

  final controller = Get.put(SearchUserController());

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
                  child: GestureDetector(
                    onTap: () {
                      var arguments = {
                        AppConstants.intentKey.userInfo: info,
                      };
                      Get.back(result: arguments);
                    },
                    child: Container(
                      color: Colors.transparent,
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
                            style: TextStyle(
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
              itemCount: controller.usersList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) =>  Padding(
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
