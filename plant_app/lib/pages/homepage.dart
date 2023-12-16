import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double pageHeight = MediaQuery.of(context).size.height;
    double pageWidth = MediaQuery.of(context).size.width;

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
          return pageView(state, pageWidth, pageHeight);
        } else if (state is PlantDeletedState) {
          return const Center(child: Text("Plant deleted"));
        } else if (state is PlantErrorState) {
          return Center(child: Text(state.errorMessage));
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Padding pageView(PlantListState state, double pageWidth, double pageheight) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: pageheight / 15),
              if (state is PlantLoadingState)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pageWidth / 22),
                  child: headerContainer(pageWidth),
                ),
              textField(controller: _nameController, labelText: "name"),
              textField(controller: _colorController, labelText: "color"),
              ElevatedButton(
                  onPressed: addPlant, child: const Text("add plant image")),
              ElevatedButton(
                  onPressed: () async {
                    await clearPlantsBox();
                  },
                  child: Text("clear hive")),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: plantListView(state, pageWidth),
              )
            ],
          ),
          Positioned(
              bottom: pageheight * 1.383,
              child: Image.asset("assets/images/plant.png", scale: 2.3)),
        ]),
      ),
    );
  }

  Container headerContainer(double pageWidth) {
    return Container(
        width: pageWidth,
        height: pageWidth / 2.4,
        decoration: BoxDecoration(
          color: Color.fromRGBO(198, 215, 198, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: pageWidth / 3),
            Text(
              "Make plants\ngreat again!",
              softWrap: true,
              style: GoogleFonts.manrope(
                  fontSize: 32, fontWeight: FontWeight.w800),
            ),
          ],
        ));
  }

  SizedBox plantListView(PlantListState state, double pageWidth) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * state.plants.length / 4,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7),
        itemCount: state.plants.length,
        itemBuilder: (context, index) {
          final plant = state.plants[index];
          return plantContent(plant, pageWidth);

          /*ListTile(
            title: Text(plant.name),
            subtitle: Text(plant.color),
            trailing: IconButton(
              onPressed: () {
                context.read<PlantBloc>().add(DeletePlantEvent(plant));
              },
              icon: const Icon(Icons.delete),
            ),
            leading: CircleAvatar(child: Image.network(plant.imageURL)),
          );*/
        },
      ),
    );
  }

  Expanded plantContent(Plant plant, double pageWidth) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(children: [
                  Container(
                    height: 130,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(plant.imageURL, scale: 2),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  deleteButtonPopUp(pageWidth, plant),
                ]),
              ),
              const SizedBox(height: 10),
              Text(
                plant.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plant.color,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned deleteButtonPopUp(double pageWidth, Plant plant) {
    return Positioned(
      left: pageWidth / 3,
      top: pageWidth / 40,
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () {
              context.read<PlantBloc>().add(DeletePlantEvent(plant));
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                Text("Delete", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        child: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
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
