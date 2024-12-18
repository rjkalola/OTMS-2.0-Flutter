import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res/colors.dart';

class MoreTabButton extends StatelessWidget {
  final double iconPadding;
  final String iconPath, mText;
  final VoidCallback onPressed;

  const MoreTabButton(
      {super.key,
      required this.iconPadding,
      required this.iconPath,
      required this.mText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 19, 14, 19),
        child: Row(children: [
          Container(
              padding: EdgeInsets.all(iconPadding),
              width: 21,
              height: 21,
              child: SvgPicture.asset(
                iconPath,
                // color: primaryTextColor,
                colorFilter:
                    const ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Text(mText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )),
          )),
          const Icon(
            Icons.keyboard_arrow_right,
            size: 24,
            color: hintColor,
          ),
        ]),
      ),
    );
  }
}
