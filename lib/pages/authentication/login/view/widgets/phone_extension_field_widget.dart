import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/login/controller/login_controller.dart';
import 'package:belcka/widgets/textfield/text_field_phone_extension_widget.dart';

class PhoneExtensionFieldWidget extends StatelessWidget {
  PhoneExtensionFieldWidget({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    //   return InkWell(
    //     child: Row(children: [
    //       Container(
    //         margin:
    //         const EdgeInsets.fromLTRB(16, 0, 0, 0),
    //         child: Image.network(
    //           loginController.mFlag.value,
    //           width: 32,
    //           height: 32,
    //         ),
    //       ),
    //       const Icon(
    //         Icons.arrow_drop_down,
    //         size: 24,
    //         color: Color(0xff000000),
    //       ),
    //       Padding(
    //         padding:
    //         const EdgeInsets.fromLTRB(2, 0, 0, 0),
    //         child:
    //         Text(loginController.mExtension.value,
    //             textAlign: TextAlign.start,
    //             style: const TextStyle(
    //               color: Colors.black,
    //               fontSize: 16,
    //             )),
    //       ),
    //     ]),
    //     onTap: () {
    //       loginController.showPhoneExtensionDialog();
    //     },
    //   );
    // });
    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 5, 18),
          child: TextFieldPhoneExtensionWidget(
              mExtension: loginController.mExtension.value,
              mFlag: loginController.mFlag.value,
              onPressed: () {
                loginController.showPhoneExtensionDialog();
              }),
        ));
  }
}
