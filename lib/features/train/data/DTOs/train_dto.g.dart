// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainDTOAdapter extends TypeAdapter<TrainDTO> {
  @override
  final int typeId = 1;

  @override
  TrainDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainDTO(
      uuid: fields[1] as String,
      playersKey: fields[2] as String,
      trainName: fields[3] as String,
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime,
      trainDescription: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrainDTO obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.playersKey)
      ..writeByte(3)
      ..write(obj.trainName)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.trainDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
