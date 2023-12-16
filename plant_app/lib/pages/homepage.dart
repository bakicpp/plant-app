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
import 'package:plant_app/state_screens/plant_added_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File _image = File('');

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

  Future<void> selectImage() async {
    final image = await _getImage();
    setState(() {
      _image = image;
    });
    if (_image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image selected')),
      );
    }
  }

  void addPlant() async {
    // ignore: use_build_context_synchronously
    context.read<PlantBloc>().add(
        AddPlantEvent(_nameController.text, _colorController.text, _image));
  }

  void changeTheme() {
    context.read<ThemeBloc>().add(ToggleThemeEvent());
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

  void _showBottomSheet(BuildContext context, double pageWidth) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: Container(
            width: pageWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pageWidth / 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text('Add a plant 🌿',
                      style: GoogleFonts.manrope(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  Text("Plant name",
                      style: GoogleFonts.manrope(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  textField(controller: _nameController, labelText: "Ex: Rose"),
                  SizedBox(height: 20.0),
                  Text("Plant color",
                      style: GoogleFonts.manrope(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  textField(controller: _colorController, labelText: "Ex: Red"),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      selectImage();
                    },
                    child: Container(
                      width: pageWidth,
                      height: pageWidth / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(198, 215, 198, 1),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: Colors.green),
                          Text(
                            "Select image from files",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.green,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: pageWidth,
                    height: pageWidth / 8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: const Color.fromRGBO(122, 210, 69, 1),
                      ),
                      onPressed: () async {
                        addPlant();
                        _nameController.clear();
                        _colorController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add Plant',
                        style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.of(context).size.height;
    double pageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, pageWidth);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text("Plant App"),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.login)),
          IconButton(
              onPressed: changeTheme, icon: const Icon(Icons.brightness_4))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PlantBloc>().add(GetPlantsEvent());
        },
        child: BlocBuilder<PlantBloc, PlantState>(builder: (context, state) {
          if (state is PlantAddedState) {
            return const PlantAddedScreen();
          }
          if (state is PlantLoadingState) {
            return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }

  Padding pageView(PlantListState state, double pageWidth, double pageheight) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is PlantLoadingState)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pageWidth / 22),
                child: headerContainer(pageWidth),
              ),
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
            Image.asset(
              "assets/images/plant.png",
              scale: 1,
            ),
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
      height: MediaQuery.of(context).size.height * state.plants.length / 5.3,
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

  TextField textField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            gapPadding: 3.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black12, width: 2.0),
            gapPadding: 3.0,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            gapPadding: 3.0,
          ),
          labelText: labelText),
    );
  }
}
