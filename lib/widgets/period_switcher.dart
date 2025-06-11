import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class PeriodSwitcher extends StatelessWidget {
  const PeriodSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();

    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            label: 'Monthly',
            isActive: !analytics.isYearly,
            onTap: () => analytics.toggleIsYearly(false),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ToggleButton(
            label: 'Annual',
            isActive: analytics.isYearly,
            onTap: () => analytics.toggleIsYearly(true),
          ),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E88E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFF1E88E5), width: 1.5),
        ),
        alignment: Alignment.center,
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
