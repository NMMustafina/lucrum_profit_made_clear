import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class AnalyticsStatsCards extends StatelessWidget {
  const AnalyticsStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    final items = [
      _StatCardData(
          'assets/icons/ctr.svg', 'Total TRANS.', analytics.totalTransactions),
      _StatCardData(
          'assets/icons/csnd.svg', 'Products bought', analytics.totalBought),
      _StatCardData(
          'assets/icons/cve.svg', 'Products sold', analytics.totalSold),
      _StatCardData(
          'assets/icons/crs.svg', 'Written-off', analytics.totalWrittenOff),
    ].where((item) => item.value > 0).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.9,
      ),
      itemBuilder: (_, i) => _AnalyticsCard(data: items[i]),
    );
  }
}

class _StatCardData {
  final String iconPath;
  final String label;
  final int value;

  _StatCardData(this.iconPath, this.label, this.value);
}

class _AnalyticsCard extends StatelessWidget {
  final _StatCardData data;
  const _AnalyticsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(data.iconPath, width: 16.w, height: 16.w),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  data.label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            data.value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
