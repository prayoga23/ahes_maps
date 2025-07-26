import 'package:flutter/foundation.dart';
import '../models/jadwal_model.dart';
import '../services/database_service.dart';

class JadwalProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<JadwalModel> _jadwalList = [];
  bool _isLoading = false;
  String _error = '';

  List<JadwalModel> get jadwalList => _jadwalList;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchJadwal() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final jadwalData = await _databaseService.getJadwalKeberangkatan();
      final List<JadwalModel> loadedJadwal = [];
      
      for (var i = 0; i < jadwalData.length; i++) {
        loadedJadwal.add(JadwalModel.fromMap(jadwalData[i], i.toString()));
      }
      
      _jadwalList = loadedJadwal;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}