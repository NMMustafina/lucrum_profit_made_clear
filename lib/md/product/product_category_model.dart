import 'package:hive/hive.dart';

import '../transaction/transaction_model.dart';

part 'product_category_model.g.dart';

@HiveType(typeId: 1)
class ProductCategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String primeId;
  @HiveField(2)
  final String naaame;
  @HiveField(3)
  final String dessssss;
  @HiveField(4)
  final String im;
  @HiveField(5)
  final List<TransactionModel> transactionModelList;

  ProductCategoryModel({
    required this.id,
    required this.primeId,
    required this.naaame,
    required this.dessssss,
    required this.im,
    required this.transactionModelList,
  });
}
