import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class LoginUsersList extends StatelessWidget {
  LoginUsersList({super.key});

  final controller = Get.put(IntroductionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.loginUsers.isNotEmpty,
          child: Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), //
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                controller.loginUsers.length,
                (position) => InkWell(
                  onTap: () {
                    controller.login(
                        controller.loginUsers[position].extension ?? "",
                        controller.loginUsers[position].phone ?? "",
                        true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 2, 12),
                    child: Row(children: [
                      ImageUtils.setUserImage(
                          url: controller.loginUsers[position].userThumbImage ?? "",
                          width: 50,
                          height: 50),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        child: PrimaryTextView(
                          text:
                              "${controller.loginUsers[position].firstName} ${controller.loginUsers[position].lastName}",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                      IconButton(
                          onPressed: () {
                            controller.loginUsers.removeAt(position);
                            Get.find<AppStorage>()
                                .setLoginUsers(controller.loginUsers);
                            controller.loginUsers.refresh();
                          },
                          icon: const Icon(Icons.close))
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void showPopupMenu() {
    PopupMenuButton<String>(
      onSelected: (index) {},
      itemBuilder: (BuildContext context) {
        return {'remove'.tr}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
