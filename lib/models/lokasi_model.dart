import 'package:cloud_firestore/cloud_firestore.dart';

class LokasiModel {
  final String id;
  final String nama;
  final String deskripsi;
  final GeoPoint lokasi;
  final String kategori;
  final String imageUrl;

  LokasiModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.lokasi,
    required this.kategori,
    required this.imageUrl,
  });

  factory LokasiModel.fromMap(Map<String, dynamic> map, String id) {
    return LokasiModel(
      id: id,
      nama: map['nama'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      lokasi: map['lokasi'] ?? const GeoPoint(0, 0),
      kategori: map['kategori'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'kategori': kategori,
      'imageUrl': imageUrl,
    };
  }
}