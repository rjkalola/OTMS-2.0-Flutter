import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';

class SelectionScreenHeaderView extends StatelessWidget {
  const SelectionScreenHeaderView(
      {super.key, this.title, required this.onBackPressed});

  final String? title;
  final VoidCallback onBackPressed;

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
          )
        ],
      ),
    );
  }
}
