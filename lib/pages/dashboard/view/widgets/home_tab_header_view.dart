import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/user_image.dart';

import '../../../../res/colors.dart';

class HomeTabHeaderView extends StatelessWidget {
  final String userName, userImage;
  const HomeTabHeaderView({super.key, required this.userName, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
      child: Row(
        children: [
          UserImage(url: userImage, size: 48),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text("Welcome, $userName",
                style: const TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                )),
          )
        ],
      ),
    );
  }
}
