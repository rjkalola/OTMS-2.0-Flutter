import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/image/place_holder_error_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      {super.key,
      this.url,
      required this.width,
      required this.height,
      required this.placeHolderSize});

  final double width, height, placeHolderSize;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(url)
        ? url!.startsWith("http")
            ? CachedNetworkImage(
                height: height,
                width: width,
                imageUrl: url ?? "",
                placeholder: (context, url) =>
                    PlaceHolderErrorImage(size: placeHolderSize),
                errorWidget: (context, url, error) =>
                    PlaceHolderErrorImage(size: placeHolderSize),
              )
            : Image.file(
                File(url ?? ""),
                height: height,
                width: width,
              )
        : PlaceHolderErrorImage(size: placeHolderSize);
  }
}
