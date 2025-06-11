// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductCategoryModelAdapter extends TypeAdapter<ProductCategoryModel> {
  @override
  final int typeId = 1;

  @override
  ProductCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategoryModel(
      id: fields[0] as String,
      primeId: fields[1] as String,
      naaame: fields[2] as String,
      dessssss: fields[3] as String,
      im: fields[4] as String,
      transactionModelList: (fields[5] as List).cast<TransactionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.primeId)
      ..writeByte(2)
      ..write(obj.naaame)
      ..writeByte(3)
      ..write(obj.dessssss)
      ..writeByte(4)
      ..write(obj.im)
      ..writeByte(5)
      ..write(obj.transactionModelList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
