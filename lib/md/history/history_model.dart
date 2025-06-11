import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 3)
class HistoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String primeId;
  @HiveField(2)
  final String imgmsdf;
  @HiveField(3)
  final String titit;
  @HiveField(4)
  final String desasdfsdf;
  @HiveField(5)
  final DateTime dateTime;

  HistoryModel({
    required this.id,
    required this.primeId,
    required this.imgmsdf,
    required this.titit,
    required this.desasdfsdf,
    required this.dateTime,
  });
}
