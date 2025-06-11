import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String primeId;
  @HiveField(2)
  final String transactionType;
  @HiveField(3)
  final int numberOfUnits;
  @HiveField(4)
  final int? totalAmountOfMoney;
  @HiveField(5)
  final int? pricePerUnit;
  @HiveField(6)
  final DateTime dateTime;

  TransactionModel({
    required this.id,
    required this.primeId,
    required this.transactionType,
    required this.numberOfUnits,
    required this.totalAmountOfMoney,
    required this.pricePerUnit,
    required this.dateTime,
  });
}
