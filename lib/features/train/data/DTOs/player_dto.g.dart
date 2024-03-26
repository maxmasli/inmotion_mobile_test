// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDTOAdapter extends TypeAdapter<PlayerDTO> {
  @override
  final int typeId = 2;

  @override
  PlayerDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerDTO(
      name: fields[1] as String,
      number: fields[2] as int,
      measures: (fields[3] as List).cast<MeasureDTO>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerDTO obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.measures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
