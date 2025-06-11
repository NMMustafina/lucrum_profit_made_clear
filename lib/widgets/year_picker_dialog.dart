import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class YearPickerDialog extends StatefulWidget {
  final int selectedYear;
  final List<int> availableYears;
  final Function(int) onSelected;

  const YearPickerDialog({
    super.key,
    required this.selectedYear,
    required this.availableYears,
    required this.onSelected,
  });

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late FixedExtentScrollController yearController;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.selectedYear;
    widget.availableYears.sort();
    yearController = FixedExtentScrollController(
      initialItem: widget.availableYears.indexOf(selectedYear),
    );
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
                    'Select a year',
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
            child: CupertinoPicker(
              scrollController: yearController,
              itemExtent: 36.h,
              onSelectedItemChanged: (index) {
                selectedYear = widget.availableYears[index];
              },
              children: widget.availableYears
                  .map(
                    (y) => Center(
                      child: Text(
                        y.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {
              widget.onSelected(selectedYear);
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
          ),
        ],
      ),
    );
  }
}
