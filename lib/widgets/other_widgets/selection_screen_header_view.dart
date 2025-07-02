import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/text/TextViewWithContainer.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class SelectionScreenHeaderView extends StatelessWidget {
  const SelectionScreenHeaderView(
      {super.key,
      this.title,
      this.statusText,
      this.statusColor,
      required this.onBackPressed});

  final String? title, statusText;
  final VoidCallback onBackPressed;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: onBackPressed,
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                )),
          ),
          TitleTextView(
            text: title,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          !StringHelper.isEmptyString(statusText)
              ? Align(
                  alignment: Alignment.centerRight,
                  child: TextViewWithContainer(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
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
        ],
      ),
    );
  }
}
