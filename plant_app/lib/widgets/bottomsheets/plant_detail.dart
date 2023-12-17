import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantDetail extends StatelessWidget {
  final String plantName;
  final String plantColor;
  final String plantImageURL;
  final double pageWidth;
  final double pageHeight;

  const PlantDetail({
    Key? key,
    required this.plantName,
    required this.plantColor,
    required this.plantImageURL,
    required this.pageWidth,
    required this.pageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.plant_details,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: pageHeight / 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                plantImageURL,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: pageHeight / 40),
            Text(AppLocalizations.of(context)!.plant_type + ": " + plantName,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: pageHeight / 40),
            Text(AppLocalizations.of(context)!.plant_color + ": " + plantColor,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: pageHeight / 40),
          ],
        ),
      ),
    );
  }
}
