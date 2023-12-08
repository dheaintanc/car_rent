// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carRentsDatabase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarRentsDataAdapter extends TypeAdapter<CarRentsData> {
  @override
  final int typeId = 0;

  @override
  CarRentsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarRentsData(
      id: fields[0] as String,
      make: fields[1] as String,
      price: fields[2] as String,
      image: fields[3] as String,
      description: fields[4] as String,
      rating: fields[5] as String,
      location: fields[6] as String,
      type: fields[7] as String,
      year: fields[8] as String,
      model: fields[9] as String,
      transmission: fields[10] as String,
      fuel: fields[11] as String,
      mileage: fields[12] as String,
      engine: fields[13] as String,
      color: fields[14] as String,
      availability: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CarRentsData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.make)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.model)
      ..writeByte(10)
      ..write(obj.transmission)
      ..writeByte(11)
      ..write(obj.fuel)
      ..writeByte(12)
      ..write(obj.mileage)
      ..writeByte(13)
      ..write(obj.engine)
      ..writeByte(14)
      ..write(obj.color)
      ..writeByte(15)
      ..write(obj.availability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarRentsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
