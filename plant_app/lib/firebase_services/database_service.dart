import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollection {
  final CollectionReference _collection;

  FirebaseCollection(String collectionPath)
      : _collection = FirebaseFirestore.instance.collection(collectionPath);

  Future<void> addDocument(Map<String, dynamic> data) async {
    await _collection.add(data);
  }

  Future<void> updateDocument(
      String documentId, Map<String, dynamic> data) async {
    await _collection.doc(documentId).update(data);
  }

  Future<void> deleteDocument(String documentId) async {
    await _collection.doc(documentId).delete();
  }

  Stream<QuerySnapshot> getDocuments() {
    return _collection.snapshots();
  }
}
