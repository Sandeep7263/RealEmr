// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Entry_DB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 14;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      complaints: (fields[0] as List).cast<String>(),
      tablets: (fields[1] as List).cast<String>(),
      diagnosis: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.complaints)
      ..writeByte(1)
      ..write(obj.tablets)
      ..writeByte(2)
      ..write(obj.diagnosis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
