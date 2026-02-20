import 'dart:ui';
import 'package:flutter/material.dart';

class GlassHeader extends StatelessWidget {
  final Widget child;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  const GlassHeader({
    super.key,
    required this.child,
    this.height = 120,
    this.borderRadius = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55), // glass color
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}