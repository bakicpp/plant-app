import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AddPlantBottomSheet extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  final double pageWidth;
  final double pageHeight;
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
    required this.pageHeight,
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
              SizedBox(height: pageHeight / 40),
              Text(AppLocalizations.of(context)!.add_plant_title + ' 🌿',
                  style: GoogleFonts.manrope(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: pageHeight / 36),
              Text(AppLocalizations.of(context)!.plant_type,
                  style: GoogleFonts.manrope(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: pageHeight / 40),
              textField(
                  controller: nameController,
                  labelText:
                      AppLocalizations.of(context)!.plant_type_placeholder),
              SizedBox(height: pageHeight / 36),
              Text(AppLocalizations.of(context)!.plant_color,
                  style: GoogleFonts.manrope(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: pageHeight / 40),
              textField(
                  controller: colorController,
                  labelText:
                      AppLocalizations.of(context)!.plant_color_placeholder),
              SizedBox(height: pageHeight / 40),
              selectImageSection(context),
              SizedBox(height: pageHeight / 40),
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
                    AppLocalizations.of(context)!.add_plant,
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

  InkWell selectImageSection(BuildContext context) {
    return InkWell(
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
              AppLocalizations.of(context)!.select_image,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
