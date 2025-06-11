import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';
import 'top_list_legend.dart';

class TopBarChart extends StatelessWidget {
  const TopBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final data = analytics.groupedData;
    final showProducts = analytics.showProducts;

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top10 = entries.take(10).toList();

    final maxValue = top10
        .map((e) => e.value.abs())
        .fold<double>(0, (a, b) => a > b ? a : b);
    final yLimit = maxValue.ceilToDouble();

    final hasPositive = top10.any((e) => e.value > 0);
    final hasNegative = top10.any((e) => e.value < 0);

    final double yMax, yMin;
    if (hasPositive && hasNegative) {
      yMax = yLimit;
      yMin = -yLimit;
    } else if (hasNegative) {
      yMax = 0;
      yMin = -yLimit;
    } else {
      yMax = yLimit;
      yMin = 0;
    }

    final interval = (yMax - yMin) / 3;

    final barGroups = <BarChartGroupData>[];
    final colorMap = _generateColorMap(top10);

    for (int i = 0; i < 10; i++) {
      if (i < top10.length) {
        final entry = top10[i];
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: colorMap[entry.key]!,
                width: 12.w,
                borderRadius: BorderRadius.zero,
              ),
            ],
          ),
        );
      } else {
        barGroups.add(BarChartGroupData(x: i, barRods: []));
      }
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade800),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Top ${showProducts ? 'Products' : 'Categories'}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _ToggleChartSwitch(),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 160.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: yMax,
                minY: yMin,
                barGroups: barGroups,
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    const tolerance = 0.1;
                    final steps = hasPositive && hasNegative
                        ? [
                            -yLimit,
                            -2 * yLimit / 3,
                            -yLimit / 3,
                            0,
                            yLimit / 3,
                            2 * yLimit / 3,
                            yLimit,
                          ]
                        : [
                            if (yMin < 0) ...[
                              yMin,
                              2 * yMin / 3,
                              yMin / 3,
                            ],
                            0,
                            if (yMax > 0) ...[
                              yMax / 3,
                              2 * yMax / 3,
                              yMax,
                            ],
                          ];

                    final match =
                        steps.any((step) => (value - step).abs() < tolerance);
                    return match
                        ? FlLine(
                            color: Colors.white,
                            strokeWidth: 0.5,
                            dashArray: [4, 4],
                          )
                        : FlLine(strokeWidth: 0);
                  },
                  horizontalInterval: yLimit / 3,
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: Colors.white,
                      strokeWidth: 0.5,
                      dashArray: [4, 4],
                    ),
                    if (hasPositive && hasNegative) ...[
                      HorizontalLine(
                        y: -yLimit,
                        color: Colors.white,
                        strokeWidth: 0.5,
                        dashArray: [4, 4],
                      ),
                      HorizontalLine(
                        y: yLimit,
                        color: Colors.white,
                        strokeWidth: 0.5,
                        dashArray: [4, 4],
                      ),
                    ] else if (hasNegative) ...[
                      HorizontalLine(
                        y: yMin,
                        color: Colors.white,
                        strokeWidth: 0.5,
                        dashArray: [4, 4],
                      ),
                    ] else if (hasPositive) ...[
                      HorizontalLine(
                        y: yMax,
                        color: Colors.white,
                        strokeWidth: 0.5,
                        dashArray: [4, 4],
                      ),
                    ],
                  ],
                ),
                titlesData: FlTitlesData(
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: interval,
                      getTitlesWidget: (val, _) => FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatDollar(val),
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.white54, height: 24.h),
          const TopListLegend(),
        ],
      ),
    );
  }

  String _formatDollar(num value) {
    final abs = value.abs();
    final prefix = value < 0 ? '-\$' : '\$';

    if (abs >= 1e9) {
      return '$prefix${(abs / 1e9).toStringAsFixed(1)}B';
    } else if (abs >= 1e6) {
      return '$prefix${(abs / 1e6).toStringAsFixed(1)}M';
    } else if (abs >= 1e3) {
      return '$prefix${(abs / 1e3).toStringAsFixed(1)}K';
    } else {
      return '$prefix${abs.toInt()}';
    }
  }

  Map<String, Color> _generateColorMap(List<MapEntry<String, double>> top10) {
    const positiveColors = [
      Color(0xFF00B4FF),
      Color(0xFF00D1C1),
      Color(0xFF00A896),
      Color(0xFF00919C),
      Color(0xFF00CC2C),
    ];
    const negativeColors = [
      Color(0xFFFF0000),
      Color(0xFFFF3030),
      Color(0xFFFF6B4A),
      Color(0xFFFFA500),
      Color(0xFF9ACD32),
    ];

    final positives = top10.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final negatives = top10.where((e) => e.value < 0).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final Map<String, Color> map = {};
    for (int i = 0; i < positives.length; i++) {
      map[positives[i].key] =
          positiveColors[i.clamp(0, positiveColors.length - 1)];
    }
    for (int i = 0; i < negatives.length; i++) {
      map[negatives[i].key] =
          negativeColors[i.clamp(0, negativeColors.length - 1)];
    }
    return map;
  }
}

class _ToggleChartSwitch extends StatelessWidget {
  const _ToggleChartSwitch();

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final showProducts = analytics.showProducts;

    return Row(
      children: [
        _ChartToggleButton(
          label: 'CTG',
          isActive: !showProducts,
          onTap: () => analytics.toggleShowProducts(),
        ),
        SizedBox(width: 6.w),
        _ChartToggleButton(
          label: 'PDT',
          isActive: showProducts,
          onTap: () => analytics.toggleShowProducts(),
        ),
      ],
    );
  }
}

class _ChartToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ChartToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E88E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF1E88E5), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF1E88E5),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
