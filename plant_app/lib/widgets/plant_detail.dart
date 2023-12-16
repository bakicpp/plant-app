import 'package:flutter/material.dart';

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
              'Plant Detail',
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
              'Plant Name: $plantName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Plant Color: $plantColor',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
