import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:otm_inventory/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class MenuButtonsGridWidget extends StatelessWidget {
  MenuButtonsGridWidget({super.key});

  final controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.menuItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 90,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Get.toNamed(AppRoutes.billingDetailsNewScreen);
              }
              else if (index == 3) {
                Get.toNamed(AppRoutes.myRequestsScreen);
              }
            },
            splashColor: Colors.transparent,     // Removes splash effect
            highlightColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(14, 12, 10, 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                      width: 1,
                      color: Colors.grey.shade200)
              ),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(controller.menuItems[index]['icon'], color: Colors.blue,size: 28,weight: 100,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible:true,
                          child: PrimaryTextView(
                            text: controller.menuItems[index]['title'],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            color: primaryTextColorLight,
                            softWrap: true,
                            maxLine: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}