import 'package:belcka/buyer_app/inventory_charts/model/inventory_charts_overview_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryLineChartCard extends StatelessWidget {
  const InventoryLineChartCard({
    super.key,
    required this.weeks,
    required this.currency,
    required this.titleRange,
  });

  final List<WeekWisePoint> weeks;
  final String currency;
  final String titleRange;

  static const Color _inColor = Color(0xFF4CAF50);
  static const Color _outColor = Color(0xFFE53935);

  String _fmtAxis(double v) {
    if (v >= 1000) {
      return '$currency${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}k';
    }
    if (v == v.roundToDouble()) {
      return '$currency${v.toInt()}';
    }
    return '$currency${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) {
      return const SizedBox.shrink();
    }

    double maxY = 1;
    for (final w in weeks) {
      if (w.inventoryIn > maxY) maxY = w.inventoryIn;
      if (w.inventoryOut > maxY) maxY = w.inventoryOut;
    }
    maxY *= 1.12;
    if (maxY < 1) maxY = 1;

    final inSpots = <FlSpot>[];
    final outSpots = <FlSpot>[];
    for (int i = 0; i < weeks.length; i++) {
      inSpots.add(FlSpot(i.toDouble(), weeks[i].inventoryIn));
      outSpots.add(FlSpot(i.toDouble(), weeks[i].inventoryOut));
    }

    final int n = weeks.length;
    final double lastX = n <= 1 ? 0 : (n - 1).toDouble();
    // Extra domain on X so few points sit visually centered and edge labels fit.
    double xEdgePad(int count) {
      if (count <= 1) return 0.7;
      if (count <= 3) return 0.55;
      if (count <= 6) return 0.35;
      return 0.22;
    }

    final pad = xEdgePad(n);
    final double minX = 0 - pad;
    final double maxX = lastX + pad;

    return CardViewDashboardItem(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      borderRadius: 9,
      child: Column(
        children: [
          TitleTextView(
            text: titleRange,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: 0,
                  maxY: maxY,
                  lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) =>
                        primaryTextColor_(context).withValues(alpha: 0.92),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((s) {
                        final wi =
                            s.x.round().clamp(0, weeks.length - 1);
                        if (wi < 0 || wi >= weeks.length) return null;
                        final w = weeks[wi];
                        final isIn = s.bar.color == _inColor;
                        final val = isIn ? w.inventoryIn : w.inventoryOut;
                        final label = isIn
                            ? '${'inventory_in_legend'.tr}: $currency$val'
                            : '${'inventory_out_legend'.tr}: $currency$val';
                        return LineTooltipItem(
                          label,
                          TextStyle(
                            color: backgroundColor_(context),
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 4 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: shadowColor_(context).withValues(alpha: 0.35),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final i = value.round();
                        if ((value - i).abs() > 0.001) {
                          return const SizedBox.shrink();
                        }
                        if (i < 0 || i >= weeks.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(
                            meta,
                            distanceFromEdge: 10,
                          ),
                          child: Text(
                            weeks[i].week ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryTextColor_(context),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: maxY > 4 ? maxY / 4 : 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _fmtAxis(value),
                          style: TextStyle(
                            fontSize: 9,
                            color: primaryTextColor_(context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: inSpots,
                    color: _inColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    isCurved: false,
                  ),
                  LineChartBarData(
                    spots: outSpots,
                    color: _outColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    isCurved: false,
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
