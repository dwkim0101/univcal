// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      title: fields[0] as String,
      checkState: fields[1] as bool,
      reviewState: (fields[2] as Map).cast<DateTime, bool>(),
      repeatable: fields[3] as bool,
      index: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.checkState)
      ..writeByte(2)
      ..write(obj.reviewState)
      ..writeByte(3)
      ..write(obj.repeatable)
      ..writeByte(4)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatableEventAdapter extends TypeAdapter<RepeatableEvent> {
  @override
  final int typeId = 1;

  @override
  RepeatableEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepeatableEvent(
      title: fields[0] as String,
      startDay: fields[1] as DateTime,
      endDay: fields[2] as DateTime,
      repeatWeekdays: (fields[3] as List).cast<bool>(),
      index: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RepeatableEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.startDay)
      ..writeByte(2)
      ..write(obj.endDay)
      ..writeByte(3)
      ..write(obj.repeatWeekdays)
      ..writeByte(4)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatableEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NonRepeatableEventAdapter extends TypeAdapter<NonRepeatableEvent> {
  @override
  final int typeId = 2;

  @override
  NonRepeatableEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NonRepeatableEvent(
      title: fields[0] as String,
      date: fields[1] as DateTime,
      index: fields[4] as int,
      parentIndex: fields[5] as int?,
    )
      ..checkState = fields[2] as bool
      ..reviewState = (fields[3] as Map).cast<DateTime, bool>();
  }

  @override
  void write(BinaryWriter writer, NonRepeatableEvent obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.checkState)
      ..writeByte(3)
      ..write(obj.reviewState)
      ..writeByte(4)
      ..write(obj.index)
      ..writeByte(5)
      ..write(obj.parentIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonRepeatableEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
