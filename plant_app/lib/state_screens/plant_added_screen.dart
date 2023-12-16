import 'package:flutter/material.dart';

class PlantAddedScreen extends StatelessWidget {
  const PlantAddedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      // Ekranın 2 saniye boyunca görünmesini sağlar
      Navigator.of(context).pop(); // Ekranı kapat
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Added"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Plant Added Successfully!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ekranı kapatarak ana sayfaya dön
                Navigator.of(context).pop();
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
