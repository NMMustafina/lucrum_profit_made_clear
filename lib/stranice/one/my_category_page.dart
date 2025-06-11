import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profit_made_clear_254_t/asf/color_asf.dart';
import 'package:profit_made_clear_254_t/md/category/category_model.dart';
import 'package:profit_made_clear_254_t/md/product/product_category_model.dart';
import 'package:profit_made_clear_254_t/md/transaction/transaction_model.dart';
import 'package:profit_made_clear_254_t/stranice/one/create_category_page.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../../asf/app_button.dart';
import 'add_transaction_page.dart';
import 'create_product_page.dart';
import 'my_product_page.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({super.key, required this.categoryModel1});

  final CategoryModel categoryModel1;

  @override
  State<MyCategoryPage> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  final fO = ValueNotifier(0);
  final sT = ValueNotifier(0);
  final tT = ValueNotifier(0.0);
  final fF = ValueNotifier(0.0);
  // final fFive = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AS.localCategory.listenable(),
      builder: (context, value, child) {
        final CategoryModel categoryModel =
            AS.localCategory.get(widget.categoryModel1.id) ??
                widget.categoryModel1;
        return Scaffold(
          appBar: AppBarApp(
            title: 'My category',
            actions: [
              GestureDetector(
                onTap: () {
                  showEditDeleteDialog(
                    context,
                    categoryModel: categoryModel,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SvgPicture.asset('assets/icons/fdfdfdf.svg'),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  _Container(
                    categoryModel: categoryModel,
                    fF: fF.value,
                    fO: fO.value,
                    sT: sT.value,
                    tT: tT.value,
                    length:categoryModel.listProduct.length,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 22.h),
                        Visibility(
                          visible: categoryModel.listProduct.isNotEmpty,
                          child: Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Column(
                          children: List.generate(
                            categoryModel.listProduct.length,
                                (index) {
                              final ProductCategoryModel model = categoryModel.listProduct[index];

                              double totalBuyCost = 0;
                              int totalBuyUnits = 0;
                              double totalProfit = 0;
                              int totalRevenue = 0;
                              int quantityProduct = 0;
                              int revenueProduct = 0;

                              for (TransactionModel t in model.transactionModelList) {
                                if (t.transactionType == 'Buying') {
                                  totalBuyCost += t.totalAmountOfMoney ?? 0;
                                  totalBuyUnits += t.numberOfUnits;
                                  quantityProduct += t.numberOfUnits;
                                } else if (t.transactionType == 'Selling') {
                                  final costPerUnit = totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
                                  totalRevenue += t.totalAmountOfMoney ?? 0;
                                  revenueProduct += t.totalAmountOfMoney ?? 0;
                                  quantityProduct -= t.numberOfUnits;
                                  totalProfit += ((t.pricePerUnit ?? 0) - costPerUnit) * t.numberOfUnits;
                                } else if (t.transactionType == 'Write-off') {
                                  final costPerUnit = totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
                                  quantityProduct -= t.numberOfUnits;
                                  totalProfit -= costPerUnit * t.numberOfUnits;
                                }
                              }

                              final double ros = totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0;

                              fO.value += quantityProduct;
                              sT.value += revenueProduct;
                              tT.value += totalProfit;
                              fF.value += ros;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyProductPage(
                                        productCategoryModel: model,
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  quantityProduct: quantityProduct,
                                  revenueProduct: revenueProduct,
                                  totalProfit: totalProfit,
                                  totalRevenue: totalRevenue,
                                  img: model.im,
                                  category: model,
                                  addTransaction: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTransactionPage(
                                          categoryModel: categoryModel,
                                          productCategoryModel: model,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )

                        ),
                        SizedBox(height: 80.h)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: AppButton(
            padding: EdgeInsets.symmetric(horizontal: 24),
            icon: 'assets/icons/ls.svg',
            text: "Create product",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProductPage(
                      categoryModel: categoryModel,
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
}

Future<bool?> showDeleteCategoryDialog(BuildContext context) async {
  return await showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          'Delete category?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'You will lose all information related to it',
            // style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            isDefaultAction: true,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorAsf.b0A84FF,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showEditDeleteDialog(
  BuildContext context, {
  required CategoryModel categoryModel,
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
                    builder: (context) => CreateCategoryPage(
                      isEdit: true,
                      categoryModel: categoryModel,
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
              AS.localCategory.delete(categoryModel.id);
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

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.addTransaction,
    required this.img,
    required this.category,
    required this.totalProfit,
    required this.totalRevenue,
    required this.quantityProduct,
    required this.revenueProduct,
  });

  final Function() addTransaction;
  final String img;
  final ProductCategoryModel category;

  final double totalProfit;
  final int totalRevenue;
  final int quantityProduct;
  final int revenueProduct;

  @override
  Widget build(BuildContext context) {
    final double ros =
        totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: img.isEmpty
                ? SvgPicture.asset(
                    'assets/icons/fds.svg',
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(img),
                    // color: Colors.white,
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 10.w),

          // Info block
          Expanded(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  category.naaame,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Visibility(
                  visible: quantityProduct!=0,
                  child: Column(
                    children: [
                      // Quantity
                      _infoRow(
                        "assets/icons/lllll.svg",
                        'Quantity: ',
                        '$quantityProduct',
                      ),

                      // Revenue
                      _infoRow(
                        "assets/icons/cve.svg",
                        'Revenue: ',
                        '\$$revenueProduct',
                      ),

                      // Profit
                      _infoRow(
                        "assets/icons/stic.svg",
                        'Profit: ',
                        '\$${totalProfit.toStringAsFixed(2)}',
                        valueColor: totalProfit < 0 ? Colors.red : Colors.green,
                      ),

                      // ROS
                      _infoRow(
                        "assets/icons/uare.svg",
                        'ROS: ',
                        '${ros.toStringAsFixed(2)}%',
                      ),
                    ],
                  ),
                ),



                SizedBox(height: 8.h),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: addTransaction,
                    child: const Text("Add transaction"),
                  ),
                ),
              ],
            ),
          )
        ],
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

class _Container extends StatelessWidget {
  const _Container({
    super.key,
    required this.categoryModel,
    required this.fO,
    required this.sT,
    required this.tT,
    required this.fF,
    required this.length,
  });

  final CategoryModel categoryModel;
  final int fO;
  final int sT;
  final double tT;
  final double fF;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorAsf.k252525, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                categoryModel.im,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  categoryModel.tit,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: categoryModel.des.isNotEmpty,
            child: Column(
              children: [
                SizedBox(height: 8),
                Text(
                  categoryModel.des,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 12.h),
          asd(
            icooo: 'assets/icons/aaaa.svg',
            ttttt: 'Total products',
            vvvvv: '$length',
          ),
          Visibility(
            visible: fO!=0,
            child: Column(
              children: [
                asd(
                  icooo: 'assets/icons/xczxczxc.svg',
                  ttttt: 'Cost',
                  vvvvv: '$fO',
                ),
                asd(
                  icooo: 'assets/icons/gfhfghfgh.svg',
                  ttttt: 'Revenue',
                  vvvvv: '$sT',
                ),
                asd(
                  icooo: 'assets/icons/xcv.svg',
                  ttttt: 'Profit',
                  vvvvv: '$tT',
                ),
                asd(
                  icooo: 'assets/icons/uare.svg',
                  ttttt: 'ROS',
                  vvvvv: '$fF',
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget asd({
    required String icooo,
    required String ttttt,
    required String vvvvv,
  }) {
    final TextStyle style = TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
    final TextStyle styleBold = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    icooo,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 4.w),
                  Text(ttttt, style: style),
                ],
              ),
              Text(vvvvv, style: styleBold),
            ],
          ),
        ),
        Visibility(
          visible: fO!=0,
          child: Visibility(
            visible: ttttt != 'ROS',
            child: Divider(
              height: 0,
              color: Color(0xff575f67),
            ),
          ),
        ),
      ],
    );
  }
}

class AppBarApp extends StatelessWidget implements PreferredSizeWidget {
  const AppBarApp({
    super.key,
    required this.title,
    this.actions,
    this.leadingTap,
    this.isSsss = false,
    this.centerTitle = false,
  });

  final String title;
  final bool isSsss;
  final bool centerTitle;
  final List<Widget>? actions;
  final Function()? leadingTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      leading: isSsss ? GestureDetector(
        onTap: leadingTap ??
            () async {
              Navigator.of(context).pop();
            },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset('assets/icons/arrow_left.svg'),
        ),
      ) : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
