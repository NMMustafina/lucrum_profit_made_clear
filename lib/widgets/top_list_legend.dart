import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class TopListLegend extends StatelessWidget {
  const TopListLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final data = analytics.groupedData;
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top10 = entries.take(10).toList();
    final colorMap = _generateColorMap(top10);

    return Column(
      children: List.generate(top10.length, (i) {
        final entry = top10[i];
        final name = entry.key;
        final value = entry.value;
        final color = colorMap[name]!;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatDollar(value),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (i < top10.length - 1)
              Divider(color: Colors.grey.shade800, height: 1),
          ],
        );
      }),
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
      return '$prefix${abs.toStringAsFixed(2)}';
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
