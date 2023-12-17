import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlantDetail extends StatelessWidget {
  final String plantName;
  final String plantColor;
  final String plantImageURL;

  const PlantDetail({
    Key? key,
    required this.plantName,
    required this.plantColor,
    required this.plantImageURL,
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
            // Bottom Sheet içeriği buraya eklenebilir
            Text(
              AppLocalizations.of(context)!.plant_details,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.network(
              plantImageURL,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.plant_type + ": " + plantName,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.plant_color + ": " + plantColor,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
