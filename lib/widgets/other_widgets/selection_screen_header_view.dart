import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/shapes/badge_count_widget.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class SelectionScreenHeaderView extends StatelessWidget {
  const SelectionScreenHeaderView(
      {super.key,
      this.title,
      this.statusText,
      this.statusColor,
      this.userCheckLogCount,
      required this.onBackPressed,
      this.onCheckLogCountClick});

  final String? title, statusText;
  final VoidCallback onBackPressed;
  final VoidCallback? onCheckLogCountClick;
  final Color? statusColor;
  final int? userCheckLogCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: GestureDetector(
          //     onTap: onBackPressed,
          //     child: Padding(
          //       padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
          //       child: Icon(
          //         Icons.arrow_back_ios_new_outlined,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
          TitleTextView(
            text: title,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          !StringHelper.isEmptyString(statusText)
              ? Align(
                  alignment: Alignment.centerRight,
                  child: TextViewWithContainer(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    margin: EdgeInsets.only(right: 15),
                    text: statusText ?? "",
                    borderRadius: 45,
                    fontSize: 14,
                    borderColor: statusColor,
                    fontWeight: FontWeight.w500,
                    fontColor: statusColor,
                    borderWidth: 1,
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onCheckLogCountClick,
              child: Visibility(
                visible: (userCheckLogCount ?? 0) != 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 0),
                  child: CustomBadgeIcon(
                    count: userCheckLogCount ?? 0,
                    color: defaultAccentColor_(context),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
