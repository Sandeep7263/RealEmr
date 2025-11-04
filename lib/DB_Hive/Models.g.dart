// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmrModelsAdapter extends TypeAdapter<EmrModels> {
  @override
  final int typeId = 0;

  @override
  EmrModels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmrModels(
      name: fields[0] as String,
      dob: fields[1] as String,
      gender: fields[2] as String,
      email: fields[3] as String,
      mobileno: fields[4] as String,
      age: fields[5] as String,
      country: fields[6] as String,
      state: fields[7] as String,
      city: fields[8] as String,
      religion: fields[9] as String,
      occupation: fields[10] as String,
      address: fields[11] as String,
      mothertongue: fields[12] as String,
      creationDateTime: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EmrModels obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.mobileno)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.religion)
      ..writeByte(10)
      ..write(obj.occupation)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.mothertongue)
      ..writeByte(13)
      ..write(obj.creationDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmrModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
