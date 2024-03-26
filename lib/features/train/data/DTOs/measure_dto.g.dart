// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasureDTOAdapter extends TypeAdapter<MeasureDTO> {
  @override
  final int typeId = 3;

  @override
  MeasureDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasureDTO(
      time: fields[1] as DateTime?,
      hr: fields[2] as int?,
      latitude: fields[3] as double?,
      longitude: fields[4] as double?,
      speed: fields[5] as double?,
      distance: fields[6] as double?,
      steps: fields[7] as int?,
      activity: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MeasureDTO obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.hr)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.speed)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.steps)
      ..writeByte(8)
      ..write(obj.activity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
