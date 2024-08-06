// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SplitDTOAdapter extends TypeAdapter<SplitDTO> {
  @override
  final int typeId = 5;

  @override
  SplitDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SplitDTO(
      uuid: fields[1] as String,
      startFragment: fields[2] as Duration?,
      endFragment: fields[3] as Duration?,
      name: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SplitDTO obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.startFragment)
      ..writeByte(3)
      ..write(obj.endFragment)
      ..writeByte(4)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplitDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
