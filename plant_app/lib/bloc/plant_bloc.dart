import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/repository/plant_repository.dart';
import 'dart:io';

abstract class PlantState {}

class PlantInitialState extends PlantState {}

class PlantLoadingState extends PlantState {}

class PlantAddedState extends PlantState {}

class PlantListState extends PlantState {
  final List<Plant> plants;

  PlantListState(this.plants);
}

class PlantErrorState extends PlantState {
  final String errorMessage;

  PlantErrorState(this.errorMessage);

  void showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $errorMessage')),
    );
  }
}

abstract class PlantEvent {}

class AddPlantEvent extends PlantEvent {
  final String name;
  final String color;
  final File image;

  AddPlantEvent(this.name, this.color, this.image);
}

class GetPlantsEvent extends PlantEvent {}

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  final PlantRepository _repository;

  void getPlants() async {
    try {
      final plants = await _repository.getPlants();
      // ignore: invalid_use_of_visible_for_testing_member
      emit(PlantListState(plants));
    } catch (e) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(PlantErrorState("Bitkiler alınırken bir hata oluştu."));
    }
  }

  PlantBloc(this._repository) : super(PlantListState([])) {
    on<PlantEvent>((event, emit) async {
      getPlants();
      if (event is AddPlantEvent) {
        emit(PlantLoadingState());
        try {
          await _repository.addPlant(event.name, event.color, event.image);
          emit(PlantAddedState());
          getPlants();
        } catch (e) {
          emit(PlantErrorState("Bitki eklenirken bir hata oluştu."));
        }
      } else if (event is GetPlantsEvent) {
        getPlants();
      }
    });

    /*on<AddPlantEvent>((event, emit) async {
      emit(PlantLoadingState());
      try {
        await _repository.addPlant(event.name, event.color, event.image);
        emit(PlantAddedState());
        add(GetPlantsEvent()); // Bitki eklendikten sonra listeyi tekrar al
      } catch (e) {
        emit(PlantErrorState("Bitki eklenirken bir hata oluştu."));
      }
    });

    on<GetPlantsEvent>((event, emit) async {
      try {
        final plants = await _repository.getPlants();
        emit(PlantListState(plants));
      } catch (e) {
        emit(PlantErrorState("Bitkiler alınırken bir hata oluştu."));
      }
    });*/
  }
}
