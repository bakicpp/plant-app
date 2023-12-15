// lib/src/models/plant.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Plant extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String color;

  @HiveField(2)
  final String imageURL;

  Plant({required this.name, required this.color, required this.imageURL});
}

class PlantAdapter extends TypeAdapter<Plant> {
  @override
  final int typeId = 1;

  @override
  Plant read(BinaryReader reader) {
    return Plant(
      name: reader.readString(),
      color: reader.readString(),
      imageURL: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Plant obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.color);
    writer.writeString(obj.imageURL);
  }
}
