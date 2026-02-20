import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlassSliverHeader extends StatelessWidget {
  final double expandedHeight;
  final Widget child;

  const GlassSliverHeader({
    super.key,
    required this.expandedHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _GlassHeaderDelegate(
        expandedHeight: expandedHeight,
        child: child,
      ),
    );
  }
}

class _GlassHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget child;

  _GlassHeaderDelegate({
    required this.expandedHeight,
    required this.child,
  });

  @override
  double get minExtent => 90;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    final double progress =
    (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15 + (progress * 10),
          sigmaY: 15 + (progress * 10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55 + (progress * 0.15)),
          ),
          child: SafeArea(
            bottom: false,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _GlassHeaderDelegate oldDelegate) => true;


}
