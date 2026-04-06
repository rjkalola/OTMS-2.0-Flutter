import 'package:belcka/buyer_app/inventory_charts/model/inventory_charts_overview_response.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryWeekBarChartCard extends StatelessWidget {
  const InventoryWeekBarChartCard({
    super.key,
    required this.block,
    required this.currency,
  });

  final WeekDaysWiseBlock block;
  final String currency;

  static const Color _inColor = Color(0xFF4CAF50);
  static const Color _outColor = Color(0xFFFF9800);

  String _fmt(double v) {
    if (v == v.roundToDouble()) {
      return '$currency${v.toInt()}';
    }
    return '$currency${v.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final days = block.days ?? [];
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    double maxY = 1;
    for (final d in days) {
      if (d.inventoryIn > maxY) maxY = d.inventoryIn;
      if (d.inventoryOut > maxY) maxY = d.inventoryOut;
    }
    maxY *= 1.15;
    if (maxY < 1) maxY = 1;

    return CardViewDashboardItem(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      borderRadius: 9,
      child: Column(
        children: [
          TitleTextView(
            text: block.week ?? '',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => primaryTextColor_(context).withValues(alpha: 0.9),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final i = group.x.toInt();
                      if (i < 0 || i >= days.length) return null;
                      final day = days[i];
                      final label = rodIndex == 0
                          ? '${'inventory_in_legend'.tr}: ${_fmt(day.inventoryIn)}'
                          : '${'inventory_out_legend'.tr}: ${_fmt(day.inventoryOut)}';
                      return BarTooltipItem(
                        label,
                        TextStyle(
                          color: backgroundColor_(context),
                          fontSize: 12,
                        ),
                      );
                    },
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
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            days[i].day ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryTextColor_(context),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: maxY > 5 ? maxY / 4 : 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _fmt(value),
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 5 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: shadowColor_(context).withValues(alpha: 0.3),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: [
                  for (int i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 4,
                      barRods: [
                        BarChartRodData(
                          toY: days[i].inventoryIn,
                          color: _inColor,
                          width: 10,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                        BarChartRodData(
                          toY: days[i].inventoryOut,
                          color: _outColor,
                          width: 10,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
