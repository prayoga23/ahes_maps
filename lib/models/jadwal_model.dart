import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalModel {
  final String id;
  final String title;
  final DateTime tanggal;
  final String deskripsi;
  final String lokasi;

  JadwalModel({
    required this.id,
    required this.title,
    required this.tanggal,
    required this.deskripsi,
    required this.lokasi,
  });

  factory JadwalModel.fromMap(Map<String, dynamic> map, String id) {
    return JadwalModel(
      id: id,
      title: map['title'] ?? '',
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      deskripsi: map['deskripsi'] ?? '',
      lokasi: map['lokasi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'tanggal': tanggal,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
    };
  }
}