// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 2;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      primeId: fields[1] as String,
      transactionType: fields[2] as String,
      numberOfUnits: fields[3] as int,
      totalAmountOfMoney: fields[4] as int?,
      pricePerUnit: fields[5] as int?,
      dateTime: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.primeId)
      ..writeByte(2)
      ..write(obj.transactionType)
      ..writeByte(3)
      ..write(obj.numberOfUnits)
      ..writeByte(4)
      ..write(obj.totalAmountOfMoney)
      ..writeByte(5)
      ..write(obj.pricePerUnit)
      ..writeByte(6)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
