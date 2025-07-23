import 'package:flutter/material.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/res/theme/theme_config.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/shapes/circle_widget.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class PhotosCountView extends StatelessWidget {
  const PhotosCountView(
      {super.key,
      required this.title,
      required this.count,
      required this.photosType,
      required this.onPressed});

  final String title;
  final int count;
  final String photosType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                count == 0
                    ? InkWell(
                        onTap: onPressed,
                        child: Container(
                          decoration: AppUtils.getGrayBorderDecoration(
                              borderWidth: 1,
                              borderColor: ThemeConfig.isDarkMode
                                  ? Colors.white
                                  : Colors.black26),
                          alignment: Alignment.center,
                          height: 60,
                          width: 60,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 46,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: onPressed,
                        child: ImageUtils.setSvgAssetsImage(
                            path: Drawable.pictureGalleryIcon,
                            width: 56,
                            height: 56),
                      ),
                count > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleWidget(
                                    color: Color(AppUtils.haxColor("#FF6464")),
                                    width: 26,
                                    height: 26),
                                PrimaryTextView(
                                  textAlign: TextAlign.start,
                                  text: count.toString(),
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  softWrap: true,
                                )
                              ],
                            )),
                      )
                    : Container()
              ],
            )),
        PrimaryTextView(
          textAlign: TextAlign.start,
          text: title,
          color: primaryTextColor_(context),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          softWrap: true,
        )
      ],
    );
  }
}
