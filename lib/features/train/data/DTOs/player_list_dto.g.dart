// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_list_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerListDTOAdapter extends TypeAdapter<PlayerListDTO> {
  @override
  final int typeId = 4;

  @override
  PlayerListDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerListDTO(
      list: (fields[1] as List).cast<PlayerDTO>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerListDTO obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerListDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
