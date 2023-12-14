import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
import 'package:plant_app/firebase_services/database_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> _getImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlantCubit, PlantState>(builder: (context, state) {
        if (state is PlantAddedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bitki başarıyla eklendi!'),
            ),
          );
        } else if (state is PlantHataState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: ${state.errorMessage}'),
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Text("add plant")),
            textField(controller: _nameController, labelText: "name"),
            textField(controller: _colorController, labelText: "color"),
            button(),
            ElevatedButton(
                onPressed: () async {
                  final image = await _getImage();
                  context.read<PlantCubit>().addPlant(
                        _nameController.text,
                        _colorController.text,
                        image,
                      );
                },
                child: Text("add plant image")),
          ],
        );
      }),
    );
  }

  ElevatedButton button() => ElevatedButton(
      onPressed: () {
        FirebaseCollection("users").addDocument({"name": "John Doe"});
        print("added data");
      },
      child: const Text("add data"));

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
