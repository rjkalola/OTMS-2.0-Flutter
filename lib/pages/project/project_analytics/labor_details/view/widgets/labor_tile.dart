import 'package:belcka/pages/project/project_analytics/labor_details/model/labor_details_model.dart';
import 'package:belcka/pages/project/project_analytics/labor_details/view/widgets/expanded_stat.dart';
import 'package:flutter/material.dart';

class LaborTile extends StatefulWidget {
  final LaborEntry entry;
  const LaborTile({required this.entry});

  @override
  State<LaborTile> createState() => _LaborTileState();
}

class _LaborTileState extends State<LaborTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _expanded
                ? e.avatarColor.withOpacity(0.4)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _expanded
                  ? e.avatarColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _expanded ? 18 : 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        e.avatarColor,
                        e.avatarColor.withOpacity(0.7)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: e.avatarColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(e.avatarInitials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A))),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: e.avatarColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(e.role,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: e.avatarColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fmtGbp(e.amount, decimals: 0),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 11, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 3),
                        Text(
                          '${e.hours.toStringAsFixed(0)}:00 h',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[100], height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ExpandedStat(
                        label: 'Hourly Rate',
                        value: '${fmtGbp(e.hourlyRate, decimals: 2)}/h',
                        color: e.avatarColor),
                  ),
                  Expanded(
                    child: ExpandedStat(
                        label: 'Hours Logged',
                        value: '${e.hours.toStringAsFixed(0)} hrs',
                        color: e.avatarColor),
                  ),
                  Expanded(
                    child: ExpandedStat(
                        label: 'Total Earned',
                        value: fmtGbp(e.amount, decimals: 0),
                        color: e.avatarColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}