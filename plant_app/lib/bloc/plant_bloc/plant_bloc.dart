import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/repository/plant_repository.dart';
import 'plant_event.dart';
import 'plant_state.dart';

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
      } else if (event is DeletePlantEvent) {
        emit(PlantLoadingState());
        try {
          await _repository.deletePlant(event.plant);
          emit(PlantDeletedState());
          getPlants();
        } catch (e) {
          emit(PlantErrorState("Bitki silinirken bir hata oluştu."));
        }
      }
    });
  }
}
