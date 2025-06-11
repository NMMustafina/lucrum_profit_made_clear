import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profit_made_clear_254_t/asf/color_asf.dart';
import 'package:profit_made_clear_254_t/asf/new_buti.dart';
import 'package:profit_made_clear_254_t/stranice/one/my_category_page.dart';

import '../../md/category/category_model.dart';
import '../../md/history/history_model.dart';
import '../../md/product/product_category_model.dart';
import '../../md/transaction/transaction_model.dart';
import 'create_category_page.dart';
import 'history_page.dart';

class PartOPage extends StatefulWidget {
  const PartOPage({super.key});

  @override
  State<PartOPage> createState() => _PartOPageState();
}

abstract class AS {
  static final Box<CategoryModel> localCategory =
      GetIt.I.get<Box<CategoryModel>>();
  static final Box<HistoryModel> historyModel =
      GetIt.I.get<Box<HistoryModel>>();
  static final Box<ProductCategoryModel> localCategoryProduct =
      GetIt.I.get<Box<ProductCategoryModel>>();
}

class _PartOPageState extends State<PartOPage> {
  bool isReversed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: AS.localCategory.listenable(),
        builder: (context, value1, child) {
          List<CategoryModel> value = value1.values.toList();
          if (isReversed) {
            value = value.reversed.toList();
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text(
                'Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                GestureDetector(
                    onTap: () {
                      if (AS.historyModel.values.toList().isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryPage(),
                            ));
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/vvvv.svg',
                      color: AS.historyModel.values.toList().isNotEmpty
                          ? Colors.white
                          : null,
                    )),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isReversed = !isReversed;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icons/sdfv.svg',
                    color: value.length > 1 ? Colors.white : null,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
            body: AS.localCategory.values.isEmpty
                ? acho()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: value.toList().length,
                    itemBuilder: (_, index) {
                      final CategoryModel item = value.toList()[index];
                      return buildCategoryItem(
                        item,
                        click: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCategoryPage(
                                categoryModel1: item,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: NewMotiBut(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateCategoryPage(),
                      ));
                  // showPremiumDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Create category",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.add, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget acho() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/bbsd.svg'),
          SizedBox(height: 8.h),
          Text(
            'Create your\nfirst category',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: ColorAsf.gray),
          )
        ],
      ),
    );
  }

  Widget buildCategoryItem(CategoryModel item, {required Function() click}) {
    double tT = 0.0;
    double fF = 0.0;

    item.listProduct.forEach((model) {
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
          final costPerUnit =
              totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
          totalRevenue += t.totalAmountOfMoney ?? 0;
          quantityProduct -= t.numberOfUnits;
          revenueProduct += t.totalAmountOfMoney ?? 0;
          totalProfit +=
              ((t.pricePerUnit ?? 0) - costPerUnit) * t.numberOfUnits;
        } else if (t.transactionType == 'Write-off') {
          final costPerUnit =
              totalBuyUnits > 0 ? totalBuyCost / totalBuyUnits : 0;
          totalProfit -= costPerUnit * t.numberOfUnits;
          quantityProduct -= t.numberOfUnits;
        }
      }
      final double rosA =
          totalRevenue > 0 ? (totalProfit / totalRevenue) * 100 : 0;
      tT += totalProfit;
      fF += rosA;
    });
    final Color profitColor =
        // item.profit > 0
        //     ? ColorAsf.green
        //     : item.profit < 0
        //         ? ColorAsf.red
        //         :
        Colors.white;

    final String profitText =
        // item.profit > 0
        //     ? '\$${item.profit}'
        //     : item.profit < 0
        //         ? '-\$${-item.profit}'
        //         :
        '\$$tT';

    final String rosText =
        // item.ros > 0
        //     ? '${item.ros}%'
        //     : item.ros < 0
        //         ? '${item.ros}%'
        //         :
        '$fF%';

    return GestureDetector(
      onTap: click,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              item.im,
              width: 32,
              height: 32,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  Text('${item.listProduct.length} items',
                      style: TextStyle(color: ColorAsf.grayqw)),
                ],
              ),
            ),
            Visibility(
              visible: profitText == "0",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text('Profit: ', style: TextStyle(color: Colors.white)),
                      Text(
                        profitText,
                        style: TextStyle(
                          color: profitColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('ROS: $rosText',
                          style: TextStyle(color: Colors.white)),
                      // Text(rosText, style: TextStyle(color: profitColor)),
                    ],
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

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.access_time, // можно заменить на кастомную иконку
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.sort, // можно заменить на более подходящую иконку
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
