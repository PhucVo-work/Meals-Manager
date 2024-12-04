import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'ingredients_model.g.dart';

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isCheck;

  @HiveField(3)
  bool isDuplicate;

  @HiveField(4)
  List<String> recipeIds; // IDs of recipes this ingredient belongs to

  @HiveField(5)
  List<String> recipeNames; // Names of recipes this ingredient belongs to

  Ingredient({
    String? id,
    required this.name,
    this.isCheck = false,
    this.isDuplicate = false,
    List<String>? recipeIds,
    List<String>? recipeNames,
  })  : id = id ?? Uuid().v4(),
        recipeIds = recipeIds ?? [],
        recipeNames = recipeNames ?? [];
}
