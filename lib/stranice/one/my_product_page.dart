import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:profit_made_clear_254_t/main.dart';
import 'package:profit_made_clear_254_t/md/category/category_model.dart';
import 'package:profit_made_clear_254_t/md/product/product_category_model.dart';
import 'package:profit_made_clear_254_t/md/transaction/transaction_model.dart';
import 'package:profit_made_clear_254_t/stranice/one/add_transaction_page.dart';
import 'package:profit_made_clear_254_t/stranice/one/my_category_page.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../../asf/app_button.dart';
import '../../asf/color_asf.dart';
import 'create_product_page.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key, required this.productCategoryModel});

  final ProductCategoryModel productCategoryModel;

  @override
  State<MyProductPage> createState() => _MyProductPageState();
}

Future<void> _showEditDeleteDialog(
  BuildContext context, {
  required CategoryModel categoryModel,
  required ProductCategoryModel product,
}) async {
  await showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProductPage(
                      isEdit: true,
                      categoryModel: categoryModel,
                      productCategoryModel: product,
                    ),
                  ));
            });
          },
          child: Text(
            'Edit',
            style: TextStyle(color: ColorAsf.b0A84FF, fontSize: 16.sp),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            final bool? isDelete = await showDeleteCategoryDialog(context);

            if (isDelete ?? false) {
              List<ProductCategoryModel> list = categoryModel.listProduct;
              for (int i = 0; list.length > i; i++) {
                if (list[i].id == product.id) {
                  list.remove(list[i]);
                  break;
                }
              }
              CategoryModel newCategory = CategoryModel(
                  id: categoryModel.id,
                  tit: categoryModel.tit,
                  des: categoryModel.des,
                  im: categoryModel.im,
                  listProduct: list);

              AS.localCategory.put(
                categoryModel.id,
                newCategory,
              );
              Navigator.of(context).pop();
            }
            Navigator.pop(context);
          },
          isDestructiveAction: true,
          child: Text(
            'Delete',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        // isDefaultAction: true,
        child: Text(
          'Cancel',
          style: TextStyle(color: ColorAsf.b0A84FF, fontSize: 16.sp),
        ),
      ),
    ),
  );
}

