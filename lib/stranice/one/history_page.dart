import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profit_made_clear_254_t/md/history/history_model.dart';
import 'package:profit_made_clear_254_t/stranice/one/my_category_page.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import 'add_transaction_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ValueNotifier selectedDate = ValueNotifier(DateTime.now());
  List<HistoryModel> historyModel = [];

  @override
  void initState() {
    historyModel = AS.historyModel.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(
        title: 'History',
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              await showCustomDateTimePicker(context);
            },
            child: SvgPicture.asset(
              'assets/icons/okokok.svg',
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedDate,
        builder: (context, value, child) {
          // 📅 Фильтруем по выбранному месяцу и году
          final filtered = historyModel
              .where(
                (model) =>
                    model.dateTime.month == value.month &&
                    model.dateTime.year == value.year,
              )
              .toList();

          final groupedData = _groupByDate(filtered);

          return filtered.isEmpty
              ? Center(
                  child: Text(
                    'Empty',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: groupedData.length,
                  itemBuilder: (context, index) {
                    final entry = groupedData.entries.elementAt(index);
                    final dateLabel = entry.key;
                    final items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 12.h),
                          child: Text(
                            dateLabel,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        ...items.map(
                          (model) => CartOOsdf(
                            title: model.titit,
                            img: model.imgmsdf,
                            price: model.desasdfsdf,
                          ),
                        )
                      ],
                    );
                  },
                );
        },
      ),
    );
  }

  Future<void> showCustomDateTimePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Date(
                isSelect: true,
                now: DateTime.now(),
                selectedDateTime: selectedDate.value,
                date: (date) {
                  selectedDate.value = date;
                },
              );
            },
          ),
        );
      },
    );
  }

  Map<String, List<HistoryModel>> _groupByDate(List<HistoryModel> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));

    Map<String, List<HistoryModel>> grouped = {};

    for (var model in list) {
      final date = DateTime(
          model.dateTime.year, model.dateTime.month, model.dateTime.day);

      String label;
      if (date == today) {
        label = "Today";
      } else if (date == yesterday) {
        label = "Yesterday";
      } else {
        label = "${_monthName(date.month)} ${date.day}, ${date.year}";
      }

      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]!.add(model);
    }

    return grouped;
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}

class CartOOsdf extends StatelessWidget {
  const CartOOsdf({
    super.key,
    required this.img,
    required this.title,
    required this.price,
  });

  final String img;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Color(0xff252525)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  File(img),
                  width: 40.w,
                  height: 40.h,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              )),
              SizedBox(width: 16.w),
              Text(
                "\$$price",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
