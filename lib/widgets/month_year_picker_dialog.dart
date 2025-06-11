import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final bool isSelect;
  final DateTime now;
  final DateTime selectedDateTime;
  final Function(DateTime) date;
  final List<DateTime>? availableDates;

  const MonthYearPickerDialog({
    super.key,
    required this.isSelect,
    required this.now,
    required this.selectedDateTime,
    required this.date,
    this.availableDates,
  });

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  late int selectedMonth;
  late int selectedYear;

  late List<int> availableYears;
  late List<int> availableMonths;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.selectedDateTime.month;
    selectedYear = widget.selectedDateTime.year;

    if (widget.availableDates != null) {
      final filtered = widget.availableDates!;
      availableYears = filtered.map((e) => e.year).toSet().toList()..sort();
      availableMonths = filtered
          .where((e) => e.year == selectedYear)
          .map((e) => e.month)
          .toSet()
          .toList()
        ..sort();
    } else {
      availableYears = List.generate(10, (i) => widget.now.year - i);
      availableMonths = List.generate(12, (i) => i + 1);
    }

    yearController = FixedExtentScrollController(
        initialItem: availableYears.indexOf(selectedYear));
    monthController = FixedExtentScrollController(
        initialItem: availableMonths.indexOf(selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Select a month',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/icons/popop.svg'),
              )
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 150.h,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    scrollController: yearController,
                    itemExtent: 36.h,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = availableYears[index];
                        if (widget.availableDates != null) {
                          availableMonths = widget.availableDates!
                              .where((e) => e.year == selectedYear)
                              .map((e) => e.month)
                              .toSet()
                              .toList()
                            ..sort();
                          if (!availableMonths.contains(selectedMonth)) {
                            selectedMonth = availableMonths.first;
                          }
                          monthController.jumpToItem(
                              availableMonths.indexOf(selectedMonth));
                        }
                      });
                    },
                    children: availableYears
                        .map((y) => Center(
                              child: Text(
                                y.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: monthController,
                    itemExtent: 36.h,
                    onSelectedItemChanged: (index) {
                      selectedMonth = availableMonths[index];
                    },
                    children: availableMonths
                        .map((m) => Center(
                              child: Text(
                                _monthName(m),
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {
              widget.date(DateTime(selectedYear, selectedMonth));
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Select',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}
