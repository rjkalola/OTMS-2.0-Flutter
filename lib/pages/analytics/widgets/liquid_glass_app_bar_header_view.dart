import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassAppBarHeaderView extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? child;
  final double blur;
  final double height;

  const LiquidGlassAppBarHeaderView({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.child,
    this.blur = 20,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.65),
                Colors.white.withOpacity(0.35),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _topBar(context),
                if (child != null) ...[
                  const SizedBox(height: 12),
                  Expanded(child: child!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: onBack,
            )
          else
            const SizedBox(width: 44),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(
            width: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ?? [],
            ),
          ),
        ],
      ),
    );
  }
}