class _MyProductPageState extends State<MyProductPage> {
  @override
  Widget build(BuildContext scaffoldContext) {
    final ProductCategoryModel model = widget.productCategoryModel;

    return ValueListenableBuilder(
      valueListenable: AS.localCategory.listenable(),
      builder: (context, value, child) {
        ProductCategoryModel? productCategoryModel;
        List<ProductCategoryModel> listCategory =
            value.get(model.primeId)?.listProduct ?? [];
        for (int i = 0; listCategory.length > i; i++) {
          if (widget.productCategoryModel.id == listCategory[i].id) {
            productCategoryModel = listCategory[i];
            break;
          }
        }

        CategoryModel? categoryModel = AS.localCategory.get(model.primeId);
        // int quantityProduct = 0;
        // int revenueProduct = 0;
        // === Profit & ROS Calculation ===
        double totalBuyCost = 0;
        int totalBuyUnits = 0;
        double totalProfit = 0;
        int totalRevenue = 0;
        int quantityProduct = 0;
        int revenueProduct = 0;

        productCategoryModel?.transactionModelList.forEach((t) {
          if (t.transactionType == 'Buying') {
            totalBuyCost += t.totalAmountOfMoney ?? 0;
            totalBuyUnits += t.numberOfUnits;
            quantityProduct += t.numberOfUnits;
          } else if (t.transactionType == 'Selling') {
            final costPerUnit = totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
            totalRevenue += t.totalAmountOfMoney ?? 0;
            quantityProduct -= t.numberOfUnits;
            revenueProduct += t.totalAmountOfMoney ?? 0;
            totalProfit += ((t.pricePerUnit ?? 0) - costPerUnit) * t.numberOfUnits;
          } else if (t.transactionType == 'Write-off') {
            final costPerUnit = totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
            totalProfit -= costPerUnit * t.numberOfUnits;
            quantityProduct -= t.numberOfUnits;
          }
        });

        final double ros = totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0;


        return Scaffold(
          appBar: AppBarApp(
            title: 'My product',
            actions: [
              GestureDetector(
                onTap: () {
                  if (categoryModel != null || productCategoryModel != null) {
                    _showEditDeleteDialog(
                      context,
                      categoryModel: categoryModel!,
                      product: productCategoryModel!,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SvgPicture.asset('assets/icons/fdfdfdf.svg'),
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (productCategoryModel?.im ?? '').isEmpty
                            ? SvgPicture.asset(
                                'assets/icons/fds.svg',
                                width: 150.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(productCategoryModel?.im ?? ''),
                                width: 120.w,
                                height: 120.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(width: 16.w),

                      // Product name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productCategoryModel?.naaame ?? '',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Visibility(
                               visible: quantityProduct !=0,
                              child: _infoRow(
                                "assets/icons/lllll.svg",
                                'Quantity: ',
                                '$quantityProduct',
                              ),
                            ),

                            // Revenue
                            Visibility(
                              visible: revenueProduct !=0,
                              child: _infoRow(
                                "assets/icons/cve.svg",
                                'Revenue: ',
                                '\$$revenueProduct',
                              ),
                            ),

                            // === Profit ===
                            _infoRow(
                              "assets/icons/stic.svg",
                              'Profit: ',
                              '\$${totalProfit.toStringAsFixed(2)}',
                              valueColor: totalProfit < 0 ? Colors.red : Colors.green,
                            ),

// === ROS ===
                            _infoRow(
                              "assets/icons/uare.svg",
                              'ROS: ',
                              '${ros.toStringAsFixed(2)}%',
                              // valueColor: ros < 0 ? Colors.red : Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Description
                  Text(
                    productCategoryModel?.dessssss ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    children: List.generate(
                      (productCategoryModel?.transactionModelList ?? []).length,
                      (index) {
                        final asd =
                            productCategoryModel?.transactionModelList[index];

                        final int totalAmount = asd?.totalAmountOfMoney ?? 0;
                        final String formattedAmount = '\$${(asd?.transactionType == 'Write-off' ? -totalAmount : totalAmount)}';
                        final bool isNegative = asd?.transactionType == 'Write-off';

                        String title = '';
                        String? subtitle;

                        if (asd?.transactionType == 'Buying') {
                          title = 'Buying ${asd?.numberOfUnits} units';
                          subtitle = '\$${asd?.pricePerUnit} per unit';
                        } else if (asd?.transactionType == 'Selling') {
                          title = 'Selling ${asd?.numberOfUnits} units';
                          subtitle = '\$${asd?.pricePerUnit} per unit';
                        } else if (asd?.transactionType == 'Write-off') {
                          title = 'Write-off ${asd?.numberOfUnits} units';
                          subtitle = null; // нет subtitle
                        }
                        return TransactionCard(
                          isNullSubtitle: subtitle == null,
                          date: '${asd?.dateTime.day.toString().padLeft(2, '0')}.${asd?.dateTime.month.toString().padLeft(2, '0')}.${asd?.dateTime.year}',
                          title: title,
                          subtitle: subtitle ?? '',
                          amount: formattedAmount,
                          amountColor: isNegative ? Colors.red : Colors.white,
                          onMenuTap: (tapPosition) async {
                            _showContextMenu(
                              context,
                              tapPosition,
                              delete: () async {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  final bool? isDelete =
                                      await showDeleteCategoryDialog(context);
                                  if (isDelete ?? false) {
                                    final as = categoryModel!;
                                    List<TransactionModel> transList =
                                        productCategoryModel
                                                ?.transactionModelList ?? [];
                                    for (int i = 0; transList.length > i; i++) {
                                      if (transList[i].id == asd!.id) {
                                        transList.remove(transList[i]);
                                        break;
                                      }
                                    }

                                    List<ProductCategoryModel> product =
                                        as.listProduct;

                                    for (int i = 0; product.length > i; i++) {
                                      if (product[i].id ==
                                          productCategoryModel?.id) {
                                        product[i] = ProductCategoryModel(
                                            id: product[i].id,
                                            primeId: product[i].primeId,
                                            naaame: product[i].naaame,
                                            dessssss: product[i].dessssss,
                                            im: product[i].im,
                                            transactionModelList: transList);
                                        break;
                                      }
                                    }

                                    AS.localCategory.put(
                                        as.id,
                                        CategoryModel(
                                          id: as.id,
                                          tit: as.tit,
                                          des: as.des,
                                          im: as.im,
                                          listProduct: product,
                                        ));
                                  }
                                });
                              },
                              edit: () async {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  edisdV(
                                    categoryModel: categoryModel,
                                    asd: asd,
                                    productCategoryModel: productCategoryModel,
                                  );
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 100.h)
                ],
              ),
            ),
          ),
          floatingActionButton: AppButton(
            padding: EdgeInsets.symmetric(horizontal: 24),
            icon: 'assets/icons/ote.svg',
            text: "Add transaction",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionPage(
                      categoryModel: categoryModel,
                      productCategoryModel: productCategoryModel,
                    ),
                  ));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void edisdV({
    required ProductCategoryModel? productCategoryModel,
    required CategoryModel? categoryModel,
    required TransactionModel? asd,
  }) {
    if (productCategoryModel != null && categoryModel != null && asd != null) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        // это уже из Scaffold, т.к. ты внутри build
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => EditEntryPage(
          productCategoryModel: productCategoryModel,
          categoryModel: categoryModel,
          transactionModel: asd,
        ),
      );
    }
  }

  void _showContextMenu(
    BuildContext context,
    Offset position, {
    required Function() delete,
    required Function() edit,
  }) {
    // final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: position.dx - 180,
              top: position.dy - 40,
              child: _PopupMenu(
                delete: delete,
                edit: edit,
              ), // меню редактировать / удалить
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String icon,
    String text,
    String textValue, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: Colors.white,
            width: 16,
            height: 16,
          ),
          SizedBox(width: 6.w),
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 4),
              Text(
                textValue,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    required this.edit,
    required this.delete,
  });

  final Function() edit;
  final Function() delete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 160.w,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _popupItem(
              icon: Icons.edit_outlined,
              text: "Edit",
              onTap: () {
                edit();
                Navigator.pop(context);
                // Handle edit
              },
            ),
            Divider(height: 1, color: Colors.white.withOpacity(0.1)),
            _popupItem(
              icon: Icons.delete_outline,
              text: "Delete",
              onTap: () {
                delete();
                Navigator.pop(context);
                // Handle delete
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _popupItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  final String amount;
  final bool isNullSubtitle;
  final void Function(Offset tapPosition)? onMenuTap;
  final Color amountColor;

  const TransactionCard({
    super.key,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isNullSubtitle,
    required this.amountColor,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    Offset? _tapPosition;

    return GestureDetector(
      onTapDown: (details) => _tapPosition = details.globalPosition,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapDown: (details) => _tapPosition = details.globalPosition,
                  onTap: () {
                    if (onMenuTap != null && _tapPosition != null) {
                      onMenuTap!(_tapPosition!);
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3C),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.more_horiz,
                        size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600)),
                Text(
                  amount,
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !isNullSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}

void showPremium({
  required BuildContext context,
  required Widget page,
  required double radius,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: page,
      );
    },
  );
}

class EditEntryPage extends StatefulWidget {
  const EditEntryPage({
    super.key,
    required this.productCategoryModel,
    required this.categoryModel,
    required this.transactionModel,
  });

  final ProductCategoryModel productCategoryModel;
  final CategoryModel categoryModel;
  final TransactionModel transactionModel;

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final ValueNotifier selectedDate = ValueNotifier(DateTime.now());
  final TextEditingController one = TextEditingController();
  final TextEditingController two = TextEditingController();
  final TextEditingController three = TextEditingController();

  @override
  void initState() {
    if (isChekcs()) {
      two.text = widget.transactionModel.totalAmountOfMoney.toString();
      three.text = widget.transactionModel.pricePerUnit.toString();
    }
    selectedDate.value = widget.transactionModel.dateTime;
    one.text = widget.transactionModel.numberOfUnits.toString();
    super.initState();
  }

  bool isChekcs() {
    if (widget.transactionModel.totalAmountOfMoney != null &&
        widget.transactionModel.pricePerUnit != null) {
      return true;
    } else {
      return false;
    }
  }

  bool cheksink() {
    if (widget.transactionModel.transactionType == 'Write-off') {
      if (one.text.isNotEmpty) {
        setState(() {});
        return true;
      } else {
        setState(() {});
        return false;
      }
    } else {
      if (one.text.isNotEmpty && two.text.isNotEmpty && three.text.isNotEmpty) {
        setState(() {});
        return true;
      } else {
        setState(() {});
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          Center(
            child: Text(
              "Edit entry",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Number of units sold
          _buildTextField(
            'Number of units sold',
            one,
            TextInputType.number,
            'Enter the number of units',
          ),
          Visibility(
            visible: isChekcs(),
            child: Column(
              children: [
                _buildTextField(
                  'Total amount of money',
                  two,
                  TextInputType.number,
                  'Enter the total transaction amount',
                ),
                _buildTextField(
                  'Price per unit',
                  three,
                  TextInputType.number,
                  'Enter the unit price',
                ),
              ],
            ),
          ),

          // Date
          selectType('Date'),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () async {
              await showCustomDateTimePicker(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
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
          SizedBox(height: 24),

          AppButton(
            text: 'Save',
            icon: 'assets/icons/dfdfd.svg',
            colorAll: cheksink(),
            onTap: () {
              if (cheksink()) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  TransactionModel asd = widget.transactionModel;

                  final CategoryModel as = widget.categoryModel;
                  List<TransactionModel> transList =
                      widget.productCategoryModel.transactionModelList;
                  for (int i = 0; transList.length > i; i++) {
                    if (transList[i].id == asd.id) {
                      final int? tt;
                      final int? hh;
                      if (transList[i].totalAmountOfMoney == null) {
                        tt = null;
                        hh = null;
                      } else {
                        tt = two.text.toInt();
                        hh = three.text.toInt();
                      }

                      three.text.toInt();
                      transList[i] = TransactionModel(
                        id: transList[i].id,
                        primeId: transList[i].primeId,
                        transactionType: transList[i].transactionType,
                        numberOfUnits: one.text.toInt(),
                        totalAmountOfMoney: tt,
                        pricePerUnit: hh,
                        dateTime: selectedDate.value,
                      );
                      // transList.remove(transList[i]);
                      break;
                    }
                  }

                  List<ProductCategoryModel> product = as.listProduct;

                  for (int i = 0; product.length > i; i++) {
                    if (product[i].id == widget.productCategoryModel.id) {
                      product[i] = ProductCategoryModel(
                          id: product[i].id,
                          primeId: product[i].primeId,
                          naaame: product[i].naaame,
                          dessssss: product[i].dessssss,
                          im: product[i].im,
                          transactionModelList: transList);
                      break;
                    }
                  }

                  AS.localCategory.put(
                      as.id,
                      CategoryModel(
                        id: as.id,
                        tit: as.tit,
                        des: as.des,
                        im: as.im,
                        listProduct: product,
                      ));
                });
                Navigator.of(context).pop();
              }
            },
          ),
          SizedBox(height: 24.h),
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
                now: widget.transactionModel.dateTime,
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType type,
    String hint, {
    bool isRequired = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectType(label),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: controller,
                  keyboardType: type,
                  cursorColor: Colors.blue,
                  onChanged: (String value) {
                    cheksink();
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
}
