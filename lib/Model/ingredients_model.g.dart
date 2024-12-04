// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredients_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 1;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as String?,
      name: fields[1] as String,
      isCheck: fields[2] as bool,
      isDuplicate: fields[3] as bool,
      recipeIds: (fields[4] as List?)?.cast<String>(),
      recipeNames: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isCheck)
      ..writeByte(3)
      ..write(obj.isDuplicate)
      ..writeByte(4)
      ..write(obj.recipeIds)
      ..writeByte(5)
      ..write(obj.recipeNames);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
