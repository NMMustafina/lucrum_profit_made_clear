import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:profit_made_clear_254_t/main.dart';
import 'package:profit_made_clear_254_t/md/history/history_model.dart';
import 'package:profit_made_clear_254_t/md/transaction/transaction_model.dart';
import 'package:profit_made_clear_254_t/stranice/one/my_category_page.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../../asf/app_button.dart';
import '../../asf/color_asf.dart';
import '../../md/category/category_model.dart';
import '../../md/product/product_category_model.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({
    super.key,
    required this.categoryModel,
    required this.productCategoryModel,
  });

  ProductCategoryModel? productCategoryModel;
  CategoryModel? categoryModel;

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String selectedType = 'Buying';
  final numberController = TextEditingController();
  final totalController = TextEditingController();
  final priceController = TextEditingController();
  final ValueNotifier selectedDate = ValueNotifier(DateTime.now());

  bool isFormValid() {
    if (selectedType == 'Write-off') {
      setState(() {});
      return numberController.text.isNotEmpty;
    }
    setState(() {});
    return numberController.text.isNotEmpty &&
        totalController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
  }

  @override
  void dispose() {
    numberController.dispose();
    totalController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(title: 'Add transaction'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectType('Transaction type'),
            SizedBox(height: 8.h),
            TransactionTypeSelector(
              selected: selectedType,
              onChanged: (newType) {
                setState(() {
                  selectedType = newType;
                });
              },
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              'Number of units ',
              numberController,
              TextInputType.number,
              'Enter the number of units',
              onChange: (value) {},
            ),
            _buildTextField(
              'Total amount of money ',
              totalController,
              TextInputType.number,
              'Enter the total transaction amount',
              isRequired: selectedType != 'Write-off',
              onChange: (value) {
                if (numberController.text.isNotEmpty) {
                  int i = totalController.text.toInt();
                  int a = numberController.text.toInt();
                  String result = (i / a).toStringAsFixed(2);

                  priceController.text = result;
                }
              },
            ),
            _buildTextField(
              'Price per unit ',
              priceController,
              TextInputType.number,
              'Enter the unit price',
              isRequired: selectedType != 'Write-off',
              onChange: (value) {
                if (numberController.text.isNotEmpty) {
                  int i = priceController.text.toInt();
                  int a = numberController.text.toInt();
                  // String result = (i / a).toStringAsFixed(2);
                  String result = (i * a).toStringAsFixed(2);

                  totalController.text = result;
                }
              },
            ),
            selectType('Date '),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () async {
                await showCustomDateTimePicker(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.white),
                    SizedBox(width: 12.w),
                    ValueListenableBuilder(
                      valueListenable: selectedDate,
                      builder: (context, value, child) {
                        return Text(
                          DateFormat('MM.dd.yyyy').format(selectedDate.value),
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppButton(
        icon: 'assets/icons/dfdfd.svg',
        text: "Save",
        colorAll: isFormValid(),
        padding: EdgeInsets.symmetric(horizontal: 24),
        onTap: () {
          if (isFormValid()) {
            final String id = DateTime.now().toIso8601String();
            final String primeId = widget.categoryModel?.id ?? '';
            final CategoryModel? categoryModel = widget.categoryModel;

            TransactionModel transactionModel = TransactionModel(
              id: id,
              primeId: primeId,
              transactionType: selectedType,
              numberOfUnits: numberController.text.toInt(),
              totalAmountOfMoney: selectedType == 'Write-off'
                  ? null
                  : totalController.text.toInt(),
              pricePerUnit: selectedType == 'Write-off'
                  ? null
                  : priceController.text.toInt(),
              dateTime: selectedDate.value,
            );

            List<TransactionModel> transactionModelList =
                widget.productCategoryModel?.transactionModelList ?? [];
            transactionModelList.add(transactionModel);
            ProductCategoryModel productCategoryModel = ProductCategoryModel(
              id: widget.productCategoryModel?.id ?? '',
              primeId: primeId,
              naaame: widget.productCategoryModel?.naaame ?? '',
              dessssss: widget.productCategoryModel?.dessssss ?? '',
              im: widget.productCategoryModel?.im ?? '',
              transactionModelList: transactionModelList,
            );

            List<ProductCategoryModel> listok =
                widget.categoryModel?.listProduct ?? [];

            if (categoryModel != null && widget.productCategoryModel != null) {
              for (int i = 0; listok.length > i; i++) {
                if (listok[i].id == productCategoryModel.id) {
                  listok[i] = productCategoryModel;
                  break;
                }
              }
            }

            AS.localCategory.put(
                primeId,
                CategoryModel(
                    id: primeId,
                    tit: widget.categoryModel?.tit ?? '',
                    des: widget.categoryModel?.des ?? '',
                    im: widget.categoryModel?.im ?? '',
                    listProduct: listok));
            AS.historyModel.put(id, HistoryModel(id: id,
                primeId: primeId,
                dateTime: DateTime.now(),
                imgmsdf: widget.productCategoryModel?.im ?? '',
                titit: widget.productCategoryModel?.naaame ?? '',
                desasdfsdf: totalController.text));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label,
      TextEditingController controller,
      TextInputType type,
      String hint, {
        required Function(String? value) onChange,
        bool isRequired = true,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectType(label), // например, с точкой isRequired
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: controller,
                  keyboardType: type,
                  cursorColor: Colors.blue,
                  onChanged: (value) {
                    onChange(value);
                    isFormValid();
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),

          // затемняющий полупрозрачный контейнер поверх
          Visibility(
            visible: !isRequired,
            child: Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3), // степень затемнения
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
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
}

Widget selectType(String title) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$title  ",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: ColorAsf.b107CE0,
        ),
      )
    ],
  );
}

class Date extends StatefulWidget {
  Date({
    super.key,
    required this.now,
    required this.selectedDateTime,
    required this.date,
    this.isSelect = false,
  });

  final DateTime now;
  DateTime selectedDateTime;
  final bool isSelect;
  final Function(DateTime date) date;

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  List<int> years = [];
  final List<int> months = List.generate(12, (i) => i + 1);
  List<int> days = [];

  @override
  void initState() {
    super.initState();

    selectedYear = widget.selectedDateTime.year;
    selectedMonth = widget.selectedDateTime.month;
    selectedDay = widget.selectedDateTime.day;

    years = List.generate(widget.now.year - 1999, (i) => 2000 + i);
    _updateDays();
  }

  void _updateDays() {
    final lastDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
    days = List.generate(lastDay, (i) => i + 1);
    if (selectedDay > lastDay) {
      selectedDay = lastDay;
    }
  }

  void _onDateChanged() {
    final selected = DateTime(selectedYear, selectedMonth, selectedDay);
    if (selected.isAfter(widget.now)) return;

    widget.selectedDateTime = selected;
    widget.date(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
               Text(
                 widget.isSelect ?  "Select a month" :"Select a date" ,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset('assets/icons/popop.svg'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.dark,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(color: Colors.white),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.black,
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                        initialItem: years.indexOf(selectedYear),
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = years[index];
                          _updateDays();
                          _onDateChanged();
                        });
                      },
                      children: years.map((y) => Text('$y')).toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.black,
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedMonth - 1,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                          _updateDays();
                          _onDateChanged();
                        });
                      },
                      children: months
                          .map((m) =>
                          Text(
                            DateFormat.MMMM().format(DateTime(0, m)),
                          ))
                          .toList(),
                    ),
                  ),
                  Visibility(
                    visible: !widget.isSelect,
                    child: Expanded(
                      child: CupertinoPicker(
                        backgroundColor: Colors.black,
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedDay - 1,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedDay = index + 1;
                            _onDateChanged();
                          });
                        },
                        children: days.map((d) => Text('$d')).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Text("Select", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTypeSelector extends StatefulWidget {
  final Function(String) onChanged;
  final String selected;

  const TransactionTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<TransactionTypeSelector> createState() =>
      _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  final List<String> types = ['Buying', 'Selling', 'Write-off'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types.map((type) {
        final isSelected = widget.selected == type;
        return GestureDetector(
          onTap: () => widget.onChanged(type),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? ColorAsf.b107CE0 : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF367BF6)),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : ColorAsf.b107CE0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
