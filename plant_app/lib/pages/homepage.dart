import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
import 'package:plant_app/bloc/theme_bloc.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/pages/login_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }

  @override
  void initState() {
    context.read<PlantBloc>().add(GetPlantsEvent());
    super.initState();
  }

  void signOut() {
    context.read<AuthBloc>().add(AuthSignOutEvent());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => PasswordVisibilityBloc(),
                child: const LoginPage(),
              )),
    );
  }

  void addPlant() async {
    final image = await _getImage();
    // ignore: use_build_context_synchronously
    context
        .read<PlantBloc>()
        .add(AddPlantEvent(_nameController.text, _colorController.text, image));
  }

  void changeTheme() {
    context.read<ThemeBloc>().add(ToggleThemeEvent());
  }

  void showErrorMessage(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> clearPlantsBox() async {
    try {
      final box = await Hive.openBox<Plant>('plants');
      await box.clear(); // Bu satır kutu içindeki tüm öğeleri siler
      await box.close();
    } catch (e) {
      print("Hata: $e");
      throw Exception("Plants kutusu temizlenirken bir hata oluştu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant App"),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.login)),
          IconButton(
              onPressed: changeTheme, icon: const Icon(Icons.brightness_4))
        ],
      ),
      body: BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
        if (state is PlantAddedState) {
          return const Center(child: Text("Plant added"));
        } else if (state is PlantErrorState) {
          return Center(child: Text(state.errorMessage));
        } else if (state is PlantListState) {
          return pageView(state);
        } else if (state is PlantDeletedState) {
          return const Center(child: Text("Plant deleted"));
        } else if (state is PlantErrorState) {
          return Center(child: Text(state.errorMessage));
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Padding pageView(PlantListState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is PlantLoadingState)
              const Center(child: CircularProgressIndicator())
            else
              const Center(child: Text("add plant")),
            textField(controller: _nameController, labelText: "name"),
            textField(controller: _colorController, labelText: "color"),
            ElevatedButton(
                onPressed: addPlant, child: const Text("add plant image")),
            ElevatedButton(
                onPressed: () async {
                  await clearPlantsBox();
                },
                child: Text("clear hive")),
            plantListView(state)
          ],
        ),
      ),
    );
  }

  SizedBox plantListView(PlantListState state) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: state.plants.length,
        itemBuilder: (context, index) {
          final plant = state.plants[index];
          return ListTile(
            title: Text(plant.name),
            subtitle: Text(plant.color),
            trailing: IconButton(
              onPressed: () {
                context.read<PlantBloc>().add(DeletePlantEvent(plant));
              },
              icon: const Icon(Icons.delete),
            ),
            leading: CircleAvatar(child: Image.network(plant.imageURL)),
          );
        },
      ),
    );
  }

  Padding textField(
      {required TextEditingController controller, required String labelText}) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
