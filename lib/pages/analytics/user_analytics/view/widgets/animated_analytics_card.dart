import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedAnalyticsCard extends StatefulWidget {
  final String title;
  final List<double> values;
  final List<Color> gradientColors;

  const AnimatedAnalyticsCard({
    super.key,
    required this.title,
    required this.values,
    required this.gradientColors,
  });

  @override
  State<AnimatedAnalyticsCard> createState() => _AnimatedAnalyticsCardState();
}

class _AnimatedAnalyticsCardState extends State<AnimatedAnalyticsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int selectedIndex = 4; // default MAY

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6)
            ],
          ),
          child: Center(
            child: Text(widget.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),

        // Chart Card
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 14)
            ],
          ),
          child: Stack(
            children: [
              // Highlight column
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) => CustomPaint(
                    painter: HighlightPainter(selectedIndex, widget.values.length),
                  ),
                ),
              ),

              // Line graph
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 48),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => CustomPaint(
                      painter: AnimatedLinePainter(
                        widget.values,
                        selectedIndex,
                        _controller.value,
                      ),
                    ),
                  ),
                ),
              ),

              // Months (tap enabled)
              Positioned(
                top: 14,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                          _controller.forward(from: 0);
                        });
                      },
                      child: Text(
                        months[i],
                        style: TextStyle(
                          color: i == selectedIndex
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedLinePainter extends CustomPainter {
  final List<double> values;
  final int highlightIndex;
  final double progress;

  AnimatedLinePainter(this.values, this.highlightIndex, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = values.reduce(max);
    final stepX = size.width / (values.length - 1);

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] / maxVal * size.height);
      points.add(Offset(x, y));
    }

    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final cur = points[i];
        path.cubicTo(
          (prev.dx + cur.dx) / 2,
          prev.dy,
          (prev.dx + cur.dx) / 2,
          cur.dy,
          cur.dx,
          cur.dy,
        );
      }
    }

    final metric = path.computeMetrics().first;
    final animatedPath = metric.extractPath(0, metric.length * progress);

    canvas.drawPath(
      animatedPath,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (progress == 1) {
      canvas.drawCircle(
        points[highlightIndex],
        7,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HighlightPainter extends CustomPainter {
  final int index;
  final int count;

  HighlightPainter(this.index, this.count);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width / count;
    final rect = Rect.fromLTWH(width * index, 0, width, size.height);

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.05)
        ],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(18)),
      paint,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
