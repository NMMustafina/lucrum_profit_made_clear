import 'package:hive/hive.dart';

import '../product/product_category_model.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel  extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String tit;
  @HiveField(2)
  final String des;
  @HiveField(3)
  final String im;
  @HiveField(4)
  final List<ProductCategoryModel> listProduct;

  CategoryModel({
    required this.id,
    required this.tit,
    required this.des,
    required this.im,
    required this.listProduct,
  });
}
