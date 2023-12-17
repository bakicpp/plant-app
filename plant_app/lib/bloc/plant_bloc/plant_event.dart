import 'dart:io';
import 'package:plant_app/models/plant.dart';

abstract class PlantEvent {}

class AddPlantEvent extends PlantEvent {
  final String name;
  final String color;
  final File image;

  AddPlantEvent(this.name, this.color, this.image);
}

class GetPlantsEvent extends PlantEvent {}

class DeletePlantEvent extends PlantEvent {
  final Plant plant;

  DeletePlantEvent(this.plant);
}
