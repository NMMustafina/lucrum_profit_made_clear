import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../md/category/category_model.dart';
import '../md/product/product_category_model.dart';
import '../md/transaction/transaction_model.dart';

class AnalyticsProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  bool isYearly = false;
  bool showProducts = false;
  List<ProductCategoryModel> allCategories = [];

  bool _watcherInitialized = false;

  void initWatcher() {
    if (_watcherInitialized) return;
    _watcherInitialized = true;

    final box = GetIt.I<Box<CategoryModel>>();
    _updateFromBox(box);

    box.watch().listen((_) {
      _updateFromBox(box);
    });
  }

  void _updateFromBox(Box<CategoryModel> box) {
    final list = box.values.expand((c) => c.listProduct).toList();
    allCategories = list;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void toggleIsYearly(bool value) {
    isYearly = value;
    notifyListeners();
  }

  void toggleShowProducts() {
    showProducts = !showProducts;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  List<TransactionModel> get allTransactions =>
      allCategories.expand((c) => c.transactionModelList).toList();

  List<TransactionModel> get filteredTransactions {
    return allTransactions.where((tx) {
      final dt = tx.dateTime;
      return isYearly
          ? dt.year == selectedDate.year
          : dt.year == selectedDate.year && dt.month == selectedDate.month;
    }).toList();
  }

  int get totalTransactions => filteredTransactions.length;
  int get totalBought =>
      filteredTransactions.where((t) => t.transactionType == 'Buying').length;
  int get totalSold =>
      filteredTransactions.where((t) => t.transactionType == 'Selling').length;
  int get totalWrittenOff => filteredTransactions
      .where((t) => t.transactionType == 'Write-off')
      .length;

  double get totalProfit {
    return allCategories
        .map((cat) => _calcProfit(cat.transactionModelList.where((tx) {
              final dt = tx.dateTime;
              return isYearly
                  ? dt.year == selectedDate.year
                  : dt.year == selectedDate.year &&
                      dt.month == selectedDate.month;
            })))
        .fold(0.0, (a, b) => a + b);
  }

  double get totalLoss {
    return allCategories
        .map((cat) => _calcLoss(cat.transactionModelList.where((tx) {
              final dt = tx.dateTime;
              return isYearly
                  ? dt.year == selectedDate.year
                  : dt.year == selectedDate.year &&
                      dt.month == selectedDate.month;
            })))
        .fold(0.0, (a, b) => a + b);
  }

  double get totalRevenue {
    double revenue = 0;
    for (var t in filteredTransactions) {
      final amount = t.totalAmountOfMoney?.toDouble() ?? 0;
      if (t.transactionType == 'Selling') {
        revenue += amount;
      }
    }
    return revenue;
  }

  Map<String, double> get groupedData {
    final Map<String, double> result = {};
    final categoryBox = GetIt.I<Box<CategoryModel>>();

    if (!showProducts) {
      for (var cat in categoryBox.values) {
        final entries =
            cat.listProduct.expand((p) => p.transactionModelList).where((tx) {
          final dt = tx.dateTime;
          return isYearly
              ? dt.year == selectedDate.year
              : dt.year == selectedDate.year && dt.month == selectedDate.month;
        }).toList();

        final profit = _calcProfit(entries);
        final loss = _calcLoss(entries);
        if (profit == 0.0 && loss == 0.0) continue;

        final value = profit != 0.0 ? profit : -loss;
        result[cat.tit] = value;
      }
    } else {
      for (var cat in categoryBox.values) {
        for (var product in cat.listProduct) {
          final entries = product.transactionModelList.where((tx) {
            final dt = tx.dateTime;
            return isYearly
                ? dt.year == selectedDate.year
                : dt.year == selectedDate.year &&
                    dt.month == selectedDate.month;
          }).toList();

          final profit = _calcProfit(entries);
          final loss = _calcLoss(entries);
          if (profit == 0.0 && loss == 0.0) continue;

          final value = profit != 0.0 ? profit : -loss;
          result[product.naaame] = value;
        }
      }
    }

    return result;
  }

  double _calcProfit(Iterable<TransactionModel> txs) {
    final buys = txs.where((t) => t.transactionType == 'Buying').toList();
    final sells = txs.where((t) => t.transactionType == 'Selling').toList();
    final writeOffs =
        txs.where((t) => t.transactionType == 'Write-off').toList();

    List<_Lot> buyLots = buys
        .map((b) => _Lot(
              units: b.numberOfUnits,
              costPerUnit:
                  (b.totalAmountOfMoney ?? 0).toDouble() / b.numberOfUnits,
            ))
        .toList();

    double totalProfit = 0;

    for (final sell in sells) {
      int toSell = sell.numberOfUnits;
      double revenue = (sell.totalAmountOfMoney ?? 0).toDouble();

      double cost = 0;
      while (toSell > 0 && buyLots.isNotEmpty) {
        final lot = buyLots.first;
        final take = toSell < lot.units ? toSell : lot.units;
        cost += take * lot.costPerUnit;
        lot.units -= take;
        toSell -= take;
        if (lot.units == 0) buyLots.removeAt(0);
      }

      totalProfit += revenue - cost;
    }

    for (final w in writeOffs) {
      int toWrite = w.numberOfUnits;
      double writeCost = 0;

      while (toWrite > 0 && buyLots.isNotEmpty) {
        final lot = buyLots.first;
        final take = toWrite < lot.units ? toWrite : lot.units;
        writeCost += take * lot.costPerUnit;
        lot.units -= take;
        toWrite -= take;
        if (lot.units == 0) buyLots.removeAt(0);
      }

      totalProfit -= writeCost;
    }

    return totalProfit;
  }

  double _calcLoss(Iterable<TransactionModel> txs) {
    final writeOffs =
        txs.where((t) => t.transactionType == 'Write-off').toList();
    final buys = txs.where((t) => t.transactionType == 'Buying').toList();

    List<_Lot> buyLots = buys
        .map((b) => _Lot(
              units: b.numberOfUnits,
              costPerUnit:
                  (b.totalAmountOfMoney ?? 0).toDouble() / b.numberOfUnits,
            ))
        .toList();

    double loss = 0;

    for (final w in writeOffs) {
      int toWrite = w.numberOfUnits;
      while (toWrite > 0 && buyLots.isNotEmpty) {
        final lot = buyLots.first;
        final take = toWrite < lot.units ? toWrite : lot.units;
        loss += take * lot.costPerUnit;
        lot.units -= take;
        toWrite -= take;
        if (lot.units == 0) buyLots.removeAt(0);
      }
    }

    return loss;
  }

  bool get hasEnoughDataForPicker {
    final dates = allTransactions
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month))
        .toSet();
    return dates.length >= 2;
  }

  List<DateTime> get availableMonths {
    final dates = allTransactions
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month))
        .toSet()
        .toList();
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  List<int> get availableYears {
    final years = allTransactions.map((e) => e.dateTime.year).toSet().toList();
    years.sort((a, b) => b.compareTo(a));
    return years;
  }
}

class _Lot {
  int units;
  double costPerUnit;

  _Lot({required this.units, required this.costPerUnit});
}
