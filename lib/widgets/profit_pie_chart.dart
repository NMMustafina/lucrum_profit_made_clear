import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class ProfitPieChart extends StatelessWidget {
  const ProfitPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    final netProfit = analytics.totalProfit;
    final loss = analytics.totalLoss;
    final isEmpty = netProfit == 0 && loss == 0;
    final total = netProfit - loss;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade800),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Text(
            _formatPeriodLabel(analytics),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 220.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 90.w,
                    startDegreeOffset: 270,
                    sections: isEmpty
                        ? [
                            PieChartSectionData(
                              value: 1,
                              color: Colors.grey.shade700,
                              showTitle: false,
                              radius: 25.w,
                            ),
                          ]
                        : [
                            if (netProfit > 0)
                              PieChartSectionData(
                                value: netProfit,
                                color: const Color(0xFF35D215),
                                showTitle: false,
                                radius: 25.w,
                              ),
                            if (loss > 0)
                              PieChartSectionData(
                                value: loss,
                                color: const Color(0xFFFA1717),
                                showTitle: false,
                                radius: 25.w,
                              ),
                          ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        isEmpty
                            ? '\$0.00'
                            : _formatDollar(netProfit > 0 ? total : -loss),
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          if (netProfit > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _Dot(color: const Color(0xFF35D215)),
                    SizedBox(width: 6.w),
                    Text('Profit',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                  ],
                ),
                Text('\$${netProfit.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
          if (loss > 0)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _Dot(color: const Color(0xFFFA1717)),
                      SizedBox(width: 6.w),
                      Text('Loss',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white)),
                    ],
                  ),
                  Text('-\$${loss.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatPeriodLabel(AnalyticsProvider analytics) {
    final d = analytics.selectedDate;
    return analytics.isYearly
        ? '${d.year} Earnings'
        : '${_monthName(d.month)} Earnings';
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[month - 1];
  }
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
    return '$prefix${abs.toStringAsFixed(2)}';
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
