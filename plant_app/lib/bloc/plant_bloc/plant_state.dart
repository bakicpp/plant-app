import 'package:plant_app/models/plant.dart';

abstract class PlantState {}

class PlantInitialState extends PlantState {}

class PlantLoadingState extends PlantState {}

class PlantAddedState extends PlantState {}

class PlantListState extends PlantState {
  final List<Plant> plants;

  PlantListState(this.plants);
}

class PlantDeletedState extends PlantState {}

class PlantErrorState extends PlantState {
  final String errorMessage;

  PlantErrorState(this.errorMessage);
}
