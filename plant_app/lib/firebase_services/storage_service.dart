import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(String filePath, String fileName) async {
    try {
      final Reference storageRef = _storage.ref().child(fileName);
      final UploadTask uploadTask = storageRef.putFile(File(filePath));
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      final Reference storageRef = _storage.ref().child(fileName);
      await storageRef.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
