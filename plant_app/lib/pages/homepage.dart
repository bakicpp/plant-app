import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant App"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutEvent());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => PasswordVisibilityBloc(),
                            child: const LoginPage(),
                          )),
                );
              },
              icon: const Icon(Icons.login)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.app_registration)),
        ],
      ),
      body: BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
        if (state is PlantAddedState) {
          return Center(child: Text("Plant added"));
        } else if (state is PlantErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: ${state.errorMessage}'),
            ),
          );
        } else if (state is PlantListState) {
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
                      onPressed: () async {
                        final image = await _getImage();
                        // ignore: use_build_context_synchronously
                        context.read<PlantBloc>().add(AddPlantEvent(
                            _nameController.text,
                            _colorController.text,
                            image));
                      },
                      child: Text("add plant image")),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: state.plants.length,
                      itemBuilder: (context, index) {
                        final plant = state.plants[index];
                        return ListTile(
                          title: Text(plant.name),
                          subtitle: Text(plant.color),
                          leading: CircleAvatar(
                              child: Image.network(plant.imageURL)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (state is PlantErrorState) {
          return const Center(child: Text("error"));
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Padding textField(
      {required TextEditingController controller, required String labelText}) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
