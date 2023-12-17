import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/language_bloc/language_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';
import 'package:plant_app/bloc/plant_bloc.dart';
import 'package:plant_app/bloc/theme_bloc.dart';
import 'package:plant_app/language/model/language_model.dart';
import 'package:plant_app/models/plant.dart';
import 'package:plant_app/pages/login_page.dart';
import 'package:plant_app/state_screens/plant_added_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_app/widgets/add_plant.dart';
import 'package:plant_app/widgets/plant_detail.dart';

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
        PageTransition(
            child: BlocProvider(
              create: (context) => PasswordVisibilityBloc(),
              child: const LoginPage(),
            ),
            type: PageTransitionType.leftToRightWithFade));
  }

  Future<void> selectImage() async {
    final image = await _getImage();
    setState(() {
      _image = image;
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected')),
    );
  }

  void addPlant() async {
    // ignore: use_build_context_synchronously
    if (_nameController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _image.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    } else {
      context.read<PlantBloc>().add(
          AddPlantEvent(_nameController.text, _colorController.text, _image));
    }
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
        return AddPlantBottomSheet(
            pageWidth: pageWidth,
            addPlant: addPlant,
            textField: textField,
            nameController: _nameController,
            colorController: _colorController,
            selectImage: selectImage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool> isSelected = {
      Language.turkish.text: false,
      Language.english.text: false,
    };

    void toggleLanguage(String lang) {
      if (isSelected[lang] == true) return;

      setState(() {
        isSelected.forEach((key, value) {
          isSelected[key] = key == lang;
        });
      });

      BlocProvider.of<LanguageBloc>(context).add(
        ChangeLanguage(
          selectedLanguage:
              lang == 'Turkish' ? Language.turkish : Language.english,
        ),
      );
    }

    double pageHeight = MediaQuery.of(context).size.height;
    double pageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: drawer(toggleLanguage),
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
        title: Text("Plant App"),
      ),
      body: RefreshIndicator(
        color: Colors.green,
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

  Drawer drawer(void toggleLanguage(String lang)) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Plant App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.brightness_2),
              title: Text(AppLocalizations.of(context)!.change_theme),
              onTap: changeTheme),
          ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Turkish'),
              onTap: () {
                toggleLanguage("Turkish");
              }),
          ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () {
                toggleLanguage("English");
              }),
          ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.sign_out),
              onTap: signOut),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [trButton(toggleLanguage), enButton(toggleLanguage)],
          ),
        ],
      ),
    );
  }

  Row enButton(void toggleLanguage(String lang)) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "assets/images/flag_en.jpg",
          ),
        ),
        GestureDetector(
          onTap: () {
            toggleLanguage("English");
          },
          child: Container(
            width: 70,
            height: 30,
            child: Center(
                child: Text("English", style: TextStyle(color: Colors.grey))),
          ),
        ),
      ],
    );
  }

  Row trButton(void toggleLanguage(String lang)) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "assets/images/flag_tr.png",
          ),
        ),
        GestureDetector(
          onTap: () {
            toggleLanguage("Turkish");
          },
          child: Container(
            width: 70,
            height: 30,
            child: Center(
                child: Text("Türkçe", style: TextStyle(color: Colors.grey))),
          ),
        ),
      ],
    );
  }

  Padding pageView(PlantListState state, double pageWidth, double pageheight) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: state.plants.isNotEmpty
            ? Column(
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
              )
            : const Center(child: Text("No plants added")),
      ),
    );
  }

  Flexible headerContainer(double pageWidth) {
    return Flexible(
      child: Container(
          width: pageWidth,
          height: pageWidth / 2.4,
          decoration: BoxDecoration(
            color: Color.fromRGBO(198, 215, 198, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/plant.png",
                  scale: 1,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.make_plants_great_again,
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  SizedBox plantListView(PlantListState state, double pageWidth) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * state.plants.length / 3,
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
          return GestureDetector(
              onTap: () {
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
                  builder: (context) {
                    return PlantDetail(
                        plantName: plant.name,
                        plantColor: plant.color,
                        plantImageURL: plant.imageURL);
                  },
                );
              },
              child: plantContent(plant, pageWidth));
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
