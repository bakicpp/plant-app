import 'dart:io';

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
      // Firestore veya başka bir veritabanına bitki bilgilerini ekleyebilirsiniz.
      // Örneğin: FirebaseFirestore.instance.collection('plants').add({
      //   'name': name,
      //   'color': color,
      //   'imageURL': imageURL,
      // });
    } catch (e) {
      print("Hata: $e");
      throw Exception("Bitki eklenirken bir hata oluştu.");
    }
  }

  Future<List<Plant>> getPlants() async {
    // Firestore'dan bitki bilgilerini getirin ve Bitki listesi olarak döndürün.
    // Örneğin: QuerySnapshot query = await FirebaseFirestore.instance.collection('plants').get();
    // return query.docs.map((doc) => Bitki(
    //   name: doc['name'],
    //   color: doc['color'],
    //   imageURL: doc['imageURL'],
    // )).toList();
    return []; // Bu kısmı kendi veritabanınıza uygun şekilde güncelleyin.
  }
}
