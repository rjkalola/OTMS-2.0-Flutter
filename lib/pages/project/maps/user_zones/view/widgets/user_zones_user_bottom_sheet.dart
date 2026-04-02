import 'package:belcka/pages/profile/billing_details_new/view/widgets/phone_with_extension_field.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_screen.dart';
import 'package:belcka/pages/project/maps/user_zones/model/user_location_models.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/PrimaryBorderButton.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserZonesUserBottomSheet extends StatelessWidget {
  const UserZonesUserBottomSheet({super.key, required this.user});

  final UserLocationInfo user;

  String get _displayName => (user.userName ?? '').trim();

  String get _phoneDisplay {
    final ext = (user.extension ?? '').trim();
    final ph = (user.phone ?? '').trim();
    if (ext.isEmpty && ph.isEmpty) return '';
    if (ext.isEmpty) return ph;
    if (ph.isEmpty) return ext;
    return '$ext $ph';
  }

  String get _workTime => (user.lastSeen ?? '').trim();

  String get _phoneDial {
    final ext = (user.extension ?? '').trim();
    final ph = (user.phone ?? '').trim();
    return '$ext$ph';
  }

  bool get _hasPhone =>
      !StringHelper.isEmptyString(user.phone) ||
      !StringHelper.isEmptyString(user.extension);

  @override
  Widget build(BuildContext context) {
    final uid = user.id ?? 0;
    final imageUrl = user.userImage ?? user.userThumbImage ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: dividerColor_(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (StringHelper.isEmptyString(imageUrl)) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewScreen(
                          imageUrl: user.userImage ?? user.userThumbImage ?? '',
                          isLoginUser: UserUtils.isLoginUser(uid),
                        ),
                      ),
                    );
                  },
                  child: UserAvtarView(
                    imageUrl: user.userThumbImage ?? '',
                    imageSize: 72,
                    isOnlineStatusVisible: true,
                    onlineStatusColor: (user.isWorking ?? false)
                        ? Colors.green
                        : Colors.redAccent,
                    onlineStatusSize: 12,
                    onlineStatusPadding: 5,
                  ),
                ),
                const SizedBox(height: 12),
                if (_displayName.isNotEmpty)
                  Text(
                    _displayName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor_(context),
                    ),
                  ),
                if ((user.tradeName ?? '').trim().isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryTextView(
                      text: user.tradeName ?? '',
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: secondaryLightTextColor_(context),
                      fontSize: 14,
                    ),
                  ),
                ],
                if (_workTime.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryTextView(
                      text: _workTime,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      color: secondaryLightTextColor_(context),
                      fontSize: 11,
                    ),
                  ),
                ],
                if ((user.location ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryTextView(
                      text: user.location ?? '',
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: secondaryExtraLightTextColor_(context),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (_hasPhone) ...[
                  GestureDetector(
                    onTap: () {
                      final dial = _phoneDial;
                      if (dial.isEmpty) return;
                      AppUtils.onClickPhoneNumber(dial);
                    },
                    child: PhoneWithExtensionField(
                      _phoneDisplay,
                      'phone_number'.tr,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (!StringHelper.isEmptyString(user.email)) ...[
                  GestureDetector(
                    onTap: () => AppUtils.copyEmail(user.email ?? ''),
                    child: PhoneWithExtensionField(
                      user.email ?? '',
                      'email'.tr,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryBorderButton(
                    height: 44,
                    borderColor: secondaryExtraLightTextColor_(context),
                    fontColor: secondaryTextColor_(context),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    buttonText: 'close'.tr,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    height: 44,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    buttonText: 'view_profile'.tr,
                    onPressed: () {
                      Get.back();
                      if (uid > 0) {
                        AppUtils.onClickUserAvatar(uid);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
