import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlantBottomSheet extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  final double pageWidth;
  final Function addPlant;
  final Function selectImage;
  final Function textField;

  AddPlantBottomSheet({
    super.key,
    required this.pageWidth,
    required this.addPlant,
    required this.textField,
    required this.nameController,
    required this.colorController,
    required this.selectImage,
  });

  @override
  Widget build(BuildContext context) {
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
              textField(controller: nameController, labelText: "Ex: Rose"),
              SizedBox(height: 20.0),
              Text("Plant color",
                  style: GoogleFonts.manrope(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              textField(controller: colorController, labelText: "Ex: Red"),
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                    nameController.clear();
                    colorController.clear();
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
  }
}
