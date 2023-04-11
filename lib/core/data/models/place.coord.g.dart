// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.coord.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceGeoCodesAdapter extends TypeAdapter<PlaceGeoCodes> {
  @override
  final int typeId = 1;

  @override
  PlaceGeoCodes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceGeoCodes(
      long: fields[1] as double,
      lat: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceGeoCodes obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceGeoCodesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
