import 'package:belcka/pages/user_orders/storeman_catalog/model/order_user_data.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderUsersBottomSheet extends StatelessWidget {
  final List<OrderUserData> users;

  const BuyerOrderUsersBottomSheet({
    super.key,
    required this.users,
  });

  static void show(List<OrderUserData>? users) {
    if (StringHelper.isEmptyList(users)) return;
    Get.bottomSheet(
      BuyerOrderUsersBottomSheet(users: users!),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: backgroundColor_(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: TitleTextView(
                text: 'order_users'.tr,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: users.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: dividerColor_(context),
                ),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        UserAvtarView(
                          imageUrl: user.thumbUrl ?? user.imageUrl ?? "",
                          imageSize: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryTextView(
                            text: user.userName ?? "",
                            fontSize: 15,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PrimaryBorderButton(
                buttonText: 'close'.tr,
                fontWeight: FontWeight.w400,
                fontColor: secondaryLightTextColor_(context),
                borderColor: secondaryExtraLightTextColor_(context),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
