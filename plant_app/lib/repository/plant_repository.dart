import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:plant_app/models/plant.dart';

class PlantRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _plantsPath = 'plants';

  Future<void> addPlant(String name, String color, File image) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReference =
          _storage.ref().child('$_plantsPath/$imageName.jpg');
      await storageReference.putFile(image);
      String imageURL = await storageReference.getDownloadURL();

      FirebaseFirestore.instance.collection('plants').add({
        'name': name,
        'color': color,
        'imageURL': imageURL,
      });
    } catch (e) {
      print("Hata: $e");
      throw Exception("Bitki eklenirken bir hata oluştu.");
    }
  }

  Future<List<Plant>> getPlants() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection('plants').get();
    return query.docs
        .map((doc) => Plant(
              name: doc['name'],
              color: doc['color'],
              imageURL: doc['imageURL'],
            ))
        .toList();
  }
}
