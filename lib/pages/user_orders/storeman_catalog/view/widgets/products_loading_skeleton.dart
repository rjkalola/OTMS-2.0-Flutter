
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';

class ProductsLoadingSkeleton extends StatelessWidget {
  const ProductsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const _SkeletonProductCard(),
            SizedBox(height: 6,)
            // if (index < 4)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 8),
            //     child: _SkeletonBox(
            //       height: 8,
            //       width: double.infinity,
            //       borderRadius: 2,
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}

class _SkeletonProductCard extends StatelessWidget {
  const _SkeletonProductCard();

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SkeletonCircle(size: 90),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        height: 14,
                        width: double.infinity,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 8),
                      _SkeletonBox(
                        height: 14,
                        width: 220,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 8),
                      _SkeletonBox(
                        height: 14,
                        width: 180,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SkeletonBox(
              height: 1,
              width: double.infinity,
              borderRadius: 9,
            ),
            // const SizedBox(height: 8),
            // const _SkeletonBox(
            //   height: 18,
            //   width: double.infinity,
            //   borderRadius: 9,
            // ),
            // const SizedBox(height: 8),
            // const _SkeletonBox(
            //   height: 18,
            //   width: 260,
            //   borderRadius: 9,
            // ),
            const SizedBox(height: 12),
            Row(
              children: const [
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 20, borderRadius: 10),
                SizedBox(width: 6),
                _SkeletonBox(height: 20, width: 48, borderRadius: 10),
                Spacer(),
                _SkeletonBox(height: 24, width: 140, borderRadius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _SkeletonBox({
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedSkeletonBox(
      height: height,
      width: width,
      borderRadius: borderRadius,
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;

  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return _AnimatedSkeletonBox(
      height: size,
      width: size,
      borderRadius: 0,
    );
  }
}

class _AnimatedSkeletonBox extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const _AnimatedSkeletonBox({
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  State<_AnimatedSkeletonBox> createState() => _AnimatedSkeletonBoxState();
}

class _AnimatedSkeletonBoxState extends State<_AnimatedSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE1E5EA);
    final highlight = isDark ? const Color(0xFF565656) : const Color(0xFFF7F9FB);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = _controller.value;
        final start = (slide - 1).clamp(-1.0, 1.0);
        final end = (slide + 1).clamp(-1.0, 2.0);
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(start, 0),
              end: Alignment(end, 0),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}