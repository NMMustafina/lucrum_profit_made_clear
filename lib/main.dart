import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profit_made_clear_254_t/asf/oksad_page.dart';
import 'package:profit_made_clear_254_t/providers/analytics_provider.dart';
import 'package:provider/provider.dart';

import 'md/category/category_model.dart';
import 'md/history/history_model.dart';
import 'md/product/product_category_model.dart';
import 'md/transaction/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ProductCategoryModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(HistoryModelAdapter());
  final Box<CategoryModel> proodd = await Hive.openBox<CategoryModel>('proodd');
  final Box<HistoryModel> RRRR =
      await Hive.openBox<HistoryModel>('proDADSGADGFADFGodd');
  final Box<ProductCategoryModel> proodd12e =
      await Hive.openBox<ProductCategoryModel>('proodd12e');
  final Box<TransactionModel> tranModel =
      await Hive.openBox<TransactionModel>('TransactionModel');
  GetIt.I.registerSingleton<Box<CategoryModel>>(proodd);
  GetIt.I.registerSingleton<Box<ProductCategoryModel>>(proodd12e);
  GetIt.I.registerSingleton<Box<TransactionModel>>(tranModel);
  GetIt.I.registerSingleton<Box<HistoryModel>>(RRRR);

  runApp(const MyApp());
}

extension StringToInt on String {
  int toInt() {
    try {
      return int.parse(this);
    } catch (_) {
      return 0;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsProvider(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WanderTales',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            scaffoldBackgroundColor: Colors.black,
          ),
          home: MainBotomBar(),
        ),
      ),
    );
  }
}
