import 'package:bloc/bloc.dart';
import 'package:plant_app/repository/plant_repository.dart';
import 'dart:io';

class PlantState {}

class PlantInitialState extends PlantState {}

class PlantLoadingState extends PlantState {}

class PlantAddedState extends PlantState {}

class PlantHataState extends PlantState {
  final String errorMessage;

  PlantHataState(this.errorMessage);
}

class PlantCubit extends Cubit<PlantState> {
  final PlantRepository _repository;

  PlantCubit(this._repository) : super(PlantInitialState());

  void addPlant(String name, String color, File image) async {
    try {
      emit(PlantLoadingState());
      await _repository.addPlant(name, color, image);
      emit(PlantAddedState());
    } catch (e) {
      emit(PlantHataState("Bitki eklenirken bir hata oluştu."));
    }
  }
}
