import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a collection reference
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  // Get a document reference
  DocumentReference document(String path) {
    return _firestore.doc(path);
  }

  // Get jadwal data
  Future<List<Map<String, dynamic>>> getJadwalKeberangkatan() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('jadwal_keberangkatan').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get lokasi fasilitas data
  Future<List<Map<String, dynamic>>> getLokasiFasilitas() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('lokasi_fasilitas').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get jadwal ibadah data
  Future<Map<String, dynamic>> getJadwalIbadah() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('jadwal').doc('ibadah').get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting jadwal ibadah: $e');
      return {};
    }
  }
}
