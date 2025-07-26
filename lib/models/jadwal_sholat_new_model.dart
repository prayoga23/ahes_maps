class JadwalSholatModel {
  bool? status;
  String? message;
  Request? request;
  Data? data;

  JadwalSholatModel({this.status, this.message, this.request, this.data});

  JadwalSholatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (request != null) {
      data['request'] = request!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Request {
  String? path;
  String? year;
  String? month;
  String? date;

  Request({this.path, this.year, this.month, this.date});

  Request.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    year = json['year'];
    month = json['month'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['year'] = year;
    data['month'] = month;
    data['date'] = date;
    return data;
  }
}

class Data {
  int? id;
  String? lokasi;
  String? daerah;
  Jadwal? jadwal;

  Data({this.id, this.lokasi, this.daerah, this.jadwal});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lokasi = json['lokasi'];
    daerah = json['daerah'];
    jadwal =
        json['jadwal'] != null ? Jadwal.fromJson(json['jadwal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lokasi'] = lokasi;
    data['daerah'] = daerah;
    if (jadwal != null) {
      data['jadwal'] = jadwal!.toJson();
    }
    return data;
  }
}

class Jadwal {
  String? tanggal;
  String? imsak;
  String? subuh;
  String? terbit;
  String? dhuha;
  String? dzuhur;
  String? ashar;
  String? maghrib;
  String? isya;
  String? date;

  Jadwal(
      {this.tanggal,
      this.imsak,
      this.subuh,
      this.terbit,
      this.dhuha,
      this.dzuhur,
      this.ashar,
      this.maghrib,
      this.isya,
      this.date});

  Jadwal.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    imsak = json['imsak'];
    subuh = json['subuh'];
    terbit = json['terbit'];
    dhuha = json['dhuha'];
    dzuhur = json['dzuhur'];
    ashar = json['ashar'];
    maghrib = json['maghrib'];
    isya = json['isya'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tanggal'] = tanggal;
    data['imsak'] = imsak;
    data['subuh'] = subuh;
    data['terbit'] = terbit;
    data['dhuha'] = dhuha;
    data['dzuhur'] = dzuhur;
    data['ashar'] = ashar;
    data['maghrib'] = maghrib;
    data['isya'] = isya;
    data['date'] = date;
    return data;
  }
}
