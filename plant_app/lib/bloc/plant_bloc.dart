import 'package:bloc/bloc.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/repository/plant_repository.dart';
import 'dart:io';

class PlantState {}

class PlantInitialState extends PlantState {}

class PlantLoadingState extends PlantState {}

class PlantAddedState extends PlantState {}

class PlantListState extends PlantState {
  late final List<Plant> plants;

  PlantListState(this.plants);
}

class PlantErrorState extends PlantState {
  final String errorMessage;

  PlantErrorState(this.errorMessage);
}

class PlantCubit extends Cubit<PlantState> {
  final PlantRepository _repository;

  PlantCubit(this._repository) : super(PlantInitialState()) {
    init();
  }

  void init() async {
    getPlants();
  }

  void addPlant(String name, String color, File image) async {
    try {
      emit(PlantLoadingState());
      await _repository.addPlant(name, color, image);
      emit(PlantAddedState());
      getPlants();
    } catch (e) {
      emit(PlantErrorState("Bitki eklenirken bir hata oluştu."));
    }
  }

  void getPlants() async {
    try {
      // PlantRepository'de tanımlanan getPlants metodunu çağırarak bitkileri alın
      final plants = await _repository.getPlants();
      emit(PlantListState(plants));
    } catch (e) {
      emit(PlantErrorState("Bitkiler alınırken bir hata oluştu."));
    }
  }
}
