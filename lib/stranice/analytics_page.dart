import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';
import '../widgets/analytics_empty_state.dart';
import '../widgets/analytics_stats_cards.dart';
import '../widgets/month_year_picker_dialog.dart';
import '../widgets/period_switcher.dart';
import '../widgets/profit_pie_chart.dart';
import '../widgets/top_bar_chart.dart';
import '../widgets/year_picker_dialog.dart';
import 'one/my_category_page.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AnalyticsProvider>().initWatcher();
  }

  Future<void> showCustomDatePicker(BuildContext context) async {
    final analytics = context.read<AnalyticsProvider>();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: analytics.isYearly
              ? YearPickerDialog(
                  availableYears: analytics.availableYears,
                  selectedYear: analytics.selectedDate.year,
                  onSelected: (year) {
                    analytics.setSelectedDate(DateTime(year));
                  },
                )
              : MonthYearPickerDialog(
                  isSelect: true,
                  now: DateTime.now(),
                  selectedDateTime: analytics.selectedDate,
                  date: (date) {
                    analytics.setSelectedDate(date);
                  },
                  availableDates: analytics.availableMonths,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final hasData = analytics.groupedData.values.any((v) => v != 0);

    final isYearly = analytics.isYearly;
    final multipleOptions = isYearly
        ? analytics.availableYears.length > 1
        : analytics.availableMonths.length > 1;

    return Scaffold(
      appBar: AppBarApp(
        title: 'Analytics',
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: multipleOptions ? () => showCustomDatePicker(context) : null,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SvgPicture.asset(
                'assets/icons/tttt.svg',
                color: multipleOptions ? Colors.white : Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: hasData
          ? Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 68.h),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProfitPieChart(),
                        SizedBox(height: 16.h),
                        const TopBarChart(),
                        SizedBox(height: 16.h),
                        const AnalyticsStatsCards(),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  color: Colors.black,
                  alignment: Alignment.centerLeft,
                  child: const PeriodSwitcher(),
                ),
              ],
            )
          : const AnalyticsEmptyState(),
    );
  }
}
