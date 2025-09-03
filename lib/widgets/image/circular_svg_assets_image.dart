import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/image/place_holder_error_image.dart';

class CircularSvgAssetsImage extends StatelessWidget {
  const CircularSvgAssetsImage(
      {super.key,
      required this.assetsPath,
      required this.width,
      required this.height,
      required this.radiusSize,
      required this.placeHolderSize,
      this.bolderWidth,
      this.borderColor,
      this.shape, this.fit});

  final double width, height, radiusSize, placeHolderSize;
  final double? bolderWidth;

  final String assetsPath;
  final Color? borderColor;
  final BoxShape? shape;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(assetsPath)
        ? Container(
            padding: EdgeInsets.all(bolderWidth ?? 0), // Border width
            decoration: BoxDecoration(
                color: borderColor, shape: shape ?? BoxShape.rectangle),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(radiusSize), // Image radius
                child: SvgPicture.asset(assetsPath ?? "",
                    height: height, width: width, fit: fit ?? BoxFit.contain),
              ),
            ),
          )
        : PlaceHolderErrorImage(size: placeHolderSize);
  }
}
