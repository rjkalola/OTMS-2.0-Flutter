import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';

class PreferredImageSizeView extends StatelessWidget {
  const PreferredImageSizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Align(
          alignment: Alignment.center,
          child: Text('Preferred image size: 600px X 250px.',
              style: TextStyle(fontSize: 13, color: secondaryTextColor_(context)))),
    );
  }
}
