import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/data_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';

class CartIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const CartIconWidget({
    super.key,
    this.size = 24, // default size
    this.color, // default color
  });

  @override
  Widget build(BuildContext context) {
    // return Icon(
    //   Icons.shopping_cart_outlined,
    //   size: size,
    //   color: color,
    // );

    return SizedBox(
      width: size,
      height: size,
      child: ImageUtils.setSvgAssetsImage(
          path: Drawable.tab2Icon, width: size, height: size, color: color),
    );
  }
}
