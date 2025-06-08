import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';

class UserAvtarView extends StatelessWidget {
  const UserAvtarView(
      {super.key,
      required this.imageUrl,
      this.isOnlineStatusVisible,
      this.onlineStatusColor,
      this.imageBorderColor,
      this.onlineStatusSize,
      this.onlineStatusPadding,
      this.imageBorderWidth,
      this.imageSize});

  final String imageUrl;
  final bool? isOnlineStatusVisible;
  final Color? onlineStatusColor, imageBorderColor;
  final double? onlineStatusSize,
      onlineStatusPadding,
      imageBorderWidth,
      imageSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(45),
            ),
            border: Border.all(
              width: imageBorderWidth ?? 2,
              color: imageBorderColor ?? Color(0xff1E1E1E),
              style: BorderStyle.solid,
            ),
          ),
          child: ImageUtils.setUserImage(
            url: imageUrl,
            width: imageSize ?? 44,
            height: imageSize ?? 44,
          ),
        ),
        Visibility(
          visible: isOnlineStatusVisible ?? false,
          child: Padding(
            padding: EdgeInsets.all(onlineStatusPadding ?? 2.0),
            child: CircleWidget(
                color: onlineStatusColor ?? Colors.green,
                width: onlineStatusSize ?? 12,
                height: onlineStatusSize ?? 12),
          ),
        )
      ],
    );
  }
}
